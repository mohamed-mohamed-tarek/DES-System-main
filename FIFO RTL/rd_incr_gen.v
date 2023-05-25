module rd_incr_gen (input wire clk,
                    input wire rst_n,
                    input wire i_line,
                    output wire o_incr);
    
    reg i_line_delayed;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            i_line_delayed <= 1'b0;
        else
            i_line_delayed <= i_line;
    end
    
    assign o_incr = i_line_delayed & (~i_line);
endmodule
