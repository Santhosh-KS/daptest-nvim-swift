print ("Inside the git dap swift")
local M = {}

local function setup_lldb_adapter(dap, config)
  dap.adapters.lldb = {
    type = 'executable',
    -- command = '/home/gl-245/swift_stuff/swift_versions/swift-5.8-RELEASE-ubuntu18.04/usr/bin/lldb',
    command = config.bin_path,
    name = "lldb"
  }
end

local function setup_lldb_configuration(dap, configs)
  dap.configurations.lldb = {
    {
      name = "Launch",
      type = "lldb",
      request = "launch",
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
      args = {},
      runInTerminal = true,
    },
  }

  if configs == nil or configs.dap_configurations == nil then
    print("SANT:Dap cofigurations are empty!")
    return
  end

  for _, config in ipairs(configs.dap_configurations) do
    if config.type == "swift" or config.type == "c"
    or config.type == "cpp" or config.type == "rust" then
      table.insert(dap.configurations.lldb, config)
    end
  end
end

local function load_module(module_name)
  local ok, module = pcall(require, module_name)
  assert(ok, string.format("dap-swift dependency error: %s not installed", module_name))
  return module
end

local default_config = {
    {
      name = "Launch",
      type = "lldb",
      request = "launch",
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
      args = {},
      runInTerminal = true,
      -- bin_path = '/usr/bin/lldb',
      bin_path = "/home/gl-245/swift_stuff/swift_versions/swift-5.8-RELEASE-ubuntu18.04/usr/bin/lldb"
    },
}

function M.setup(opts)
  local config = vim.tbl_deep_extend("force", default_config, opts or {})
  local dap = load_module("dap")
  setup_lldb_adapter(dap, config)
  setup_lldb_configuration(dap, config)
end

return M
