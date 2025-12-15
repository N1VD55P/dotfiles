return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "mfussenegger/nvim-jdtls",
    },
    config = function()
        -- Get capabilities from nvim-cmp
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        
        -- Mason setup
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "pyright",
                "clangd",
                "ts_ls",
                "html",
                "cssls",
                "emmet_ls",
                "lua_ls",
                "jdtls",
            },
            -- Automatically configure servers installed via Mason
            handlers = {
                -- Default handler for all servers
                function(server_name)
                    require("lspconfig")[server_name].setup({
                        capabilities = capabilities,
                    })
                end,
                
                -- Custom handlers for specific servers
                ["pyright"] = function()
                    require("lspconfig").pyright.setup({
                        capabilities = capabilities,
                    })
                end,
                
                ["clangd"] = function()
                    require("lspconfig").clangd.setup({
                        capabilities = capabilities,
                        cmd = { "clangd", "--background-index" },
                    })
                end,
                
                ["ts_ls"] = function()
                    require("lspconfig").ts_ls.setup({
                        capabilities = capabilities,
                    })
                end,
                
                ["html"] = function()
                    require("lspconfig").html.setup({
                        capabilities = capabilities,
                    })
                end,
                
                ["cssls"] = function()
                    require("lspconfig").cssls.setup({
                        capabilities = capabilities,
                    })
                end,
                
                ["emmet_ls"] = function()
                    require("lspconfig").emmet_ls.setup({
                        capabilities = capabilities,
                        filetypes = {
                            "html",
                            "css",
                            "scss",
                            "javascript",
                            "javascriptreact",
                            "typescriptreact",
                            "svelte",
                        },
                    })
                end,
                
                ["lua_ls"] = function()
                    require("lspconfig").lua_ls.setup({
                        capabilities = capabilities,
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
                                },
                            },
                        },
                    })
                end,
                
                -- JDTLS is handled separately via FileType autocmd
                ["jdtls"] = function()
                    -- Don't set up JDTLS here, we'll use nvim-jdtls plugin
                end,
            },
        })

        -- Java (JDTLS) - Setup via FileType autocmd for proper per-project configuration
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "java",
            callback = function()
                local jdtls = require("jdtls")
                local mason_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
                local launcher = vim.fn.glob(mason_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
                
                -- Better OS detection
                local system = "linux"
                if vim.fn.has("mac") == 1 then
                    system = "mac"
                elseif vim.fn.has("win32") == 1 then
                    system = "win"
                end
                local config_dir = mason_path .. "/config_" .. system

                if launcher ~= "" then
                    -- Root directory detection
                    local root_markers = {
                        ".git",
                        "mvnw",
                        "gradlew",
                        "pom.xml",
                        "build.gradle",
                        "settings.gradle",
                    }
                    
                    local root_dir = require("jdtls.setup").find_root(root_markers)
                        or vim.fn.getcwd()

                    -- Use project-local workspace directory
                    local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
                    local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls-workspace/" .. project_name

                    local config = {
                        cmd = {
                            "java",
                            "-Declipse.application=org.eclipse.jdt.ls.core.id1",
                            "-Dosgi.bundles.defaultStartLevel=4",
                            "-Declipse.product=org.eclipse.jdt.ls.core.product",
                            "-Dlog.protocol=true",
                            "-Dlog.level=ALL",
                            "-Xms1g",
                            "-Xmx2g",
                            "--add-modules=ALL-SYSTEM",
                            "--add-opens", "java.base/java.util=ALL-UNNAMED",
                            "--add-opens", "java.base/java.lang=ALL-UNNAMED",
                            "-jar", launcher,
                            "-configuration", config_dir,
                            "-data", workspace_dir,
                        },
                        capabilities = capabilities,
                        root_dir = root_dir,
                        settings = {
                            java = {
                                eclipse = {
                                    downloadSources = true,
                                },
                                maven = {
                                    downloadSources = true,
                                },
                                implementationsCodeLens = {
                                    enabled = true,
                                },
                                referencesCodeLens = {
                                    enabled = true,
                                },
                                references = {
                                    includeDecompiledSources = true,
                                },
                            },
                        },
                        init_options = {
                            bundles = {},
                        },
                    }

                    jdtls.start_or_attach(config)
                end
            end,
        })
    end,
}
