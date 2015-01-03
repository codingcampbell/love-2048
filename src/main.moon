Constants = require 'constants'
Game = require 'game'

local scale, scissor, game

import graphics from love

resize = (w, h) ->
  scaleW = w / Constants.GAME_WIDTH
  scaleH = h / Constants.GAME_HEIGHT
  scale = math.min(scaleW, scaleH)
  if scale > 1
    scale = math.floor(scale)
  scaledW = scale * Constants.GAME_WIDTH
  scaledH = scale * Constants.GAME_HEIGHT
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

  graphics.setColor(255, 255, 255)
  graphics.print(love.timer.getFPS!, Constants.GAME_WIDTH - 25, Constants.GAME_HEIGHT - 20, 0)

  graphics.setScissor()

love.keypressed = (key) ->
  if key == 'escape'
    return love.event.push('quit')

  game\keypressed(key)

love.keyreleased = (key) ->
  if key == 'escape'
    return love.event.push('quit')
