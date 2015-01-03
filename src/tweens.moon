local timer

init = =>
  if @_tweens == nil
    import timer from love
    @_tweens = {}

easing =
  linear: (fromVal, toVal, progress) -> fromVal + (toVal - fromVal) * progress
  bounce: (fromVal, toVal, progress) -> fromVal + (toVal - fromVal) * math.sin(math.pi * progress)

class Tweens
  tween: (prop, fromVal, toVal, duration, ease='linear') =>
    init(@)
    @[prop] = fromVal
    @_tweens[prop] =
      prop: prop
      fromVal: fromVal
      toVal: toVal
      startTime: timer.getTime!
      duration: duration
      easing: easing[ease]

  updateTweens: (dt, time) =>
    init(@)

    for prop, tween in pairs(@_tweens)
      if tween != nil
        @[prop] = tween.easing(tween.fromVal, tween.toVal, math.min(1, (time - tween.startTime) / tween.duration))

        if time - tween.startTime >= tween.duration
          @_tweens[prop] = nil
