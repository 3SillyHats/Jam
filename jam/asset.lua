local PATH = "game/"

local M = {}

local assets = {}
local loaders = {}

local findPattern = function (text, pattern, start)
  return string.sub(text, string.find(text, pattern, start))
end

-- TODO: use coroutines to not block on loading?

--- Load an asset.
M.load = function (name)
  local dir = findPattern(name, "^[^/]+")
  local loader = assert(loaders[dir],
    "loading: " .. name .. ": no loader for directory: " .. dir
  )
  assets[name] = loader(PATH .. name)
end

--- Get an asset.
M.get = function (name)
  if assets[name] == nil then
    M.load(name)
  end
  return assets[name]
end

--- Set loader for files within a given directory.
M.setLoader = function (dir, loader)
  loaders[dir] = loader
end

-- Set default asset loaders.
M.setLoader("image", love.graphics.newImage)
M.setLoader("sound", function (x)
  return love.audio.newSource(x, "static")
end)
M.setLoader("music", function (x)
  return love.audio.newSource(x, "stream")
end)
M.setLoader("entity", love.filesystem.load)

return M
