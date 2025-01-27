local os_info = require("custom.utils.os_info")

if os_info.get_os_id() == "nixos" then
  return {
    { "williamboman/mason-lspconfig.nvim", enabled = false },
    { "williamboman/mason.nvim", enabled = false },
  }
end

return {}
