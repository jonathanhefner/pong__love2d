require('util')

Score = Class:new{
  player = nil,
  value = 0,
}

function Score:initialize()
  self.x = (self.player - 1) * W / 2
  self.y = H / 64
  self.goalX = (self.player % 2) * W
  self.ballEdge = PART_OPPOSITE[PLAYER_SIDE[self.player]]
end

function Score:update(dt, ball)
  if ball:tryBounceX(self.ballEdge, self.goalX, dt, sounds.score) then
    self.value = self.value + 1
    ball.nextServe = self.player
  end
end

function Score:draw()
  love.graphics.printf(self.value, self.x, self.y, W / 2, 'center')
end
