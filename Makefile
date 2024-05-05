
# Source environment file and export variables
include .env
export

# Define variables
TEMPLATE = $$gitlab_path_to_template
VAR_FILE = $$gitlab_path_to_var_file
PACKER_PATH = $$path_to_packer

# Define targets
.PHONY: validate build

validate:
	@echo "Validating template: $(TEMPLATE)"
	$(PACKER_PATH) validate --var-file=$(VAR_FILE) ./packer

replace_tokens:
	@echo "Replacing tokens in template: $(TEMPLATE)"
	scripts/makefile_scripts/replace_tokens.sh

build:
	@echo "Building template: $(TEMPLATE)"
	$(PACKER_PATH) build --var-file=$(VAR_FILE) ./packer

cleanup:
	@echo "Restoring original template: $(TEMPLATE)" to prepare for next build
	scripts/makefile_scripts/restore_template.sh

main: replace_tokens validate  build

