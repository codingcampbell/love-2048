Game = require 'game'

local scale, scissor, game

import graphics from love

resize = (w, h) ->
  scaleW = w / Game.WIDTH
  scaleH = h / Game.HEIGHT
  scale = math.min(scaleW, scaleH)
  if scale > 1
    scale = math.floor(scale)
  scaledW = scale * Game.WIDTH
  scaledH = scale * Game.HEIGHT
  scissor = { math.floor((w - scaledW) / 2), math.floor((h - scaledH) / 2), scaledW, scaledH }

love.load = ->
  graphics.setDefaultFilter('linear', 'nearest')
  resize(love.window.getWidth!, love.window.getHeight!)

  game = Game!

love.resize = resize

love.update = (dt) ->
  game\update(dt, love.timer.getTime!)

love.draw = ->
  graphics.setScissor(unpack(scissor))
  graphics.setBackgroundColor(0, 0, 0)
  graphics.clear()
  graphics.translate(unpack(scissor))
  graphics.scale(scale, scale)

  game\draw!

  graphics.setColor(255, 0, 0)
  graphics.print(love.timer.getFPS(), 10, 10)
  graphics.setColor(255, 255, 255)

  graphics.setScissor()

love.keyreleased = (key) ->
  if key == 'escape'
    love.event.push('quit')
