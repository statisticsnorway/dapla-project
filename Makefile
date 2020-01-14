.PHONY: default
default: | help

.PHONY: update-all
update-all: ## Checkout or update all related dapla repos
	./git-update.sh

.PHONY: print-local-changes
print-local-changes: ## Show a brief summary of local changes
	./git-status.sh

.PHONY: build-asciidoc
build-asciidoc: ## Build asciidoc
	@asciidoctor -a allow-uri-read -b html5 -a linkcss README.adoc -D target/
	@mkdir -p ./target/doc/img/
	@cp -r ./doc/img/* target/doc/img/

.PHONY: open-asciidoc
open-asciidoc: ## Open asciidoc in browser
	@open target/README.html

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
