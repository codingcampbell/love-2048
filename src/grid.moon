Constants = require 'constants'
Colors = require 'colors'
Tile = require 'tile'
local graphics, random, cellSize, cellOffset

class Grid
  new: (cols, rows) =>
    import graphics from love
    import random from love.math
    cellSize = Constants.CELL_SIZE
    cellOffset = cellSize + Constants.CELL_MARGIN

    @cols = cols
    @rows = rows
    @grid = {}

    for y = 1, rows
      for x = 1, cols
        @grid[(y - 1) * cols + x] = Tile(0, x - 1, y - 1)

    for x = 1, 2
      @getRandomEmptyCell!\setPow(random(1, 2))

  getCell: (x, y) => @grid[(y - 1) * @cols + x]

  getRandomEmptyCell: =>
    cell = @getCell(random(1, @cols), random(1, @rows))
    if cell.pow == 0
      return cell

    return @getRandomEmptyCell!

  draw: =>
    -- draw grid
    graphics.setColor(Colors[1])
    for y = 0, @rows - 1
      for x = 0, @cols - 1
        graphics.rectangle('fill', x * cellOffset, y * cellOffset, cellSize, cellSize)

    -- draw cells
    for cell in *@grid do
      cell\draw!
