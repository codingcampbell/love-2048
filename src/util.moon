{
  mixin: (toClass) =>
    for k,v in pairs(toClass.__index)
      if type(v) == 'function' and @@__base.__index[k] == nil
        @@__base.__index[k] = v

  serialize: (tbl) ->
    result = {}
    for k, v in pairs(tbl)
      table.insert(result, "#{k}=#{v}")

    return table.concat(result, "\r\n") .. "\r\n"

  deserialize: (data) ->
    result = {}
    for line in data\gmatch("([^\r\n]+)\r?\n")
      key, val = line\gmatch('([^=]+)=(.+)')!
      result[key] = val

    return result
}
