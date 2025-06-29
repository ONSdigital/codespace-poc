.DEFAULT_GOAL := all

.PHONY: all
all: ## Show the available make targets.
	@echo "Usage: make <target>"
	@echo ""
	@echo "Targets:"
	@fgrep "##" Makefile | fgrep -v fgrep

.PHONY: clean ## Clean the project.
clean:
	@echo "Cleaning up..."
	rm -rf .mypy_cache
	rm -rf .pytest_cache
	rm -rf .coverage
	find . -name "__pycache__" -exec rm -rf {} +

.PHONY: lint
lint: ## Run linters.
	@echo "Running black..."
	poetry run black .
	@echo "Running flake8..."
	poetry run flake8 .
	@echo "Running isort..."
	poetry run isort .
	@echo "Running mypy..."
	poetry run mypy .

.PHONY: security_check
security_check: ## Run security checks.
	@echo "Running bandit..."
	poetry run bandit -c bandit.yaml -r .

.PHONY: test
test:  ## Run the tests and check coverage.
	poetry run pytest -n auto --cov=src --cov-report term-missing --cov-fail-under=95

.PHONY: md_lint
md_lint: ## Lint markdown files.
	@echo "Running markdownlint..."
	sh ./shell_scripts/md_lint.sh

.PHONY: run ## Run the application.
run: ## Run the application.
	poetry run streamlit run src/app.py
