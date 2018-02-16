require('util')
require('entity')

Ball = Entity:new{
  nextServe = nil,
  x = 1, y = 1, -- don't spawn on goal or screen (bounce) boundary
}

Ball.MAX_DX = 128 * SCALE -- per second
Ball.MAX_DY = Ball.MAX_DX * 8 -- per second
Ball.dx = Ball.MAX_DX
Ball.dy = Ball.dx

function Ball:initialize()
  self.image = images.ball
  Entity.initialize(self)
end

function Ball:update(dt)
  Entity.update(self, dt)

  self:tryBounceY('TOP', 0, dt)
  self:tryBounceY('BOTTOM', H, dt)
end

function Ball:tryBounceX(edge, aboutX, dt, sound)
  local currX = self:getX(edge)
  if EDGE_DIRECTION[edge] * (aboutX - currX) <= 0 then
    local newX = -currX + 2 * aboutX
    local maxMove = math.abs(self.dx) * dt -- smooth perpendicular collision
    self:setX(util.clamp(newX, currX - maxMove, currX + maxMove), edge)
    self.dx = math.abs(self.dx) * -EDGE_DIRECTION[edge]
    ;(sound or sounds.bounce):play()
    return true
  end
end

function Ball:tryBounceY(edge, aboutY, dt, sound)
  local currY = self:getY(edge)
  if EDGE_DIRECTION[edge] * (aboutY - currY) <= 0 then
    local newY = -currY + 2 * aboutY
    local maxMove = math.abs(self.dy) * dt -- smooth perpendicular collision
    self:setY(util.clamp(newY, currY - maxMove, currY + maxMove), edge)
    self.dy = math.abs(self.dy) * -EDGE_DIRECTION[edge]
    ;(sound or sounds.bounce):play()
    return true
  end
end
