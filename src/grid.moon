Tile = require 'tile'
local graphics, random

class Grid
  new: (cols, rows) =>
    import graphics from love
    import random from love.math

    @cols = cols
    @rows = rows
    @grid = {}

    for y = 1, rows
      for x = 1, cols
        @grid[(y - 1) * cols + x] = Tile(random(1, 11), x - 1, y - 1)

  draw: =>
    for cell in *@grid do
      cell\draw!
