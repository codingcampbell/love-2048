Constants = require 'constants'
Colors = require 'colors'
Tile = require 'tile'
Util = require 'util'
Events = require 'events'
local graphics, timer, random, cellSize, cellOffset

getCell = (x, y) => @grid[(y - 1) * @cols + x]

getRandomEmptyCell = =>
  cell = getCell(@, random(1, @cols), random(1, @rows))
  if cell.pow == 0
    return cell

  return getRandomEmptyCell(@)

swapCell = (x1, y1, x2, y2) =>
  @grid[(y1 - 1) * @cols + x1], @grid[(y2 - 1) * @cols + x2] = getCell(@, x2, y2), getCell(@, x1, y1)
  @moveCount += 1

mergeCell = (fromCell, toCell) =>
  if fromCell.pow != 0 and fromCell.pow == toCell.pow
    fromCell\setPow(fromCell.pow + 1)
    toCell\setPow(0)
    fromCell\tween('scale', 1, 1.25, 0.2, 'bounce')
    @moveCount += 1
    @tileCount -= 1
    @emit('score', fromCell.value)

spawnRandomCell = =>
  cell = getRandomEmptyCell(@)
  cell\setPow(random() < 0.9 and 1 or 2)
  cell\tween('scale', 0.1, 1, 0.2)
  @tileCount += 1

mergeHoriz = (start, target, dir) =>
  for y = 1, @rows
    for x = start, target, -dir
      mergeCell(@, getCell(@, x + dir, y), getCell(@, x, y))

mergeVert = (start, target, dir) =>
  for x = 1, @cols
    for y = start, target, -dir
      mergeCell(@, getCell(@, x, y + dir), getCell(@, x, y))

shiftHoriz = (start, target, dir) =>
  for y = 1, @rows
    for x = start, target, -dir
      if getCell(@, x, y).pow == 0 and getCell(@, x - dir, y).pow != 0
        swapCell(@, x, y, x - dir, y)
        return shiftHoriz(@, start, target, dir)

shiftVert = (start, target, dir) =>
  for x = 1, @cols
    for y = start, target, -dir
      if getCell(@, x, y).pow == 0 and getCell(@, x, y - dir).pow != 0
        swapCell(@, x, y, x, y - dir)
        return shiftVert(@, start, target, dir)

alignTiles = =>
  local cell
  duration = 0.1
  @moveEndTime = timer.getTime! + duration

  for y = 1, @rows
    for x = 1, @cols
      cell = getCell(@, x, y)
      cell\tween('x', cell.x, (x - 1) * cellOffset, cell.pow > 0 and duration or 0)
      cell\tween('y', cell.y, (y - 1) * cellOffset, cell.pow > 0 and duration or 0)

isGameOver = =>
  if @tileCount < @cols * @rows
    return false

  local cell
  for y = 1, @rows
    for x = 1, @cols
      cell = getCell(@, x, y)
      if cell.pow != 0
        if x > 1 and cell.pow == getCell(@, x - 1, y).pow
          return false

        if x < @cols and cell.pow == getCell(@, x + 1, y).pow
          return false

        if y > 1 and cell.pow == getCell(@, x, y - 1).pow
          return false

        if y < @rows and cell.pow == getCell(@, x, y + 1).pow
          return false

  return true

moveStart = =>
  @moveCount = 0

moveEnd = =>
  if @moveCount > 0
    spawnRandomCell(@)

  @gameOver = isGameOver(@)
  if @gameOver
    print('game over')

  @emit('moveEnd')

class Grid
  new: (cols, rows) =>
    import graphics, timer from love
    import random from love.math
    cellSize = Constants.CELL_SIZE
    cellOffset = cellSize + Constants.CELL_MARGIN

    @cols = cols
    @rows = rows
    @grid = {}
    @moveCount = 0
    @tileCount = 0
    @gameOver = false
    @moveEndTime = 0

    for y = 1, rows
      for x = 1, cols
        @grid[(y - 1) * cols + x] = Tile(0, (x - 1) * cellOffset, (y - 1) * cellOffset)

    for x = 1, 2
      spawnRandomCell(@)

  moveLeft: =>
    moveStart(@)
    shiftHoriz(@, 1, @cols - 1, -1)
    mergeHoriz(@, 2, @cols, -1)
    shiftHoriz(@, 1, @cols - 1, -1)
    alignTiles(@)

  moveRight: =>
    moveStart(@)
    shiftHoriz(@, @cols, 2, 1)
    mergeHoriz(@, @cols - 1, 1, 1)
    shiftHoriz(@, @cols, 2, 1)
    alignTiles(@)

  moveUp: =>
    moveStart(@)
    shiftVert(@, 1, @rows - 1, -1)
    mergeVert(@, 2, @rows, -1)
    shiftVert(@, 1, @rows - 1, -1)
    alignTiles(@)

  moveDown: =>
    moveStart(@)
    shiftVert(@, @rows, 2, 1)
    mergeVert(@, @rows - 1, 1, 1)
    shiftVert(@, @rows, 2, 1)
    alignTiles(@)

  update: (dt, time) =>
    if @moveEndTime > 0 and time >= @moveEndTime
      @moveEndTime = 0
      moveEnd(@)

    for cell in *@grid do
      cell\update(dt, time)

  draw: =>
    -- draw grid
    graphics.setColor(Colors[1])
    for y = 0, @rows - 1
      for x = 0, @cols - 1
        graphics.rectangle('fill', x * cellOffset, y * cellOffset, cellSize, cellSize)

    -- draw cells
    for cell in *@grid do
      cell\draw!

Util.mixin(Grid, Events)
return Grid
