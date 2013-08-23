local M = {}

local assets = {}
local loaders = {}

local findPattern = function (text, pattern, start)
  return string.sub(text, string.find(text, pattern, start))
end

-- TODO: use coroutines to not block on loading?

--- Load an asset.
M.load = function (name)
  local extension = findPattern(name, "[.][^/]+$")
  local loader = assert(loaders[extension],
    "loading: " .. name .. ": no loader for " .. extension .. " files"
  )
  assets[name] = loader(name)
end

--- Get an asset.
M.get = function (name)
  if assets[name] == nil then
    M.load(name)
  end
  return assets[name]
end

--- Set loader for files with a given extension.
M.setLoader = function (extension, loader)
  loaders[extension] = loader
end

-- Set default asset loaders.
M.setLoader(".lua", love.filesystem.load)
M.setLoader(".png", love.graphics.newImage)
M.setLoader(".wav", function (x)
  return love.audio.newSource(x, "static")
end)
M.setLoader(".ogg", function (x)
  return love.audio.newSource(x, "stream")
end)

return M
