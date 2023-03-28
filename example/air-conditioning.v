
`define S1 0

`define S2 1

`define S3 2


module  (
    clk,
    rst,
    
    T,
    
    
    cooler,
    
    heater,
    
);

    input clk;
    input rst;
    
    input [7:0] T;
    
    
    output [0:0] cooler;
    
    output [0:0] heater;
    

    reg [1:0] state;
    reg [1:0] next_state;

    always @(posedge clk) begin
        if (rst) begin
            state <= 0;
        end else begin
            
            if (state == `S1) begin
                
                if (T > 35) begin
                    next_state <= `S2;
                end
                
                if (T < 15) begin
                    next_state <= `S3;
                end
                
            end
            
            if (state == `S2) begin
                
                if (T < 25) begin
                    next_state <= `S1;
                end
                
            end
            
            if (state == `S3) begin
                
                if (T > 30) begin
                    next_state <= `S1;
                end
                
            end
            
        end
    end
endmodule
     