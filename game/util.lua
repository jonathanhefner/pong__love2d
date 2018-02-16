util = {}

function util.clamp(x, min, max)
  return x < min and min or (x > max and max or x)
end

function util.sign(x)
  return x < 0 and -1 or (x > 0 and 1 or 0)
end



Class = {}

function Class:new(t)
  t = t or {}
  setmetatable(t, self)
  self.__index = self
  t:initialize()
  return t
end

function Class:initialize()
end



PART_W_OFFSET = {
  TOPLEFT = 0, TOP = 0.5, TOPRIGHT = 1,
  LEFT = 0, RIGHT = 1,
  BOTTOMLEFT = 0, BOTTOM = 0.5, BOTTOMRIGHT = 1,
}

PART_H_OFFSET = {
  TOPLEFT = 0, TOP = 0, TOPRIGHT = 0,
  LEFT = 0.5, RIGHT = 0.5,
  BOTTOMLEFT = 1, BOTTOM = 1, BOTTOMRIGHT = 1,
}

PART_OPPOSITE = {
  TOPLEFT = 'BOTTOMRIGHT', TOP = 'BOTTOM', TOPRIGHT = 'BOTTOMLEFT',
  LEFT = 'RIGHT', RIGHT = 'LEFT',
  BOTTOMLEFT = 'TOPRIGHT', BOTTOM = 'TOP', BOTTOMRIGHT = 'TOPLEFT',
}

EDGE_DIRECTION = {
  TOP = -1, BOTTOM = 1,
  LEFT = -1, RIGHT = 1,
}

PLAYER_SIDE = { 'LEFT', 'RIGHT' }
