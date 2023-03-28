# Name of the virtual environment directory
VENV := .venv
# All the python files in the project
SOURCES := $(shell find src -name '*.py')

# Default target
.PHONY: all
all: help

.PHONY: help
help:
	@echo "Please use 'make <target>' where <target> is one of"
	@echo "  help: to show this help message"
	@echo "  venv: to create a virtual environment and install dependencies"
	@echo "  build: to build the fsmlog"
	@echo "  install: to install the fsmlog in the current virtual environment"
	@echo "  clean: to remove the virtual environment and build files"

.PHONY: venv
venv: .venv/bin/activate
.venv/bin/activate: requirements.txt
	@echo "Creating virtual environment..."
	@python -m venv $(VENV)
	@echo "Installing dependencies..."
	@$(VENV)/bin/pip install -r requirements.txt
	@echo "Installing build dependencies..."
	@$(VENV)/bin/pip install setuptools build
	@touch $(VENV)/bin/activate

.PHONY: build
build: venv setup.py setup.cfg $(SOURCES)
	@echo "Removing old build files..."
	@rm -rf dist
	@echo "Building..."
	@$(VENV)/bin/python -m build

.PHONY: install
install: build
	@echo "Uninstalling old version..."
	@$(VENV)/bin/pip uninstall -y fsmlog
	@echo "Installing..."
	@$(VENV)/bin/python -m pip install --upgrade dist/*.whl

.PHONY: clean
clean:
	@echo "Removing virtual environment..."
	@rm -rf $(VENV)
	@echo "Removing build files..."
	@rm -rf dist
	@echo "Removing egg-info files..."
	@rm -rf *.egg-info
	@echo "Removing pycache files..."
	@find . -name '__pycache__' -exec rm -rf {} +
	@find . -name '*.pyc' -exec rm -f {} +
