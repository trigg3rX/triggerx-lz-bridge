############################# HELP MESSAGE #############################
.PHONY: help tests
help:
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

############################# DEPENDENCIES #############################
.PHONY: install
install:
	yarn install

build-contracts: ## Build contracts
	./utils/build-contracts.sh

deploy-receiver-on-holesky: ## Deploy Receiver Contract on Holesky
	./utils/deploy-receiver-on-holesky.sh

deploy-sender-on-shasta: ## Deploy Sender Contract on Shasta
	./utils/deploy-sender-on-shasta.sh

send-message: ## Send message
	node utils/sendMessage.js

deploy-contracts-on-holesky: ## Deploy TM and SM on Holesky
	./utils/deploy-contracts-on-holesky.sh