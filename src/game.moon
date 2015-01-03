Assets = require 'assets'
Colors = require 'colors'
Constants = require 'constants'
Grid = require 'grid'
Util = require 'util'

local graphics

setScore = (score) =>
  @score = score
  @scoreWidth = Assets.font\getWidth(tostring(@score))

class Game
  new: =>
    import graphics from love

    Assets\load!
    graphics.setFont(Assets.font)

    @locked = false
    setScore(@, 0)

    @grid = Grid(4, 4)

    @grid\on 'score', Util.bind @, (score) =>
      setScore(@, @score + score)

    @grid\on 'moveEnd', Util.bind @, =>
      @locked = false

  update: (dt, time) =>
    @grid\update(dt, time)

  draw: =>
    graphics.setBackgroundColor(Colors.background)
    graphics.clear!
    graphics.translate(5, 5)
    @grid\draw!
    graphics.translate(-5, -5)

    panelX = @grid.cols * Constants.CELL_SIZE + (@grid.cols) * Constants.CELL_MARGIN
    panelWidth = Constants.GAME_WIDTH - panelX
    graphics.setColor(Colors.text)
    graphics.print('Score', Constants.GAME_WIDTH - 70, 2)
    graphics.setColor(255, 255, 255)
    graphics.print(@score, panelX + math.floor((panelWidth - @scoreWidth) / 2), 20)

  keypressed: (key) =>
    if @locked
      return

    if key == 'left'
      @locked = true
      @grid\moveLeft!

    if key == 'right'
      @locked = true
      @grid\moveRight!

    if key == 'up'
      @locked = true
      @grid\moveUp!

    if key == 'down'
      @locked = true
      @grid\moveDown!
