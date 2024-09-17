############################# HELP MESSAGE #############################
.PHONY: help tests
help:
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build-contracts: ## Build contracts
	git submodule update --init --recursive
	cd contracts && forge build

deploy-contracts: ## Deploy contracts on Holesky
	./utils/deploy-contracts-on-holesky.sh