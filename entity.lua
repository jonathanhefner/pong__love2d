-- ahh, the classic Entity ...thing... where would any game be without one? :)

EntityMeta = { __index = (function(t, key) return rawget(t, key) or EntityMeta[key] end) }


function EntityMeta:draw()
  love.graphics.draw(self.image, self.x, self.y, 0, SCALE, SCALE)
end


function EntityMeta:bound(x, y)
  self.x = x or self.x or 0
  self.w = self.image:getWidth()*SCALE
  self.x2 = self.x + self.w
  
  self.y = y or self.y or 0
  self.h = self.image:getHeight()*SCALE
  self.y2 = self.y + self.h
end


function Entity(image, t)
  t = t or {}
  setmetatable(t, EntityMeta)
  
  t.image = image
  t:bound()
  t.dx = t.dx or 0
  t.dy = t.dy or 0
  
  return t
end