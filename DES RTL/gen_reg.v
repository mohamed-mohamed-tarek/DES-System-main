/*
 
 Module Name : gen_reg
 
 Functionality :
 Parameterized Register With load Signal
 
 */
module gen_reg #(parameter WIDTH = 64)

               (input   wire                    clk         ,
                input   wire                    rst_n       ,
                input   wire                    load        ,
                input   wire    [WIDTH-1:0]     i_data      ,
                output  reg     [WIDTH-1:0]     o_data      );
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            o_data <= 'd0;
        else if (load)
            o_data <= i_data;
    end
    
endmodule
