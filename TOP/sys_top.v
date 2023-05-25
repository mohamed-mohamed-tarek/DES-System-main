module sys_top #(parameter DATA_WIDTH = 64,
                 parameter ADDR_WIDTH = 4)
                (input wire wr_clk,
                 input wire rd_clk,
                 input wire wr_rstn,
                 input wire rd_rstn,
                 input wire wr_incr,
                 input wire [DATA_WIDTH-1:0] wr_data,
                 input wire [64:1] i_key,
                 input wire mode,                     // One In Case Of Encryption
                 input wire edit_sbox,
                 input wire [3:0] new_sbox_val,
                 input wire [2:0] sbox_sel,
                 input wire [1:0] row_sel,
                 input wire [3:0] col_sel,
                 output wire full,
                 output wire empty,
                 output wire [64:1] o_data,
                 output wire o_valid);
    
    //////////////////////////////////////////////////////////////////////////////
    ///////////////////////////// DES Instantiation //////////////////////////////
    //////////////////////////////////////////////////////////////////////////////
    
    wire [64:1] i_des_text;
    wire empty_inv;
    
    wire i_rdincr_pulse_gen;
    wire o_rdincr_pulse_gen;
    
    
    assign empty_inv = ~empty;
    
    des_top u_des_block (
    .clk(rd_clk),
    .rst_n(rd_rstn),
    .i_data(i_des_text),
    .i_key(i_key),
    .i_valid(empty_inv),
    .mode(mode),
    .edit_sbox(edit_sbox),
    .new_sbox_val(new_sbox_val),
    .sbox_sel(sbox_sel),
    .row_sel(row_sel),
    .col_sel(col_sel),
    .new_in_ready(i_rdincr_pulse_gen),
    .o_data(o_data),
    .o_valid(o_valid)
    );
    
    //////////////////////////////////////////////////////////////////////////////
    //////////////////////////// FIFO Instantiation //////////////////////////////
    //////////////////////////////////////////////////////////////////////////////
    
    fifo #(.DSIZE(DATA_WIDTH), .ASIZE(ADDR_WIDTH)) u_fifo_block (
    .rdata(i_des_text),
    .wfull(full),
    .rempty(empty),
    .wdata(wr_data),
    .winc(wr_incr),
    .wclk(wr_clk),
    .wrst_n(wr_rstn),
    .rinc(o_rdincr_pulse_gen),
    .rclk(rd_clk),
    .rrst_n(rd_rstn)
    );
    
    
    
    //////////////////////////////////////////////////////////////////////////////
    ///////////////////////// Pulse Gen. Instantiation ///////////////////////////
    //////////////////////////////////////////////////////////////////////////////
    
    rd_incr_gen u_rd_incr_gen (
    .clk(rd_clk),
    .rst_n(rd_rstn),
    .i_line(i_rdincr_pulse_gen),
    .o_incr(o_rdincr_pulse_gen)
    );
    
endmodule
