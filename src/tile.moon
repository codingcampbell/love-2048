Assets = require 'assets'
Colors = require 'colors'
Constants = require 'constants'
local graphics, cellSize, floor

class Tile
  new: (pow, x, y) =>
    import graphics from love
    import floor from math
    cellSize = Constants.CELL_SIZE

    @x = x
    @y = y
    @setPow(pow)
    @scale = 1

  setPow: (pow) =>
    @pow = pow
    @value = math.pow(2, pow)
    @text = tostring(@value)
    @color = pow > 2 and Colors.white or Colors.text
    @background = Colors[pow + 1]
    @textWidth = pow > 0 and Assets.numbers[pow]\getWidth! or 0

  draw: =>
    if @pow == 0
      return

    translate = (cellSize - cellSize * @scale) / 2
    graphics.push!
    graphics.translate(@x + translate, @y + translate)
    graphics.scale(@scale, @scale)

    graphics.setColor(@background)
    graphics.rectangle('fill', 0, 0, cellSize, cellSize)
    graphics.setColor(@color)
    graphics.draw(Assets.numbers[@pow], floor((cellSize - @textWidth) / 2), floor((cellSize / 2) - 5))

    graphics.pop!
