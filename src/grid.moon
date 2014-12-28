Assets = require 'assets'
Colors = require 'colors'
local graphics, random, floor, cellSize, cellOffset

class Grid
  CELL_SIZE: 54
  MARGIN: 5

  new: (cols, rows) =>
    import graphics from love
    import random from love.math
    import floor from math

    cellSize = Grid.CELL_SIZE
    cellOffset = cellSize + Grid.MARGIN

    @cols = cols
    @rows = rows
    @grid = {}

    for y = 1, rows
      for x = 1, cols
        pow = random(1, 11)
        value = math.pow(2, pow)

        @grid[(y - 1) * cols + x] = {
          x: x - 1
          y: y - 1
          tx: (x - 1) * cellOffset,
          ty: (y - 1) * cellOffset,
          pow: pow,
          value: value
          color: pow > 2 and Colors.white or Colors.text
          background: Colors[pow + 1]
          textWidth: Assets.font\getWidth(value)
        }

  draw: =>
    for cell in *@grid do
      graphics.setColor(cell.background)
      graphics.rectangle('fill', cell.tx, cell.ty, cellSize, cellSize)
      graphics.setColor(cell.color)
      graphics.print(cell.value, floor(cell.tx + ((cellSize - cell.textWidth) / 2)) + 1, floor(cell.ty + cellSize / 3))

