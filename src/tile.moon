Assets = require 'assets'
Colors = require 'colors'
Constants = require 'constants'
local graphics, cellSize, cellOffset, floor

class Tile
  new: (pow, x, y) =>
    import graphics from love
    import floor from math
    cellSize = Constants.CELL_SIZE
    cellOffset = cellSize + Constants.CELL_MARGIN

    @x = x
    @y = y
    @tx = x * cellOffset
    @ty = y * cellOffset
    @pow = pow
    @value = math.pow(2, pow)
    @text = tostring(@value)
    @color = pow > 2 and Colors.white or Colors.text
    @background = Colors[pow + 1]
    @textWidth = Assets.numbers[pow]\getWidth!

  draw: =>
    graphics.setColor(@background)
    graphics.rectangle('fill', @tx, @ty, cellSize, cellSize)
    graphics.setColor(@color)
    graphics.draw(Assets.numbers[@pow], @tx + floor((cellSize - @textWidth) / 2), @ty + floor((cellSize / 2) - 5))
