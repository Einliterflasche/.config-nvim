require('packer').startup(function(use)
	-- Packer
	use 'wbthomason/packer.nvim'

	-- Treesitter
	use {
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate',
		dependencies = {
			'nvim-treesitter/nvim-treesitter-textobjects'
		}
	}

	-- Git 
	use 'tpope/vim-fugitive'
	use {
		'lewis6991/gitsigns.nvim',
		config = {
			signs = {
				add = { text = '+' },
				change = { text = '~' },
				delete = { text = '_' },
				topdelete = { text = '‾' },
				changedelete = { text = '~' },
			}
		}
	}
	
	-- Tabs and spacing
	use 'tpope/vim-sleuth'
	
	-- LSP
	use { 
		'neovim/nvim-lspconfig',
		dependencies = {
			-- Automatically install LSPs to stdpath for neovim
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',

      			-- Useful status updates for LSP
      			-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      			{ 'j-hui/fidget.nvim', config = {} },

      			-- Additional lua configuration, makes nvim stuff amazing!
      			'folke/neodev.nvim',
		},
	}

	-- Autocompletion 
	use {
		'hrsh7th/nvim-cmp',
		dependencies = {
			'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip'
		}
	}
	
	-- Lualine
	use {
		'nvim-lualine/lualine.nvim',
	}


end)

vim.wo.number = true
vim.o.mouse = ''
vim.o.clipboard = 'unnamedplus'

vim.o.breakindent = true

vim.o.undofile = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.wo.signcolumn = 'yes'

vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

vim.o.completeopt = 'menuone,noselect'

vim.o.termguicolors = true

require('nvim-treesitter.configs').setup {
	ensure_installed = { 'rust', 'lua', 'typescript', 'help', 'vim', 'python' },
	auto_install = false,

	highlight = {
		enabled = true
	},
	indent = {
		enable = true,
		disabled = { 'python' }
	},
	incremental_selection = {
		enable = true
	}
}

-- LSP settings
local servers = {
	tsserer = {},
	rust_analyzer = {},
	pyright = {},
	lua_ls = {
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
		},
	}
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

require('mason').setup()

local mason_lspconfig = require('mason-lspconfig')


mason_lspconfig.setup_handlers {
	function(server_name)
		require('lspconfig')[server_name].setup {
			capabilities = capabilities,
			on_attach = on_attach,
			settings = servers[server_name],
		}
	end
}

local cmp = require('cmp')
local luasnip = require('luasnip')

luasnip.config.setup {}

cmp.setup {
	snippet = {
		expand = function(args) 
			luasnip.lsp_expand(args.body)
		end
	},
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' }
	}
}


