.PHONY: help
help:  ## Show available commands
	@echo "Available commands:"
	@echo
	@sed -n -E -e 's|^([A-Za-z0-9/_-]+):.+## (.+)|\1@\2|p' $(MAKEFILE_LIST) | column -s '@' -t

.PHONY: lint
lint:  ## Run lint commands
	pre-commit run --all-files --verbose --show-diff-on-failure --color always

.PHONY: fmt
fmt:  ## Format all templates
	packer fmt -recursive .
