local component = require("jam.component")
local entity = require("jam.entity")
local sandbox = require("jam.sandbox")

local PATH = "game/"

local M = {}

local assets = {}
local loaders = {}

local findPattern = function (text, pattern, start)
  return string.sub(text, string.find(text, pattern, start))
end

-- TODO: use coroutines to not block on loading?

--- Load an asset.
M.load = function (filename)
  if assets[filename] then return end
  local dir = findPattern(filename, "^[^/]+")
  local loader = assert(loaders[dir],
    "loading: " .. filename .. ": no loader for directory: " .. dir
  )
  assets[filename] = loader(PATH .. filename)
end

-- Load all assets in a directory.
M.loadDir = function (dir)
  local files = love.filesystem.enumerate(PATH .. dir)
  for _, file in ipairs(files) do
    if love.filesystem.isFile(PATH .. dir .. file) then
      M.load(dir .. file)  
    elseif love.filesystem.isDirectory(PATH .. dir .. file) then
      M.loadDir(dir .. file)
    end
  end
end

--- Get an asset.
M.get = function (filename)
  if assets[filename] == nil then
    M.load(filename)
  end
  return assets[filename]
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
M.setLoader("entity", function (x)
  local t = string.sub(findPattern(x, "[^/.]+[.]"), 1, -2)
  local f = love.filesystem.load(x)
  f = sandbox.new(f, {
    asset = M,
    component = component,
  })
  entity.register(t, f)
  return true
end)
M.setLoader("component", function (x)
  local t = string.sub(findPattern(x, "[^/.]+[.]"), 1, -2)
  local f = love.filesystem.load(x)
  f = sandbox.new(f, {})
  component.register(t, f)
  return true
end)
M.setLoader("system", function (x)
  local f = love.filesystem.load(x)
  f = sandbox.new(f, {})
  system.register(f)
  return true
end)
M.setLoader("map", love.filesystem.load)

return M

