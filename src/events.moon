init = (event) =>
  if @_listeners == nil
    @_listeners = {}

  if event != nil and @_listeners[event] == nil
    @_listeners[event] = {}

class Events
  on: (event, callback) =>
    init(@, event)
    table.insert(@_listeners[event], callback)

  emit: (...) =>
    event = ...
    init(@, event)
    for listener in *@_listeners[event]
      listener(select(2, ...))
