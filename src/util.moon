{
  mixin: (toClass) =>
    for k,v in pairs(toClass.__index)
      if type(v) == 'function' and @@__base.__index[k] == nil
        @@__base.__index[k] = v

  bind: (fn) =>
    scope = @
    return (...) -> fn(scope, ...)
}
