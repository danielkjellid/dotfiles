-- Copilot completion
return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	opts = {
		-- I primarily use this package to interact with the copilot api, but use
		-- CodeCompanion for the panel, and blink for completion.
		panel = { enabled = false },
		suggestion = { enabled = false },
		filetypes = {
			markdown = true,
			help = true,
		},
	},
}
