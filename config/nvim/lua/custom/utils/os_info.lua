local M = {}

local os_release = "/etc/os-release"

local function file_exists(filename)
  local f = io.open(filename, "r")
  if f then
    f:close()
  end
  return f ~= nil
end

local function strip_quotes(s)
  return s:gsub('^"(.*)"$', "%1")
end

function M.get_os_info()
  if not file_exists(os_release) then
    return nil, "unable to find " .. os_release
  end

  local file = io.open(os_release, "r")
  local info = {}

  for line in file:lines() do
    local key, value = line:match("^([%w_]+)=(.+)$")
    if key and value then
      info[key] = strip_quotes(value)
    end
  end

  file:close()

  return info
end

function M.get_os_id()
  local info, err = M.get_os_info()
  if not info then
    return nil, err
  end

  return info.ID
end

return M
