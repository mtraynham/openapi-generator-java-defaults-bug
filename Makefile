.generated:  ## generate an openapi client
	@echo "Generating OpenAPI client..."
	@if [ -d .generated ]; then rm -rf .generated; fi
	@docker run --rm \
        --name generated \
        --user $(shell id -u):$(shell id -g) \
        -v $(PWD):/local:Z \
        -w /local \
        openapitools/openapi-generator-cli:v7.12.0 generate \
        	-i openapi.yaml \
            -o .generated \
            -c config.yaml
	chmod +x .generated/gradlew
	cd .generated && ./gradlew build
.PHONY: .generated
