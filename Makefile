ROLE_NAME := $(notdir $(CURDIR))

.PHONY: init lint check run clean

init:
	@mkdir -p tests/roles
	@ln -sfn ../.. tests/roles/$(ROLE_NAME)
	@printf "[defaults]\nroles_path = ..\ninventory = tests/inventory\ndeprecation_warnings = False\n" > ansible.cfg
	@touch .gitignore
	@grep -qxF "tests/roles/" .gitignore || echo "tests/roles/" >> .gitignore
	@grep -qxF ".ansible/" .gitignore || echo ".ansible/" >> .gitignore
	@grep -qxF "ansible.cfg" .gitignore || echo "ansible.cfg" >> .gitignore
	@echo "Entorno inicializado para el rol '$(ROLE_NAME)'."

check: init
	@sudo -v
	ansible-playbook tests/test.yml --check --diff

run: init
	@sudo -v
	ansible-playbook tests/test.yml --diff

clean:
	rm -rf tests/roles .ansible ansible.cfg