{% for s in fsm.states %}
`define {{ s.name}} {{ loop.index - 1 }}
{% endfor %}

module {{ name }} (
    clk,
    rst,
    {% for i in fsm.inputs %}
    {{ i.name }},
    {% endfor %}
    {% for o in fsm.outputs %}
    {{ o.name }},
    {% endfor %}
);

    input clk;
    input rst;
    {% for i in fsm.inputs %}
    input [{{ i.length - 1 }}:0] {{ i.name }};
    {% endfor %}
    {% for o in fsm.outputs %}
    output [{{ o.length - 1 }}:0] {{ o.name }};
    {% endfor %}

    reg [{{ ceil(log2(fsm.states|length)) - 1 }}:0] state;
    reg [{{ ceil(log2(fsm.states|length)) - 1 }}:0] next_state;

    always @(posedge clk) begin
        if (rst) begin
            state <= 0;
        end else begin
            {% for s in fsm.states %}
            if (state == `{{ s.name }}) begin
                {% for t in s.transitions %}
                if ({{ t.condition }}) begin
                    next_state <= `{{ t.destination }};
                end
                {% endfor %}
            end
            {% endfor %}
        end
    end
endmodule
     