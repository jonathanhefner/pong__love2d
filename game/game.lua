require('ball')
require('paddle')
require('score')

COLORS = {
  bg = { 0, 0, 0 },
  fg = { 32, 255, 27 }
}

game = {}

function game:load()
  self.state = 'GAME_OVER'

  self.ball = Ball:new{
    nextServe = 1,
  }

  self.paddles = {
    Paddle:new{
      player = 1,
      moveUpKeys = { 'up', 'w' },
      moveDownKeys = { 'down', 's' },
    },
    Paddle:new{
      player = 2,
      moveUpKeys = { 'i' },
      moveDownKeys = { 'k' },
      useAI = true,
    },
  }

  self.scores = {
    Score:new{ player = 1 },
    Score:new{ player = 2 },
  }

  self.paddles[1]:setX(self.paddles[1].w, 'LEFT')
  self.paddles[1]:setY(H / 2, 'LEFT')
  self.paddles[2]:setX(W - self.paddles[2].w, 'RIGHT')
  self.paddles[2]:setY(H / 2, 'RIGHT')

  love.graphics.setColor(unpack(COLORS.fg))
  -- love.audio.play(music.background)
end

function game:update(dt)
  if self.state == 'PLAYING' then
    self.ball:update(dt)
    self.paddles[1]:update(dt, self.ball)
    self.paddles[2]:update(dt, self.ball)
    self.scores[1]:update(dt, self.ball)
    self.scores[2]:update(dt, self.ball)

    if self.ball.nextServe then
      self.paddles[self.ball.nextServe]:serve(self.ball)
    end
  end
end

function game:draw()
  if self.state ~= 'GAME_OVER' then
    self.ball:draw()
  end
  self.paddles[1]:draw()
  self.paddles[2]:draw()
  self.scores[1]:draw()
  self.scores[2]:draw()
end

function game:keypressed(key)
  if key == 'space' then
    self.state = (self.state == 'PLAYING') and 'PAUSED' or 'PLAYING'
    return true
  elseif key == '1' then
    self.paddles[2].useAI = true
    return true
  elseif key == '2' then
    self.paddles[2].useAI = false
    return true
  end
end
