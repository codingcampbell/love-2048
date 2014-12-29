local graphics

class Assets
  new: =>

  load: =>
    import graphics from love

    @font = graphics.newFont('kenvector_future_thin.ttf', 16)
    @numbers = {}
    for j = 1, 11
      @numbers[j] = graphics.newImage("images/pow-#{j}.png")

return Assets!
