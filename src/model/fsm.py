from __future__ import annotations
from dataclasses import dataclass
import json
from dacite import from_dict
import jinja2


@dataclass
class Register:
    name: str
    length: int


@dataclass
class Trasition:
    destination: str
    condition: str


@dataclass
class State:
    name: str
    transitions: list[Trasition]
    outputs: dict[str, int]


@dataclass
class FiniteStateMachine:
    TEMPLATE_PATH = "src/template.v"
    inputs: list[Register]
    outputs: list[Register]
    states: list[State]
    initial_state: str

    @staticmethod
    def from_json(data: str) -> FiniteStateMachine:
        return from_dict(data_class=FiniteStateMachine, data=json.loads(data))

    def validate(self):
        if self.initial_state not in [state.name for state in self.states]:
            raise Exception(
                f"Initial state {self.initial_state} not found in states")
        for state in self.states:
            for transition in state.transitions:
                if transition.destination not in [state.name for state in self.states]:
                    raise Exception(
                        f"Transition destination {transition.destination} not found in states")
                # TODO: validate condition
            for output in state.outputs:
                if output not in [register.name for register in self.outputs]:
                    raise Exception(f"Output {output} not found in outputs")
                register = [
                    register for register in self.outputs if register.name == output][0]
                if state.outputs[output] >= 2**register.length:
                    raise Exception(
                        f"Output {output} value {state.outputs[output]} is greater than register length {register.length}")

    def to_verilog(self) -> str:
        with open(self.TEMPLATE_PATH, "r") as f:
            template = jinja2.Template(f.read())
        import math
        template.globals["log2"] = math.log2
        template.globals["ceil"] = math.ceil
        return template.render(fsm=self)
