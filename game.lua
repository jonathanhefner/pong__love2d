require('entity')

COLORS = {
  bg = { 0, 0, 0 },
  fg = { 32, 255, 27 }
}

BALL_DX = 128 * SCALE -- per second
BALL_MAX_DY = 8 * BALL_DX -- per second
PADDLE_MAX_SPEED = 0.95 * BALL_MAX_DY -- per second
PADDLE_ACCELERATION_TIME = 1.5 -- seconds
PADDLE_ACCELERATION = PADDLE_MAX_SPEED/PADDLE_ACCELERATION_TIME -- per second^2


game = {}

function game:load()
  self.state = 'GAME_OVER'
  self.players = 1
  self.scores = { 0, 0 }
  self.ball = Entity(images.ball, {
    update = ball_update,
    reset = ball_reset
  })
    
  self.paddles = {
    Entity(images.paddle, { dir=0 }),
    Entity(images.paddle, { dir=0 }),
    update = paddles_update,
    reset = paddles_reset
  }
  
  love.graphics.setColor(unpack(COLORS.fg))
  self.ball:reset(1)
  self.paddles:reset()
  -- love.audio.play(music.background)
end


function game:update(dt)
  if self.state == 'PLAYING' then
    local scored = self.ball:update(dt)
    if scored then
      self.scores[scored] = self.scores[scored] + 1
      self.paddles:reset()
    else
      self.paddles:update(dt)
    end
  end
end


function game:draw()
  -- paddles
  self.paddles[1]:draw()
  self.paddles[2]:draw()

  -- score
  local top_margin = H/64
  local print_width = W/2
  love.graphics.printf(self.scores[1], 0, top_margin, print_width, 'center')
  love.graphics.printf(self.scores[2], print_width, top_margin, print_width, 'center')
  
  -- ball
  if self.state ~= 'GAME_OVER' then
    self.ball:draw()
  end
end


function game:keypressed(key)
  if key == ' ' then
    self.state = (self.state == 'PLAYING') and 'PAUSED' or 'PLAYING'
  elseif key == '1' then
    self.players = 1
  elseif key == '2' then
    self.players = 2
  else
    return false
  end

  return true
end




-- Ball

function ball_update(self, dt)
  self:bound(self.x + self.dx*dt, self.y + self.dy*dt)
  
  -- this is why bounding box/collision detection should be wrapped up in a neat library :)
  if self.x <= game.paddles[1].x2 then
    if self.y > game.paddles[1].y2 or self.y2 < game.paddles[1].y then
      love.audio.play(sounds.score)
      self:reset(2)
      return 2 -- player 2 scored
    else
      love.audio.play(sounds.hit)
      self.x = -self.x + 2*(game.paddles[1].x2)
      self.dx = -self.dx
      self.dy = BALL_MAX_DY * (self.y_mid - game.paddles[1].y_mid) / (game.paddles[1].h + self.h*2)
    end
    
  elseif self.x2  >= game.paddles[2].x then
    if self.y > game.paddles[2].y2 or self.y2 < game.paddles[2].y then
      love.audio.play(sounds.score)
      self:reset(1)
      return 1 -- player 1 scored
    else
      love.audio.play(sounds.hit)
      self.x = self.x - 2*(self.x2 - game.paddles[2].x)
      self.dx = -self.dx
      self.dy = BALL_MAX_DY * (self.y_mid - game.paddles[2].y_mid) / (game.paddles[2].h + self.h*2)
    end
  
  elseif self.y <= 0 then 
    love.audio.play(sounds.bounce)
    self.y = -self.y
    self.dy = -self.dy
    
  elseif self.y2 >= H then
    love.audio.play(sounds.bounce)
    self.y = -self.y + 2*(H - self.h)
    self.dy = -self.dy  
  
  end
end


function ball_reset(self, lastScored)
  self.y = game.paddles[1].h/2 - self.h/2
  self.dy = BALL_DX -- start with dx == dy
  
  if lastScored == 2 then
    self.x = W - game.paddles[1].w*3 - self.w
    self.dx = -BALL_DX
  else
    self.x = game.paddles[1].w*3
    self.dx = BALL_DX
  end
  
  self:bound()
end




-- Paddles

function paddles_update(self, dt)
  if love.keyboard.isDown('up', 'w') then
    self[1].dir = -1
  elseif love.keyboard.isDown('down', 's') then
    self[1].dir = 1
  else
    self[1].dir = 0
  end


  if game.players == 1 then
    -- make AI a little slower to react to bounces on its side of the court
    if ((game.ball.x < W/2 or self[2].y2 < H) and game.ball.y_mid < self[2].y_mid)
        or game.ball.y2 < self[2].y_mid then
      self[2].dir = -1
    elseif ((game.ball.x < W/2 or self[2].y > 0) and game.ball.y_mid > self[2].y_mid)
        or game.ball.y > self[2].y_mid then
      self[2].dir = 1
    else
      self[2].dir = 0
    end
  else
    if love.keyboard.isDown('i') then
      self[2].dir = -1
    elseif love.keyboard.isDown('k') then
      self[2].dir = 1
    else
      self[2].dir = 0
    end
  end


  for i, p in ipairs(self) do
    if p.dir == 0 then
      p.dy = 0
    else
      if p.dir * p.dy < 0 then -- change in direction (different sign)
        p.dy = 0
      end
      
      p.dy = p.dy + (p.dir * PADDLE_ACCELERATION * dt)
      p.dy = math.min(math.max(p.dy, -PADDLE_MAX_SPEED), PADDLE_MAX_SPEED)
    end
    
    local y = p.y + p.dy * dt
    p:bound(nil, math.min(math.max(y, 0), H - p.h))
  end
end


function paddles_reset(self)
  local y = H/2 - self[1].h/2

  self[1]:bound(self[1].w, y)
  self[2]:bound(W - self[2].w*2, y)
end


