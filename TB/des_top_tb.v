module des_top_tb (); // No Inputs Or Outputs
    
    //////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// Signals ///////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////
    
    reg           clk_tb             ;
    reg           rst_n_tb           ;
    reg  [64:1]   i_data_tb          ;
    reg  [64:1]   i_key_tb           ;
    reg           i_valid_tb         ;
    reg           mode_tb            ;   // One In Case Of Encryption
    reg           edit_sbox_tb       ;
    reg  [3:0]    new_sbox_val_tb    ;
    reg  [2:0]    sbox_sel_tb        ;
    reg  [1:0]    row_sel_tb         ;
    reg  [3:0]    col_sel_tb         ;
    wire          new_in_ready_tb    ;
    wire [64:1]   o_data_tb          ;
    wire          o_valid_tb         ;

    integer i;
    
    //////////////////////////////////////////////////////////////////////////////
    //////////////////////////////// Test Values /////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////

    wire [64:1] i_data_test_values [0:2];
    wire [64:1] i_key_test_values  [0:2];
    wire [64:1] o_data_test_values [0:2];

    assign i_data_test_values [0] = 'h0123456701234567;
    assign i_key_test_values  [0] = 'h1234567812345678;
    assign o_data_test_values [0] = 'h5E1D7FC61FCFB535;

    assign i_data_test_values [1] = 'h0123456701234567;
    assign i_key_test_values  [1] = 'h1E34560020505008;
    assign o_data_test_values [1] = 'h0EB9460100C38224;

    assign i_data_test_values [2] = 'h0823D567E1234F67;
    assign i_key_test_values  [2] = 'h1E34560020505008;
    assign o_data_test_values [2] = 'h0F15D896A1FB3FA3;

    //////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////// Tests ////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////
    
    initial
    begin

        init_task (); // This Task Provides CLK initialization
        rst_task ();

        for (i = 0 ; i<=2 ; i=i+1) begin
            config_i_data (i_data_test_values [i]);
            config_i_key  (i_key_test_values  [i]);
            @(negedge clk_tb);
            
            i_valid_pulse_task ();

            @(posedge o_valid_tb);

            if (o_data_tb == o_data_test_values[i])
                $display ("Test Case %D Passed...", i); 
            else
                $display ("Test Case %D Failed...", i); 
        end


        #100 $finish();
    end
    
    
    //////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////// Tasks ////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////
    
    task init_task ();
        // No Inputs Or Outputs
        begin
            clk_tb              = 1'b1;
            i_data_tb           = 64'd0;
            i_key_tb            = 64'd0;
            i_valid_tb          = 1'b0;
            mode_tb             = 1'b1;
            edit_sbox_tb        = 1'b0;
            new_sbox_val_tb     = 4'd0;
            sbox_sel_tb         = 3'd0;
            row_sel_tb          = 2'd0;
            col_sel_tb          = 4'd0;
        end
        
    endtask

    task rst_task ();
        // No Inputs Or Outputs
        begin
            rst_n_tb = 1'b1;
            @(negedge clk_tb) rst_n_tb = 1'b0;
            @(negedge clk_tb) rst_n_tb = 1'b1;
        end
        
    endtask

    task i_valid_pulse_task ();
        // No Inputs Or Outputs
        begin
            i_valid_tb = 1'b0;
            @(negedge clk_tb) i_valid_tb = 1'b1;
            @(negedge clk_tb) i_valid_tb = 1'b0;
        end
        
    endtask

    task config_i_data (
        input [64:1] i_data_val
        );
        
        begin
            i_data_tb = i_data_val;
        end
        
    endtask

    task config_i_key (
        input [64:1] i_key_val
        );
        
        begin
            i_key_tb = i_key_val;
        end
        
    endtask
    //////////////////////////////////////////////////////////////////////////////
    /////////////////////////////// CLK Generator ////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////
    
    
    always #10 clk_tb = ~ clk_tb;
    
    
    //////////////////////////////////////////////////////////////////////////////
    ///////////////////////////// DUT Instantiation //////////////////////////////
    //////////////////////////////////////////////////////////////////////////////
    
    des_top dut (
    .clk(clk_tb)                        ,
    .rst_n(rst_n_tb)                    ,
    .i_data(i_data_tb)                  ,
    .i_key(i_key_tb)                    ,
    .i_valid(i_valid_tb)                ,
    .mode(mode_tb)                      ,
    .edit_sbox(edit_sbox_tb)            ,
    .new_sbox_val(new_sbox_val_tb)      ,
    .sbox_sel(sbox_sel_tb)              ,
    .row_sel(row_sel_tb)                ,
    .col_sel(col_sel_tb)                ,
    .new_in_ready(new_in_ready_tb)      ,
    .o_data(o_data_tb)                  ,
    .o_valid(o_valid_tb)
    );
    
    
    
endmodule
