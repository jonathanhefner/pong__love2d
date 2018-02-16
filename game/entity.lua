require('util')

Entity = Class:new{
  image = nil,
  w = 0, h = 0,
  x = 0, y = 0,
  dx = 0, dy = 0,
}

function Entity:initialize()
  if self.image then
    self.w = self.image:getWidth() * SCALE
    self.h = self.image:getHeight() * SCALE
  end
end

function Entity:update(dt)
  self.x = self.x + self.dx * dt
  self.y = self.y + self.dy * dt
end

function Entity:draw()
  if self.image then
    love.graphics.draw(self.image, self.x, self.y, 0, SCALE, SCALE)
  end
end

function Entity:getX(part)
  return self.x + self.w * PART_W_OFFSET[part or 'TOPLEFT']
end

function Entity:getY(part)
  return self.y + self.h * PART_H_OFFSET[part or 'TOPLEFT']
end

function Entity:setX(x, part)
  self.x = x - self.w * PART_W_OFFSET[part or 'TOPLEFT']
end

function Entity:setY(y, part)
  self.y = y - self.h * PART_H_OFFSET[part or 'TOPLEFT']
end
