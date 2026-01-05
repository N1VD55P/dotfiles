return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"leoluz/nvim-dap-go",
			"SGauvin/ctest-telescope.nvim",
			"mfussenegger/nvim-dap-python",
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"jay-babu/mason-nvim-dap.nvim",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			
			-- ========== Basic Setup ==========
			dapui.setup({
				icons = { expanded = "▾", collapsed = "▸" },
				mappings = {
					expand = { "<CR>", "<2-LeftMouse>" },
					open = "o",
					remove = "d",
					edit = "e",
					repl = "r",
				},
				layouts = {
					{
						elements = {
							{ id = "scopes", size = 0.25 },
							{ id = "breakpoints", size = 0.25 },
							{ id = "stacks", size = 0.25 },
							{ id = "watches", size = 0.25 },
						},
						position = "left",
						size = 40,
					},
					{
						elements = {
							{ id = "repl", size = 0.5 },
							{ id = "console", size = 0.5 },
						},
						position = "bottom",
						size = 10,
					},
				},
			})

			-- Virtual text configuration
			require("nvim-dap-virtual-text").setup({
				enabled = true,
				enabled_commands = true,
				highlight_changed_variables = true,
				highlight_new_as_changed = true,
				commented = true,
			})

			-- ========== Language Configurations ==========

			-- Python (using debugpy)
			require("dap-python").setup("~/.virtualenvs/debugpy/bin/python")
			table.insert(dap.configurations.python, {
				type = "python",
				request = "launch",
				name = "Launch file",
				program = "${file}",
				pythonPath = function()
					return vim.fn.exepath("python3")
				end,
				justMyCode = false,
			})

			-- Go (using delve via nvim-dap-go)
			require("dap-go").setup({
				delve = {
					path = "dlv",
					args = { "--check-go-version=false" },
					build_flags = "-tags=integration,unit",
				},
			})

			-- C/C++ (using cpptools via mason)
			dap.adapters.cppdbg = {
				id = "cppdbg",
				type = "executable",
				command = vim.fn.expand("~/.local/share/nvim/mason/bin/OpenDebugAD7"),
				options = {
					detached = false,
				},
			}

			dap.configurations.cpp = {
				{
					name = "Launch (GDB)",
					type = "cppdbg",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopAtEntry = true,
					setupCommands = {
						{
							text = "-enable-pretty-printing",
							description = "enable pretty printing",
							ignoreFailures = false,
						},
					},
				},
			}

			-- JavaScript/TypeScript (using js-debug-adapter)
			-- First, let's try to set up JS debugging with proper error handling
			local function setup_js_debugging()
				local mason_registry = require("mason-registry")
				
				-- Method 1: Try using Mason registry safely
				local success, result = pcall(function()
					if mason_registry.is_installed and mason_registry.is_installed("js-debug-adapter") then
						local pkg = mason_registry.get_package("js-debug-adapter")
						if pkg and pkg.get_install_path then
							return pkg:get_install_path()
						end
					end
					return nil
				end)
				
				local js_debug_path = nil
				
				if success and result then
					js_debug_path = result .. "/js-debug/src/dapDebugServer.js"
				else
					-- Method 2: Try common installation paths
					local possible_paths = {
						vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
						vim.fn.expand("~/.local/share/nvim/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"),
					}
					
					for _, path in ipairs(possible_paths) do
						if vim.fn.filereadable(path) == 1 then
							js_debug_path = path
							break
						end
					end
				end
				
				if js_debug_path and vim.fn.filereadable(js_debug_path) == 1 then
					dap.adapters["pwa-node"] = {
						type = "server",
						host = "127.0.0.1",
						port = "${port}",
						executable = {
							command = "node",
							args = { js_debug_path, "${port}" },
						},
					}
					
					dap.configurations.javascript = {
						{
							type = "pwa-node",
							request = "launch",
							name = "Launch file",
							program = "${file}",
							cwd = "${workspaceFolder}",
						},
						{
							type = "pwa-node",
							request = "attach",
							name = "Attach",
							processId = require("dap.utils").pick_process,
							cwd = "${workspaceFolder}",
						},
					}
					
					
				end
			end
			
			-- Setup JS debugging
			setup_js_debugging()

			-- ========== UI Enhancements ==========
			vim.fn.sign_define("DapBreakpoint", {
				text = "🛑",
				texthl = "DiagnosticSignError",
				linehl = "",
				numhl = "",
			})

			vim.fn.sign_define("DapStopped", {
				text = "→",
				texthl = "DiagnosticSignWarn",
				linehl = "Visual",
				numhl = "",
			})

			-- ========== Keymaps ==========
			local opts = { silent = true, noremap = true }
			vim.keymap.set("n", "<F1>", dap.continue, opts)
			vim.keymap.set("n", "<F2>", dap.step_over, opts)
			vim.keymap.set("n", "<F3>", dap.step_into, opts)
			vim.keymap.set("n", "<F4>", dap.step_out, opts)
			vim.keymap.set("n", "<leader>tb", dap.toggle_breakpoint, opts)
			
			-- ========== Auto Commands ==========
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			-- Auto-complete in REPL
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "dap-repl",
				callback = function()
					require("dap.ext.autocompl").attach()
				end,
			})
		end,
	},
}
