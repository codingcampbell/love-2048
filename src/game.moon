Assets = require 'assets'
Colors = require 'colors'
Constants = require 'constants'
Grid = require 'grid'
Util = require 'util'

local graphics, keyboard

setScore = (score, value) =>
  score.value = value
  score.width = Assets.font\getWidth(tostring(value))

class Game
  new: =>
    import graphics, keyboard from love

    Assets\load!
    graphics.setFont(Assets.font)

    @scores =
      current: {}
      best: { value: 0 }

    @grid = Grid(4, 4)

    @grid\on 'score', (score) ->
      totalScore = @scores.current.value + score
      setScore(@, @scores.current, totalScore)

      if totalScore > @scores.best.value
        setScore(@, @scores.best, totalScore)

    @grid\on 'moveEnd', ->
      @locked = false

    @reset!
    @load!

  reset: =>
    @locked = false
    setScore(@, @scores.current, 0)
    setScore(@, @scores.best, @scores.best.value)
    @grid\reset!

  save: =>
    data = Util.serialize({
      score: @scores.current.value
      best: @scores.best.value
      grid: @grid\serialize!
    })

    love.filesystem.write('data.sav', data, #data)

  load: =>
    data = love.filesystem.read('data.sav')
    if data == nil
      return

    state = Util.deserialize(data)

    if state.score
      setScore(@, @scores.current, tonumber(state.score) or 0)

    if state.best
      setScore(@, @scores.best, tonumber(state.best) or 0)

    if state.grid
      @grid\deserialize(state.grid)

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
    graphics.print(@scores.current.value, panelX + math.floor((panelWidth - @scores.current.width) / 2), 20)

    graphics.setColor(Colors.text)
    graphics.print('Best', Constants.GAME_WIDTH - 63, 50)
    graphics.setColor(255, 255, 255)
    graphics.print(@scores.best.value, panelX + math.floor((panelWidth - @scores.best.width) / 2), 70)

  keypressed: (key) =>
    if key == 'tab' or key == 'backspace'
      if keyboard.isDown('tab') and keyboard.isDown('backspace')
        @reset!

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
