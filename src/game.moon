Assets = require 'assets'
Grid = require 'grid'
Colors = require 'colors'

local graphics

class Game
  new: =>
    import graphics from love

    Assets\load!
    graphics.setFont(Assets.font)

    @grid = Grid(4, 4)

  update: (dt, time) =>

  draw: =>
    graphics.setBackgroundColor(Colors.background)
    graphics.clear!
    graphics.translate(5, 5)
    @grid\draw!

  keypressed: (key) =>
    if key == 'left'
      @grid\moveLeft!

    if key == 'right'
      @grid\moveRight!

    if key == 'up'
      @grid\moveUp!

    if key == 'down'
      @grid\moveDown!
