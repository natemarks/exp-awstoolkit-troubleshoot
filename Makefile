.DEFAULT_GOAL := help

# Determine this makefile's path.
# Be sure to place this BEFORE `include` directives, if any.
SHELL := $(shell which bash)
DEFAULT_BRANCH := main
COMMIT := $(shell git rev-parse HEAD)
CURRENT_BRANCH := $(shell git rev-parse --abbrev-ref HEAD)
DEFAULT_BRANCH := main
PYTHON_VERSION := 3.10.6
CDIR = $(shell pwd)
CDK := $(CDIR)/node_modules/.bin/cdk
AWS_ACCOUNT_NUMBER := 151924297945
AWS_REGION := us-east-1

help: ## Show this help.
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

.venv: ## create venv if it doesnt exist
	( \
	   source scripts/enable_pyenv.sh; \
	   pyenv local $(PYTHON_VERSION); \
	   python3 -m venv .venv; \
	   source .venv/bin/activate; \
	   pip install --upgrade pip setuptools; \
	   pip install -r requirements.txt; \
	)

clean-venv: ## re-create virtual env
	[[ -e .venv ]] && rm -rf .venv; \
	$(MAKE) .venv

pylint: ## run pylint on python files
	( \
       . .venv/bin/activate; \
       git ls-files '*.py' | xargs pylint --max-line-length=90; \
    )

black: ## use black to format python files
	( \
       . .venv/bin/activate; \
       git ls-files '*.py' |  xargs black --line-length=79; \
    )

black-check: ## use black to format python files
	( \
       . .venv/bin/activate; \
       git ls-files '*.py' |  xargs black --check --line-length=79; \
    )

shellcheck: ## use black to format python files
	( \
       git ls-files '*.sh' |  xargs shellcheck --format=gcc; \
    )

unit-test: ## run test that don't require deployed resources
	( \
       source .venv/bin/activate; \
       python3 -m pytest -v -m "unit" tests/; \
    )

aws-test: ## run test that requires AWS credentials
	( \
       source .venv/bin/activate; \
       python3 -m pytest -v -m "aws" tests/; \
    )

static: shellcheck black pylint ## run all static checks

clean-cache: ## clean python adn pytest cache data
	@find . -type f -name "*.py[co]" -delete -not -path "./.venv/*"
	@find . -type d -name __pycache__ -not -path "./.venv/*" -exec rm -rf {} \;
	@rm -rf .pytest_cache

git-status: ## require status is clean so we can use undo_edits to put things back
	@status=$$(git status --porcelain); \
	if [ ! -z "$${status}" ]; \
	then \
		echo "Error - working directory is dirty. Commit those changes!"; \
		exit 1; \
	fi
.PHONY: build static test artifact
