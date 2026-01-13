return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "LspInfo", "LspStart", "LspStop", "LspRestart" },
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
        -- Import necessary modules
        local lspconfig = require("lspconfig")
        local cmp_nvim_lsp = require("cmp_nvim_lsp")
        local mason_lspconfig = require("mason-lspconfig")
        
        -- Get capabilities from nvim-cmp
        local capabilities = cmp_nvim_lsp.default_capabilities()
        
        -- Enhanced LSP keymaps on attach
        local on_attach = function(client, bufnr)
            local opts = { buffer = bufnr, noremap = true, silent = true }
            
            -- Key mappings
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
            vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Show hover information" }))
            vim.keymap.set("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
            vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Show references" }))
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code actions" }))
            vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "Type definition" }))
            vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature help" }))
            
            -- Diagnostics
            vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))
            vim.keymap.set("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
            vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Show line diagnostics" }))
            vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, vim.tbl_extend("force", opts, { desc = "Show diagnostics list" }))
            
            -- Highlight symbol under cursor
            if client.server_capabilities.documentHighlightProvider then
                local highlight_augroup = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })
                vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                    buffer = bufnr,
                    group = highlight_augroup,
                    callback = vim.lsp.buf.document_highlight,
                })
                vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                    buffer = bufnr,
                    group = highlight_augroup,
                    callback = vim.lsp.buf.clear_references,
                })
            end
        end

-- Default setup configuration
local default_setup = {
  capabilities = capabilities,
  on_attach = on_attach,
}

-- Safe server setup helper that avoids triggering deprecated/metatable errors
local function safe_setup(server_name, opts)
  opts = opts or default_setup

  -- Prefer requiring the server_configurations module which avoids the deprecated lspconfig table indexing
  local ok, scfg = pcall(require, "lspconfig.server_configurations." .. server_name)
  if ok and scfg and type(scfg.setup) == "function" then
    scfg.setup(opts)
    return true
  end

  -- Best-effort: try to register via vim.lsp.config if helper exists
  if vim and vim.lsp and vim.lsp.config and type(vim.lsp.config.add_server) == "function" then
    pcall(vim.lsp.config.add_server, server_name, opts)
    return true
  end

  return false
end

-- Prefer using mason-lspconfig's handlers if available; otherwise fall back
if type(mason_lspconfig.setup_handlers) == "function" then
  mason_lspconfig.setup_handlers({
    -- Default handler for all servers
    function(server_name)
      safe_setup(server_name, default_setup)
    end,

    -- Python - Pyright
    ["pyright"] = function()
      lspconfig.pyright.setup(vim.tbl_extend("force", default_setup, {
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "workspace",
            },
          },
        },
      }))
    end,

    -- C/C++ - Clangd
    ["clangd"] = function()
      lspconfig.clangd.setup(vim.tbl_extend("force", default_setup, {
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--function-arg-placeholders",
          "--fallback-style=llvm",
        },
        init_options = {
          clangdFileStatus = true,
          usePlaceholders = true,
          completeUnimported = true,
          semanticHighlighting = true,
        },
        filetypes = { "c", "cpp", "cc", "cxx", "objc", "objcpp" },
      }))
    end,

    -- TypeScript/JavaScript
    ["ts_ls"] = function()
      lspconfig.ts_ls.setup(vim.tbl_extend("force", default_setup, {
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
        },
      }))
    end,

    -- HTML
    ["html"] = function()
      lspconfig.html.setup(vim.tbl_extend("force", default_setup, {
        filetypes = { "html", "htmldjango" },
      }))
    end,

    -- Java (jdtls)
    ["jdtls"] = function()
      safe_setup("jdtls", default_setup)
    end,

    -- CSS
    ["cssls"] = function()
      lspconfig.cssls.setup(default_setup)
    end,

    -- Emmet
    ["emmet_ls"] = function()
      lspconfig.emmet_ls.setup(vim.tbl_extend("force", default_setup, {
        filetypes = {
          "html",
          "css",
          "scss",
          "javascript",
          "javascriptreact",
          "typescriptreact",
          "svelte",
          "vue",
        },
      }))
    end,

    -- Lua
    ["lua_ls"] = function()
      lspconfig.lua_ls.setup(vim.tbl_extend("force", default_setup, {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = { enable = false },
            hint = {
              enable = true,
              setType = true,
              paramType = true,
              paramName = "Disable",
              semicolon = "Disable",
              arrayIndex = "Disable",
            },
          },
        },
      }))
    end,

    -- JSON
    ["jsonls"] = function()
      lspconfig.jsonls.setup(vim.tbl_extend("force", default_setup, {
        settings = {
          json = {
            validate = { enable = true },
          },
        },
      }))
    end,

    -- Tailwind CSS
    ["tailwindcss"] = function()
      lspconfig.tailwindcss.setup(vim.tbl_extend("force", default_setup, {
        filetypes = {
          "html",
          "css",
          "scss",
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "svelte",
          "vue",
        },
        settings = {
          tailwindCSS = {
            classAttributes = { "class", "className", "classList", "ngClass" },
            lint = {
              cssConflict = "warning",
              invalidApply = "error",
              invalidConfigPath = "error",
              invalidScreen = "error",
              invalidTailwindDirective = "error",
              invalidVariant = "error",
              recommendedVariantOrder = "warning",
            },
            validate = true,
          },
        },
      }))
    end,

    -- ESLint
    ["eslint"] = function()
      lspconfig.eslint.setup(vim.tbl_extend("force", default_setup, {
        on_attach = function(client, bufnr)
          on_attach(client, bufnr)
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "EslintFixAll",
          })
        end,
      }))
    end,

    -- CMake
    ["cmake"] = function()
      lspconfig.cmake.setup(default_setup)
    end,
  })
else
  -- Fallback: mason-lspconfig not providing setup_handlers (older/newer API); configure servers manually
  local servers = {
    "pyright",
    "clangd",
    "ts_ls",
    "html",
    "cssls",
    "emmet_ls",
    "lua_ls",
    "jsonls",
    "jdtls",
  }

  for _, server in ipairs(servers) do
    if server == "pyright" then
      safe_setup("pyright", vim.tbl_extend("force", default_setup, {
        settings = { python = { analysis = { typeCheckingMode = "basic", autoSearchPaths = true, useLibraryCodeForTypes = true, diagnosticMode = "workspace" } } },
      }))
    elseif server == "clangd" then
      safe_setup("clangd", vim.tbl_extend("force", default_setup, {
        cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu", "--completion-style=detailed", "--function-arg-placeholders" },
        init_options = { clangdFileStatus = true, usePlaceholders = true, completeUnimported = true, semanticHighlighting = true },
      }))
    elseif server == "ts_ls" then
      safe_setup("ts_ls", default_setup)
    elseif server == "html" then
      safe_setup("html", vim.tbl_extend("force", default_setup, { filetypes = { "html", "htmldjango" } }))
    else
      safe_setup(server, default_setup)
    end
  end
end
       
        -- Improve diagnostic signs
        local signs = {
            { name = "DiagnosticSignError", text = "" },
            { name = "DiagnosticSignWarn", text = "" },
            { name = "DiagnosticSignHint", text = "" },
            { name = "DiagnosticSignInfo", text = "" },
        }
        
        for _, sign in ipairs(signs) do
            vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
        end
        
        -- Configure diagnostic display
        vim.diagnostic.config({
            virtual_text = {
                prefix = '●',
                spacing = 4,
            },
            signs = true,
            underline = true,
            update_in_insert = false,
            severity_sort = true,
            float = {
                border = 'rounded',
                source = 'always',
                header = '',
                prefix = '',
            },
        })
        
        -- Customize hover and signature help borders
        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
            vim.lsp.handlers.hover, {
                border = "rounded",
            }
        )
        
        vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
            vim.lsp.handlers.signature_help, {
                border = "rounded",
            }
        )
    end,
}
