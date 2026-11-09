-- .config/nvim/lsp/jedi-language-server.lua
return {
	cmd = { "jedi-language-server" },
	filetypes = { "python" },
	root_markers = {
		"pyproject.toml",
		"setup.py",
		"setup.cfg",
		"requirements.txt",
		".git",
		"Pipfile",
		".venv",
		"venv",
	},
	capabilities = {
		textDocument = {
			completion = {
				completionItem = {
					commitCharactersSupport = false,
					deprecatedSupport = true,
					documentationFormat = { "markdown", "plaintext" },
					insertReplaceSupport = true,
					insertTextModeSupport = {
						valueSet = { 1 },
					},
					labelDetailsSupport = true,
					preselectSupport = false,
					resolveSupport = {
						properties = { "documentation", "detail", "additionalTextEdits", "command", "data" },
					},
					snippetSupport = true,
					tagSupport = {
						valueSet = { 1 },
					},
				},
				completionList = {
					itemDefaults = { "commitCharacters", "editRange", "insertTextFormat", "insertTextMode", "data" },
				},
				contextSupport = true,
				insertTextMode = 1,
			},
			semanticTokens = {
				multilineTokenSupport = true,
			},
			codeAction = {
				dynamicRegistration = true,
				codeActionLiteralSupport = {
					codeActionKind = {
						valueSet = {
							"refactor.inline",
							"refactor.extract",
						},
					},
				},
			},
			declaration = {
				dynamicRegistration = true,
			},
			definition = {
				dynamicRegistration = true,
			},
			documentHighlight = {
				dynamicRegistration = true,
			},
			documentSymbol = {
				dynamicRegistration = true,
			},
			typeDefinition = {
				dynamicRegistration = true,
			},
			hover = {
				dynamicRegistration = true,
			},
			publishDiagnostics = {
				relatedInformation = true,
			},
			references = {
				dynamicRegistration = true,
			},
			rename = {
				dynamicRegistration = true,
			},
			signatureHelp = {
				dynamicRegistration = true,
			},
			workspaceSymbol = {
				dynamicRegistration = true,
			},
		},
		workspace = {
			didChangeWatchedFiles = {
				dynamicRegistration = true,
			},
			symbol = {
				dynamicRegistration = true,
			},
		},
	},
}
