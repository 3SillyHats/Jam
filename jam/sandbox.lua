local M = {}

M.new = function (f, env)
  return function ()
    setfenv(f, env)
    local _, s = assert(pcall(f))
    return s
  end
end

return M
