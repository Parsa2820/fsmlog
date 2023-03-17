from model.fsm import *
import typer

app = typer.Typer()


def validate_helper(file: str):
    with open(file, "r") as f:
        data = f.read()
    try:
        fsm = FiniteStateMachine.from_json(data)
        fsm.validate()
        typer.echo(f"FSM {file} is valid")
        return fsm
    except Exception as e:
        typer.echo(f"FSM {file} is not valid: {e}")
        raise typer.Exit(code=1)


@app.command()
def convert(input: str, output: str = None):
    fsm = validate_helper(input)
    verilog = fsm.to_verilog()
    if output is None:
        typer.echo(verilog)
    else:
        with open(output, "w") as f:
            f.write(verilog)


@app.command()
def validate(input: str):
    validate_helper(input)


def main():
    app()


if __name__ == "__main__":
    main()
