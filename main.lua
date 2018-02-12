debug = true

require('game')

function love.load()
  images = {}
  local image_names = { 'paddle', 'ball' }
  for _, n in ipairs(image_names) do
    images[n] = love.graphics.newImage('images/' .. n .. '.png')
    images[n]:setFilter('nearest', 'nearest')
  end

  sounds = {}
  local sound_names = { 'hit', 'bounce', 'score' }
  for _, n in ipairs(sound_names) do
    sounds[n] = love.audio.newSource('sounds/' .. n .. '.ogg', 'static')
  end

  music = {}
  local music_names = {}
  for n, s in pairs(music_names) do
    music[n] = love.audio.newSource('music/' .. n .. '.ogg', 'stream')
    music:setLooping(true)
  end

  local font = love.graphics.newFont('fonts/silkscreen.ttf', 64 * SCALE)
  love.graphics.setFont(font)

  W, H = love.graphics.getWidth(), love.graphics.getHeight()
  game:load()
end


function love.update(dt)
  W, H = love.graphics.getWidth(), love.graphics.getHeight()
  game:update(dt)
end


function love.draw()
  game:draw()
end


function love.keypressed(key)
  if not game:keypressed(key) then
    if key == 'escape' or (key == 'f4' and love.keyboard.isDown('lalt', 'ralt')) then
      love.event.push('quit')
    end
  end
end
