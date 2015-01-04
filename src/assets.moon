local graphics, audio

class Assets
  new: =>
    @muted = false

  play: (sound) =>
    if @muted
      return

    @sounds[sound]\stop!
    @sounds[sound]\play!

  load: =>
    import graphics, audio from love

    @font = graphics.newFont('kenvector_future_thin.ttf', 16)
    @numbers = {}
    for j = 1, 11
      @numbers[j] = graphics.newImage("images/pow-#{j}.png")

    @sounds =
      move: audio.newSource('sounds/cardSlide3.ogg', 'static')
      score: audio.newSource('sounds/cardSlide7.ogg', 'static')

return Assets!
