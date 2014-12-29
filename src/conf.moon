Constants = require 'constants'

love.conf = (t) ->
  with t.window
    .title = '2048'
    .width = Constants.GAME_WIDTH
    .height = Constants.GAME_HEIGHT
    .resizable = true
    .fullscreen = false
    .vsync = true

  with t.modules
    .audio = true
    .event = true
    .graphics = true
    .image = true
    .joystick = true
    .keyboard = true
    .math = true
    .mouse = false
    .physics = false
    .sound = true
    .system = true
    .thread = false
    .timer = true
    .window = true
