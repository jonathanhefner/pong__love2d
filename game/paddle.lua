require('util')
require('entity')
require('ball')

Paddle = Entity:new{
  player = nil,
  moveUpKeys = {},
  moveDownKeys = {},
  useAI = false,
}

Paddle.MAX_DY = Ball.MAX_DY * 0.8 -- per second
Paddle.DDY = Paddle.MAX_DY / 1.5 -- per second^2 (1.5 seconds to reach max speed)

function Paddle:initialize()
  self.image = images.paddle
  Entity.initialize(self)
  self.ballEdge = PLAYER_SIDE[self.player]
  self.edge = PART_OPPOSITE[self.ballEdge]
  self.xdir = EDGE_DIRECTION[self.edge]
end

function Paddle:update(dt, ball)
  local ydir = 0
  if self.useAI then
    if ball.dx > 0 and ball.x > W/4 then
      local ballMid = ball:getY('LEFT')
      local ballBtm = ball:getY('BOTTOM')
      local selfMid = self:getY('LEFT')
      local selfBtm = self:getY('BOTTOM')
      if (ball.dy >= 0 and ball.y > selfMid) or (ball.dy < 0 and ballMid > selfBtm) then
        ydir = 1
      elseif (ball.dy >= 0 and ballMid < self.y) or (ball.dy < 0 and ballBtm < selfMid) then
        ydir = -1
      end
    end
  else
    if love.keyboard.isDown(unpack(self.moveUpKeys)) then
      ydir = -1
    elseif love.keyboard.isDown(unpack(self.moveDownKeys)) then
      ydir = 1
    end
  end

  if util.sign(ydir) ~= util.sign(self.dy) then
    self.dy = 0
  end
  self:accelerate(ydir, dt)

  Entity.update(self, dt)

  self.y = util.clamp(self.y, 0, H - self.h)

  if ball.y + ball.h >= self.y and ball.y <= self.y + self.h then
    if ball:tryBounceX(self.ballEdge, self:getX(self.edge), dt, sounds.hit) then
      ball.dy = Ball.MAX_DY * (ball.y - self.y) / (self.h + ball.h * 2)
    end
  end
end

function Paddle:accelerate(ydir, dt)
  self.dy = util.clamp(self.dy + ydir * self.DDY * dt, -self.MAX_DY, self.MAX_DY)
end

function Paddle:serve(ball)
  ball:setX(self:getX(self.edge), self.ballEdge)
  ball:setY(self.h / 2, self.ballEdge)
  ball.dx = Ball.MAX_DX * self.xdir
  ball.dy = Ball.MAX_DX
  ball.nextServe = nil
  -- sounds.hit:play() -- conflicts with sounds.score
end
