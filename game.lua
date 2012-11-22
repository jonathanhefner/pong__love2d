require('entity')

COLORS = {
  bg = { 0, 0, 0 },
  fg = { 32, 255, 27 }
}

BALL_SPEED = 128 * SCALE -- per second
PADDLE_MAX_SPEED = BALL_SPEED -- per second
PADDLE_ACCELERATION_TIME = 0.25 -- seconds
PADDLE_ACCELERATION = PADDLE_MAX_SPEED/PADDLE_ACCELERATION_TIME -- per second^2


game = {}

function game:load()
  self.state = 'GAME_OVER'
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
  local margin = love.graphics.getHeight()/64
  local x_mid = love.graphics.getWidth()/2
  love.graphics.printf(self.scores[1], 0, margin, x_mid - margin, 'right')
  love.graphics.printf(self.scores[2], x_mid + margin, margin, love.graphics.getWidth(), 'left')
  
  -- ball
  if self.state ~= 'GAME_OVER' then
    self.ball:draw()
  end
end


function game:keypressed(key)
  if key == ' ' then
    self.state = (self.state == 'PLAYING') and 'PAUSED' or 'PLAYING'
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
  self.y = images.paddle:getHeight()/2 - images.ball:getHeight()/2
  self.dy = BALL_SPEED
  
  if lastScored == 2 then
    self.x = love.graphics.getWidth() - images.paddle:getWidth()*3 - images.ball:getWidth()
    self.dx = -BALL_SPEED
  else
    self.x = images.paddle:getWidth()*3
    self.dx = BALL_SPEED
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

  
  -- make AI a little slow to react
  local p2_ymid = (self[2].y + self[2].y2) / 2
  if game.ball.y > p2_ymid then
    self[2].dir = 1
  elseif game.ball.y2 < p2_ymid then
    self[2].dir = -1
  else
    self[2].dir = 0
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


