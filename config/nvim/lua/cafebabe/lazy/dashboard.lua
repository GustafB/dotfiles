return {
	"goolord/alpha-nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"nvim-lua/plenary.nvim",
	},
	config = function()
		-- Import alpha and dashboard
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		-- Define custom icons
		local icons = {
			ui = {
				file = "",
				open_folder = "",
				config = "",
				close = "",
			},
		}

		local function center_header(header)
			local width = vim.api.nvim_win_get_width(0) -- Get the width of the current window
			local padding = math.floor((width - #header[1]) / 2) -- Calculate padding based on the first line length
			for i, line in ipairs(header) do
				header[i] = string.rep(" ", padding) .. line
			end
			return header
		end

		-- Define custom header with ASCII art or any custom message
		local custom_header = center_header({
			"  ___ ___         .__  .__             ________                __          _____",
			" /   |   \\   ____ |  | |  |   ____    /  _____/ __ __  _______/  |______ _/ ____\\",
			"/    ~    \\_/ __ \\|  | |  |  /  _ \\  /   \\  ___|  |  \\/  ___/\\   __\\__  \\\\   __\\",
			"\\    Y    /\\  ___/|  |_|  |_(  <_> ) \\    \\_\\  \\  |  /\\___ \\  |  |  / __ \\|  |",
			" \\___|_  /  \\___  >____/____/\\____/   \\______  /____//____  > |__| (____  /__|",
			"       \\/       \\/                           \\/           \\/            \\/       ",
			" ____ ____ ____ ____ ____ ____ _________ ____ ____ ____ ____ ____ ____ ",
			"||G |||U |||S |||T |||A |||F |||       |||H |||J |||K |||L |||; ||| |||",
			"||__|||__|||__|||__|||__|||__|||_______|||__|||__|||__|||__|||__|||__||",
			"|/__\\|/__\\|/__\\|/__\\|/__\\|/__\\|/_______\\|/__\\|/__\\|/__\\|/__\\|/__\\|/__\\|",
		})

		-- Define the buttons for the dashboard
		local buttons = {
			dashboard.button("e", icons.ui.file .. "  New file", "<cmd>new<CR>"),
			dashboard.button("o", icons.ui.file .. "  Recent Files", "<cmd>Telescope oldfiles<cr>"),
			dashboard.button("f", icons.ui.open_folder .. "  Explorer", "<cmd>Explore<cr>"),
			dashboard.button(
				"c",
				icons.ui.config .. "  Neovim config",
				"<cmd>e ~/home/cafebabe/install/dotfiles/config/nvim<cr>"
			),
			dashboard.button("l", "󰒲  Lazy", "<cmd>Lazy<cr>"),
			dashboard.button("q", icons.ui.close .. "  Quit NVIM", ":qa<CR>"),
		}

		-- Custom footer showing number of plugins loaded
		local footer = {
			type = "text",
			val = { "⚡" .. require("lazy").stats().loaded .. " plugins loaded." },
			opts = { position = "center", hl = "Comment" },
		}

		-- Custom section with a personal greeting
		local bottom_section = {
			type = "text",
			val = "Hi Gustaf, It's " .. os.date(" %H:%M ") .. "How are you doing today?",
			opts = { position = "center" },
		}

		-- Setting up the alpha layout
		alpha.setup({
			layout = {
				{ type = "padding", val = 8 },
				{ type = "text", val = custom_header },
				{ type = "padding", val = 2 },
				{ type = "group", val = buttons },
				{ type = "padding", val = 1 },
				bottom_section,
				{ type = "padding", val = 1 },
				footer,
			},
		})
	end,
}
