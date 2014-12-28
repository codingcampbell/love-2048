local graphics

class Game
  WIDTH: 320
  HEIGHT: 240

  new: =>
    import graphics from love
    @font = graphics.newFont('kenpixel_mini.ttf', 16)
    graphics.setFont(@font)

  update: (dt, time) =>

  draw: =>
    graphics.setColor(0, 0, 255)
    graphics.rectangle('fill', 100, 10, 100, 100)
