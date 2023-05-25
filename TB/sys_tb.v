//`timescale 1us/100ps

module sys_tb #(parameter DATA_WIDTH = 64, parameter ADDR_WIDTH = 4) ();
    
    //////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// Signals ///////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////
    
    reg wr_clk_tb;
    reg rd_clk_tb;
    reg wr_rstn_tb;
    reg rd_rstn_tb;
    reg wr_incr_tb;
    reg [DATA_WIDTH-1:0] wr_data_tb;
    reg [64:1] i_key_tb;
    reg mode_tb;                     // One In Case Of Encryption
    reg edit_sbox_tb;
    reg [3:0] new_sbox_val_tb;
    reg [2:0] sbox_sel_tb;
    reg [1:0] row_sel_tb;
    reg [3:0] col_sel_tb;
    wire full_tb;
    wire empty_tb;
    wire [64:1] o_data_tb;
    wire o_valid_tb;
    

    reg input_stimulus_en;

    integer i;
    integer j;
    
    //////////////////////////////////////////////////////////////////////////////
    //////////////////////////////// Test Values /////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////
    
    wire [64:1] i_data_test_values [0:2];
    wire [64:1] o_data_test_values [0:2];
    
    assign i_data_test_values [0] = 'h0123456701234567;
    assign o_data_test_values [0] = 'h0EB9460100C38224;
    
    assign i_data_test_values [1] = 'h01234EF6A0125489;
    assign o_data_test_values [1] = 'hCDB90A2E1D937C25;
    
    assign i_data_test_values [2] = 'h0823D567E1234F67;
    assign o_data_test_values [2] = 'h0F15D896A1FB3FA3;
    
    //////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////// Tests ////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////
    
    initial
    
    begin
    
    init_task (); // This Task Provides CLK initialization
    wr_rst_task ();
    rd_rst_task ();

    i = 0;
    j = 0;
    input_stimulus_en = 1'b1;
    
    #5000000 $finish();
    
    end

    always @(posedge wr_clk_tb) begin
        @(posedge wr_clk_tb);
        if (input_stimulus_en && (i < 3)) begin
            apply_data_and_incr(i_data_test_values[i]);
            i = i+1;
        end
    end

    always @(posedge o_valid_tb) begin
        if (j < 3) begin
            if (o_data_tb == o_data_test_values[j])
                $display  ("Test %d Passed", j);
            else
                $display  ("Test %d Failed", j);

            j = j + 1;
        end 
    end
    
    
    //////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////// Tasks ////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////
    
    task init_task ();
        // No Inputs Or Outputs
        begin
            i_key_tb        = 'h1E34560020505008;
            wr_data_tb      = 'd0;
            wr_clk_tb       = 1'b0;
            rd_clk_tb       = 1'b0;
            wr_rstn_tb      = 1'b0;
            rd_rstn_tb      = 1'b0;
            wr_incr_tb      = 1'b0;
            mode_tb         = 1'b1;
            edit_sbox_tb    = 1'b0;
            new_sbox_val_tb = 4'd0;
            sbox_sel_tb     = 3'd0;
            row_sel_tb      = 2'd0;
            col_sel_tb      = 4'd0;
            
        end
        
    endtask
    
    task wr_rst_task ();
        // No Inputs Or Outputs
        begin
            wr_rstn_tb                      = 1'b1;
            @(negedge wr_clk_tb) wr_rstn_tb = 1'b0;
            @(negedge wr_clk_tb) wr_rstn_tb = 1'b1;
        end
        
    endtask
    
    task rd_rst_task ();
        // No Inputs Or Outputs
        begin
            rd_rstn_tb                      = 1'b1;
            @(negedge rd_clk_tb) rd_rstn_tb = 1'b0;
            @(negedge rd_clk_tb) rd_rstn_tb = 1'b1;
        end
        
    endtask
    
    task apply_data_and_incr (
        input [64:1] i_data_val
        );
        // No Inputs Or Outputs
        begin
            wr_data_tb                      = i_data_val;
            wr_incr_tb                      = 1'b0;
            @(posedge wr_clk_tb) wr_incr_tb = 1'b1;
            @(posedge wr_clk_tb) wr_incr_tb = 1'b0;
        end
        
    endtask
    
    //////////////////////////////////////////////////////////////////////////////
    /////////////////////////////// CLK Generator ////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////
    
    
    always #3 wr_clk_tb = ~ wr_clk_tb;
    always #4 rd_clk_tb = ~ rd_clk_tb;
    
    //////////////////////////////////////////////////////////////////////////////
    ///////////////////////////// DUT Instantiation //////////////////////////////
    //////////////////////////////////////////////////////////////////////////////
    
    sys_top #(.DATA_WIDTH(64), .ADDR_WIDTH(4)) dut (
    .wr_clk(wr_clk_tb),
    .rd_clk(rd_clk_tb),
    .wr_rstn(wr_rstn_tb),
    .rd_rstn(rd_rstn_tb),
    .wr_incr(wr_incr_tb),
    .wr_data(wr_data_tb),
    .i_key(i_key_tb),
    .mode(mode_tb),
    .edit_sbox(edit_sbox_tb),
    .new_sbox_val(new_sbox_val_tb),
    .sbox_sel(sbox_sel_tb),
    .row_sel(row_sel_tb),
    .col_sel(col_sel_tb),
    .full(full_tb),
    .empty(empty_tb),
    .o_data(o_data_tb),
    .o_valid(o_valid_tb)
    );
    
    
    
endmodule
