module xor_gate #(parameter WIDTH = 8)

            (input  wire [WIDTH-1:0] i_data_1   ,
             input  wire [WIDTH-1:0] i_data_2   ,
             output wire [WIDTH-1:0] o_data     );
    
    assign o_data = i_data_1 ^ i_data_2;
    
endmodule
