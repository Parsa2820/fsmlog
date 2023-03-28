# fsmlog
[![Upload Python Package](https://github.com/Parsa2820/fsmlog/actions/workflows/python-publish.yml/badge.svg)](https://github.com/Parsa2820/fsmlog/actions/workflows/python-publish.yml)

A tool for converting finite state machine to verilog code

Embedded Systems Course Optional Assignment - Spring 2023

Parsa Mohammadian - 98102284

## Table of Contents
- [Installation](#installation)
- [Usage](#usage)
    - [Validate](#validate)
    - [Convert](#convert)
- [Specifications](#specifications)
- [Technical Details](#technical-details)

## Installation
From pypi:
```bash
pip install fsmlog
```
From source:
```bash
make install
```

## Usage
> You can use `--help` to get more information about the usage of each command.

The tool consists of two commands: `validate` and `convert`.

### Validate
The `validate` command is used to validate the input file. It will check if the input file is a valid finite state machine according to the tool's [specifications](#specifications). It takes one argument: the path to the input file.

### Convert
The `convert` command is used to convert the input file to verilog code. It takes two arguments: the path to the input file and the path to the output file. If the output file is not specified, the output will be printed to the console.

## Specifications
The input file must be a valid json file with the following structure:
```json
{
    "inputs": [],
    "outputs": [],
    "states": [],
    "initial_state": "",
}
```
The `inputs` and `outputs` fields are lists of registers. Each register has the following structure:
```json
{
    "name": "",
    "length": 0
}
```
The `states` field is a list of states. Each state has the following structure:
```json
{
    "name": "",
    "transitions": [],
    "outputs": {}
}
```
The `outputs` field is just key-value pairs of the output registers. The `transitions` field is a list of transitions. Each transition has the following structure:
```json
{
    "destination": "",
    "condition": ""
}
```
The `condition` field must be a valid verilog boolean expression.

> Valid input file examples can be found in the [example](example) directory.

## Technical Details
The tool uses [jinja2](https://jinja.palletsprojects.com/en/3.0.x/) to generate the verilog code. The `template.v` file can be found in the [src](src) directory. This template can be populated with the `FiniteStateMachine` object named `fsm`. The `FiniteStateMachine` object is created from the input file using the `FiniteStateMachine.from_json` method. The `FiniteStateMachine` class has similar attributes to the input file's structure. The `FiniteStateMachine` class can be found in the [src/model/fsm.py](src/model/fsm.py) file.


