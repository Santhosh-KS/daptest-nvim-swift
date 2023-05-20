print ("Inside the git dap swift")
local M = {}

local function setup_lldb_adapter(dap, config)
  dap.adapters.lldb = {
    type = 'executable',
    command = '/home/gl-245/swift_stuff/swift_versions/swift-5.8-RELEASE-ubuntu18.04/usr/bin/lldb',
    name = "lldb"
  }
end

local function setup_lldb_configuration(dap, configs)
  local lldb_cfg =  {
      name = "Launch",
      type = "lldb",
      request = "launch",
      program = "swift run", -- This command will build the code and run. bin is placed inside .build/debug/<your_bin>
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
      args = {},
      runInTerminal = true,
    }

  dap.configurations.swift = {lldb_cfg}
  dap.configurations.lldb = {lldb_cfg}
  print(vim.inspect(lldb_cfg))
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
