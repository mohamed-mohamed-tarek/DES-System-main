module sbox_5 (input wire clk,
                input wire rst_n,
                input wire [5:0] i_data,
                input wire edit_sbox,
                input wire [3:0] new_sbox_val,
                input wire [2:0] sbox_sel,
                input wire [1:0] row_sel,
                input wire [3:0] col_sel,
                output reg [3:0] o_data);

    /*********************************************************************************************************************************/
    /****************************************************** Assigning The Table ******************************************************/
    /*********************************************************************************************************************************/
    
    reg [3:0] row0_regs [0:15];
    reg [3:0] row1_regs [0:15];
    reg [3:0] row2_regs [0:15];
    reg [3:0] row3_regs [0:15];
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            row0_regs[0] <= 'd2;
            row0_regs[1] <= 'd12;
            row0_regs[2] <= 'd4;
            row0_regs[3] <= 'd1;
            row0_regs[4] <= 'd7;
            row0_regs[5] <= 'd10;
            row0_regs[6] <= 'd11;
            row0_regs[7] <= 'd6;
            row0_regs[8] <= 'd8;
            row0_regs[9] <= 'd5;
            row0_regs[10] <= 'd3;
            row0_regs[11] <= 'd15;
            row0_regs[12] <= 'd13;
            row0_regs[13] <= 'd0;
            row0_regs[14] <= 'd14;
            row0_regs[15] <= 'd9;
        end
        else if (edit_sbox && (sbox_sel == 4'd4) && (row_sel == 2'd0))
            row0_regs[col_sel] <= new_sbox_val;
    end
        
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            row1_regs[0] <= 'd14;
            row1_regs[1] <= 'd11;
            row1_regs[2] <= 'd2;
            row1_regs[3] <= 'd12;
            row1_regs[4] <= 'd4;
            row1_regs[5] <= 'd7;
            row1_regs[6] <= 'd13;
            row1_regs[7] <= 'd1;
            row1_regs[8] <= 'd5;
            row1_regs[9] <= 'd0;
            row1_regs[10] <= 'd15;
            row1_regs[11] <= 'd10;
            row1_regs[12] <= 'd3;
            row1_regs[13] <= 'd9;
            row1_regs[14] <= 'd8;
            row1_regs[15] <= 'd6;
        end
        else if (edit_sbox && (sbox_sel == 4'd4) && (row_sel == 2'd1))
            row1_regs[col_sel] <= new_sbox_val;
    end
            
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            row2_regs[0] <= 'd4;
            row2_regs[1] <= 'd2;
            row2_regs[2] <= 'd1;
            row2_regs[3] <= 'd11;
            row2_regs[4] <= 'd10;
            row2_regs[5] <= 'd13;
            row2_regs[6] <= 'd7;
            row2_regs[7] <= 'd8;
            row2_regs[8] <= 'd15;
            row2_regs[9] <= 'd9;
            row2_regs[10] <= 'd12;
            row2_regs[11] <= 'd5;
            row2_regs[12] <= 'd6;
            row2_regs[13] <= 'd3;
            row2_regs[14] <= 'd0;
            row2_regs[15] <= 'd14;
        end
        else if (edit_sbox && (sbox_sel == 4'd4) && (row_sel == 2'd2))
            row2_regs[col_sel] <= new_sbox_val;
    end
                
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            row3_regs[0] <= 'd11;
            row3_regs[1] <= 'd8;
            row3_regs[2] <= 'd12;
            row3_regs[3] <= 'd7;
            row3_regs[4] <= 'd1;
            row3_regs[5] <= 'd14;
            row3_regs[6] <= 'd2;
            row3_regs[7] <= 'd13;
            row3_regs[8] <= 'd6;
            row3_regs[9] <= 'd15;
            row3_regs[10] <= 'd0;
            row3_regs[11] <= 'd9;
            row3_regs[12] <= 'd10;
            row3_regs[13] <= 'd4;
            row3_regs[14] <= 'd5;
            row3_regs[15] <= 'd3;
        end
        else if (edit_sbox && (sbox_sel == 4'd4) && (row_sel == 2'd3))
            row3_regs[col_sel] <= new_sbox_val;
    end
                    
    /*********************************************************************************************************************************/
    /***************************************************** Selecting The Output ******************************************************/
    /*********************************************************************************************************************************/
    
    wire [1:0] o_row_sel;
    wire [3:0] o_col_sel = i_data [4:1];
    
    assign o_row_sel = {i_data[5], i_data[0]};
    
    always @(*) begin
        case (o_row_sel)
            2'b00:  o_data = row0_regs[o_col_sel];
            2'b01:  o_data = row1_regs[o_col_sel];
            2'b10:  o_data = row2_regs[o_col_sel];
            2'b11:  o_data = row3_regs[o_col_sel];
        endcase
    end
                    
endmodule
