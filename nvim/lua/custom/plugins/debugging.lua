return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"leoluz/nvim-dap-go",
			"mfussenegger/nvim-dap-python",
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"jay-babu/mason-nvim-dap.nvim",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			
			-- ========== DAP UI Setup ==========
			dapui.setup({
				icons = { expanded = "▾", collapsed = "▸", current_frame = "→" },
				mappings = {
					expand = { "<CR>", "<2-LeftMouse>" },
					open = "o",
					remove = "d",
					edit = "e",
					repl = "r",
					toggle = "t",
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
				controls = {
					enabled = true,
					element = "repl",
					icons = {
						pause = "⏸",
						play = "▶",
						step_into = "⏎",
						step_over = "⏭",
						step_out = "⏮",
						step_back = "b",
						run_last = "▶▶",
						terminate = "⏹",
					},
				},
				floating = {
					max_height = nil,
					max_width = nil,
					border = "rounded",
					mappings = {
						close = { "q", "<Esc>" },
					},
				},
				windows = { indent = 1 },
				render = {
					max_type_length = nil,
					max_value_lines = 100,
				},
			})

			-- Virtual text configuration
			require("nvim-dap-virtual-text").setup({
				enabled = true,
				enabled_commands = true,
				highlight_changed_variables = true,
				highlight_new_as_changed = true,
				show_stop_reason = true,
				commented = false,
				only_first_definition = true,
				all_references = false,
				virt_text_pos = "eol",
			})

			-- Mason DAP setup
			require("mason-nvim-dap").setup({
				ensure_installed = {
					"python",
					"cppdbg",
					"delve",
					"js-debug-adapter",
					"java-debug-adapter",
					"java-test",
				},
				automatic_installation = true,
				handlers = {},
			})

			-- ========== Python Configuration ==========
			local python_path = function()
				-- Try to find Python in virtual environment first
				local venv = os.getenv("VIRTUAL_ENV")
				if venv then
					return venv .. "/bin/python"
				end
				
				-- Check for common virtual environment locations
				local cwd = vim.fn.getcwd()
				local venv_paths = {
					cwd .. "/venv/bin/python",
					cwd .. "/.venv/bin/python",
					cwd .. "/env/bin/python",
				}
				
				for _, path in ipairs(venv_paths) do
					if vim.fn.executable(path) == 1 then
						return path
					end
				end
				
				-- Fallback to system Python
				return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
			end

			require("dap-python").setup(python_path())
			
			-- Python configurations
			dap.configurations.python = {
				{
					type = "python",
					request = "launch",
					name = "Launch file",
					program = "${file}",
					pythonPath = python_path,
				},
				{
					type = "python",
					request = "launch",
					name = "Launch file with arguments",
					program = "${file}",
					args = function()
						local args_string = vim.fn.input("Arguments: ")
						return vim.split(args_string, " +")
					end,
					pythonPath = python_path,
				},
				{
					type = "python",
					request = "launch",
					name = "Django",
					program = "${workspaceFolder}/manage.py",
					args = {
						"runserver",
					},
					pythonPath = python_path,
					django = true,
					console = "integratedTerminal",
				},
				{
					type = "python",
					request = "attach",
					name = "Attach remote",
					connect = function()
						local host = vim.fn.input("Host [127.0.0.1]: ")
						host = host ~= "" and host or "127.0.0.1"
						local port = tonumber(vim.fn.input("Port [5678]: ")) or 5678
						return { host = host, port = port }
					end,
				},
			}

			-- ========== Go Configuration ==========
			require("dap-go").setup({
				dap_configurations = {
					{
						type = "go",
						name = "Attach remote",
						mode = "remote",
						request = "attach",
					},
				},
				delve = {
					path = "dlv",
					initialize_timeout_sec = 20,
					port = "${port}",
					args = {},
					build_flags = "",
				},
			})

			-- ========== C/C++ Configuration ==========
			dap.adapters.cppdbg = {
				id = "cppdbg",
				type = "executable",
				command = vim.fn.stdpath("data") .. "/mason/bin/OpenDebugAD7",
			}

			dap.configurations.cpp = {
				{
					name = "Launch file",
					type = "cppdbg",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopAtEntry = false,
					args = {},
					runInTerminal = false,
				},
				{
					name = "Launch file with arguments",
					type = "cppdbg",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopAtEntry = false,
					args = function()
						local args_string = vim.fn.input("Arguments: ")
						return vim.split(args_string, " +")
					end,
					runInTerminal = false,
				},
				{
					name = "Attach to gdbserver :1234",
					type = "cppdbg",
					request = "launch",
					MIMode = "gdb",
					miDebuggerServerAddress = "localhost:1234",
					miDebuggerPath = "/usr/bin/gdb",
					cwd = "${workspaceFolder}",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
				},
			}

			dap.configurations.c = dap.configurations.cpp

			-- ========== JavaScript/TypeScript Configuration ==========
			dap.adapters["pwa-node"] = {
				type = "server",
				host = "localhost",
				port = "${port}",
				executable = {
					command = "node",
					args = {
						vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
						"${port}",
					},
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

			dap.configurations.typescript = dap.configurations.javascript

			-- ========== Java Configuration ==========
			dap.adapters.java = function(callback)
				-- Start jdtls with debugger support
				callback({
					type = 'server',
					host = '127.0.0.1',
					port = 5005,
				})
			end

			dap.configurations.java = {
				{
					type = 'java',
					request = 'attach',
					name = "Debug (Attach) - Remote",
					hostName = "127.0.0.1",
					port = 5005,
				},
				{
					type = 'java',
					request = 'launch',
					name = "Debug (Launch) - Current File",
					mainClass = "${file}",
				},
				{
					type = 'java',
					request = 'launch',
					name = "Debug (Launch) - Main Class",
					mainClass = function()
						return vim.fn.input('Main class: ')
					end,
				},
			}

			-- ========== UI Enhancements ==========
			vim.fn.sign_define("DapBreakpoint", {
				text = "●",
				texthl = "DapBreakpoint",
				linehl = "",
				numhl = "",
			})

			vim.fn.sign_define("DapBreakpointCondition", {
				text = "◆",
				texthl = "DapBreakpointCondition",
				linehl = "",
				numhl = "",
			})

			vim.fn.sign_define("DapBreakpointRejected", {
				text = "",
				texthl = "DapBreakpointRejected",
				linehl = "",
				numhl = "",
			})

			vim.fn.sign_define("DapStopped", {
				text = "→",
				texthl = "DapStopped",
				linehl = "DapStoppedLine",
				numhl = "",
			})

			vim.fn.sign_define("DapLogPoint", {
				text = "◆",
				texthl = "DapLogPoint",
				linehl = "",
				numhl = "",
			})

			-- Highlight groups
			vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#e51400" })
			vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = "#f79617" })
			vim.api.nvim_set_hl(0, "DapBreakpointRejected", { fg = "#767676" })
			vim.api.nvim_set_hl(0, "DapStopped", { fg = "#98c379" })
			vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#2d3139" })
			vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#61afef" })

			-- ========== Keymaps ==========
			local opts = { silent = true, noremap = true }
			
			-- Basic debugging
			vim.keymap.set("n", "<F5>", dap.continue, vim.tbl_extend("force", opts, { desc = "Debug: Start/Continue" }))
			vim.keymap.set("n", "<F10>", dap.step_over, vim.tbl_extend("force", opts, { desc = "Debug: Step Over" }))
			vim.keymap.set("n", "<F11>", dap.step_into, vim.tbl_extend("force", opts, { desc = "Debug: Step Into" }))
			vim.keymap.set("n", "<F12>", dap.step_out, vim.tbl_extend("force", opts, { desc = "Debug: Step Out" }))
			
			-- Breakpoints
			vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, vim.tbl_extend("force", opts, { desc = "Debug: Toggle Breakpoint" }))
			vim.keymap.set("n", "<leader>dB", function()
				dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end, vim.tbl_extend("force", opts, { desc = "Debug: Conditional Breakpoint" }))
			vim.keymap.set("n", "<leader>dc", dap.clear_breakpoints, vim.tbl_extend("force", opts, { desc = "Debug: Clear Breakpoints" }))
			
			-- UI controls
			vim.keymap.set("n", "<leader>du", dapui.toggle, vim.tbl_extend("force", opts, { desc = "Debug: Toggle UI" }))
			vim.keymap.set("n", "<leader>de", dapui.eval, vim.tbl_extend("force", opts, { desc = "Debug: Eval" }))
			vim.keymap.set("v", "<leader>de", dapui.eval, vim.tbl_extend("force", opts, { desc = "Debug: Eval Selection" }))
			
			-- Session controls
			vim.keymap.set("n", "<leader>dt", dap.terminate, vim.tbl_extend("force", opts, { desc = "Debug: Terminate" }))
			vim.keymap.set("n", "<leader>dr", dap.run_last, vim.tbl_extend("force", opts, { desc = "Debug: Run Last" }))
			vim.keymap.set("n", "<leader>dp", dap.pause, vim.tbl_extend("force", opts, { desc = "Debug: Pause" }))
			
			-- REPL
			vim.keymap.set("n", "<leader>dR", dap.repl.toggle, vim.tbl_extend("force", opts, { desc = "Debug: Toggle REPL" }))

			-- ========== Auto Commands ==========
			local dap_group = vim.api.nvim_create_augroup("dap_config", { clear = true })
			
			-- Open UI on debug session start
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			
			-- Close UI on debug session end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			-- Auto-complete in REPL
			vim.api.nvim_create_autocmd("FileType", {
				group = dap_group,
				pattern = "dap-repl",
				callback = function()
					require("dap.ext.autocompl").attach()
				end,
			})

			-- Notify when debugger is ready
			vim.api.nvim_create_autocmd("User", {
				group = dap_group,
				pattern = "DapReady",
				callback = function()
					vim.notify("Debugger ready", vim.log.levels.INFO)
				end,
			})
		end,
	},
}
