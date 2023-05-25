module des_top (input wire           clk             ,
                input wire           rst_n           ,
                input wire  [64:1]   i_data          ,
                input wire  [64:1]   i_key           ,
                input wire           i_valid         ,
                input wire           mode            ,   // One In Case Of Encryption
                input wire           edit_sbox       ,
                input wire  [3:0]    new_sbox_val    ,
                input wire  [2:0]    sbox_sel        ,
                input wire  [1:0]    row_sel         ,
                input wire  [3:0]    col_sel         ,
                output wire          new_in_ready    ,
                output wire [64:1]   o_data          ,
                output wire          o_valid         );
    
    /************************************************************************************************************************************/
    /************************************************************ ip Section ************************************************************/
    /************************************************************************************************************************************/
    
    wire [63:0] ip_out_reg;
    wire [63:0] ip_out;

    ip u_initial_permutation_module(
    .in(i_data),
    .out(ip_out)
    );
    
    gen_reg #(.WIDTH(64)) u_ip_out_reg (
    .clk(clk),
    .rst_n(rst_n),
    .load(load_ip_out),
    .i_data(ip_out),
    .o_data(ip_out_reg)
    );
    
    /************************************************************************************************************************************/
    /********************************************************** Expand Section **********************************************************/
    /************************************************************************************************************************************/
    
    wire [31:0] l_o;
    wire [31:0] r_o;
    wire [31:0] l_out_reg;
    wire [31:0] r_out_reg;
    wire [31:0] r_mux_out;
    wire [31:0] r_mux_out_reg1;
    wire [31:0] l_mux_out;
    wire [31:0] l_mux_out_reg1;
    wire [31:0] l_mux_out_reg2;
    wire round_i_sel;

        
    assign r_o = ip_out_reg [31:0];
    assign l_o = ip_out_reg [63:32];
    
    mux_2x1 #(.WIDTH(32)) u_r_mux (
    .in0(r_o),
    .in1(l_out_reg),
    .sel(round_i_sel),
    .out(r_mux_out)
    );
    
    mux_2x1 #(.WIDTH(32)) u_l_mux (
    .in0(l_o),
    .in1(r_out_reg),
    .sel(round_i_sel),
    .out(l_mux_out)
    );
    

    wire [47:0] e_out;
    wire [47:0] e_out_reg;

    exp_permutation u_e_module (
    .in(r_mux_out),
    .out(e_out)
    );
    
    gen_reg #(.WIDTH(48)) u_e_out_reg (
    .clk(clk),
    .rst_n(rst_n),
    .load(load_e_out),
    .i_data(e_out),
    .o_data(e_out_reg)
    );
    
    gen_reg #(.WIDTH(32)) u_l_mux_reg1 (
    .clk(clk),
    .rst_n(rst_n),
    .load(load_e_out),
    .i_data(l_mux_out),
    .o_data(l_mux_out_reg1)
    );
    
    gen_reg #(.WIDTH(32)) u_r_mux_reg1 (
    .clk(clk),
    .rst_n(rst_n),
    .load(load_e_out),
    .i_data(r_mux_out),
    .o_data(r_mux_out_reg1)
    );
    /************************************************************************************************************************************/
    /********************************************************** S Box Section ***********************************************************/
    /************************************************************************************************************************************/
    wire [47:0] xor_out;
    wire [47:0] active_key;
    wire [47:0] active_key_reg;
    wire [31:0] r_mux_out_reg2;

    xor_gate #(.WIDTH(48)) u_xor_gate (
    .i_data_1(e_out_reg),
    .i_data_2(active_key_reg),
    .o_data(xor_out)
    );
    
    wire [6:1] S1_in, S2_in, S3_in, S4_in, S5_in, S6_in, S7_in, S8_in;
    assign {S1_in, S2_in, S3_in, S4_in, S5_in, S6_in, S7_in, S8_in} = xor_out;

    wire [4:1] S1_out, S2_out, S3_out, S4_out, S5_out, S6_out, S7_out, S8_out;
    sbox_1 S1_inst(clk, rst_n, S1_in, edit_sbox, new_sbox_val, sbox_sel, row_sel, col_sel, S1_out);
    sbox_2 S2_inst(clk, rst_n, S2_in, edit_sbox, new_sbox_val, sbox_sel, row_sel, col_sel, S2_out);
    sbox_3 S3_inst(clk, rst_n, S3_in, edit_sbox, new_sbox_val, sbox_sel, row_sel, col_sel, S3_out);
    sbox_4 S4_inst(clk, rst_n, S4_in, edit_sbox, new_sbox_val, sbox_sel, row_sel, col_sel, S4_out);
    sbox_5 S5_inst(clk, rst_n, S5_in, edit_sbox, new_sbox_val, sbox_sel, row_sel, col_sel, S5_out);
    sbox_6 S6_inst(clk, rst_n, S6_in, edit_sbox, new_sbox_val, sbox_sel, row_sel, col_sel, S6_out);
    sbox_7 S7_inst(clk, rst_n, S7_in, edit_sbox, new_sbox_val, sbox_sel, row_sel, col_sel, S7_out);
    sbox_8 S8_inst(clk, rst_n, S8_in, edit_sbox, new_sbox_val, sbox_sel, row_sel, col_sel, S8_out);
    
    wire [31:0] s_box_out;
    wire [31:0] s_box_out_reg;
    assign s_box_out = {S1_out, S2_out, S3_out, S4_out, S5_out, S6_out, S7_out, S8_out};
    
    gen_reg #(.WIDTH(32)) u_s_box_out_reg (
    .clk(clk),
    .rst_n(rst_n),
    .load(load_s_out),
    .i_data(s_box_out),
    .o_data(s_box_out_reg)
    );
    
    gen_reg #(.WIDTH(32)) u_l_mux_reg2 (
    .clk(clk),
    .rst_n(rst_n),
    .load(load_s_out),
    .i_data(l_mux_out_reg1),
    .o_data(l_mux_out_reg2)
    );
    
    gen_reg #(.WIDTH(32)) u_r_mux_reg2 (
    .clk(clk),
    .rst_n(rst_n),
    .load(load_s_out),
    .i_data(r_mux_out_reg1),
    .o_data(r_mux_out_reg2)
    );
    /************************************************************************************************************************************/
    /********************************************************* Fixed P Section **********************************************************/
    /************************************************************************************************************************************/
    wire [31:0] p_out;
    wire [31:0] l_out;

    fixedp_func u_p_module(
    .in (s_box_out_reg),
    .out (p_out)
    );
    
    xor_gate #(.WIDTH(32)) u_xor_gate2(
    .i_data_1(l_mux_out_reg2),
    .i_data_2(p_out),
    .o_data(l_out)
    );
    
    gen_reg #(.WIDTH(32)) u_l_out_reg (
    .clk(clk),
    .rst_n(rst_n),
    .load(load_f_out),
    .i_data(l_out),
    .o_data(l_out_reg)
    );
    
    gen_reg #(.WIDTH(32)) u_r_out_reg3 (
    .clk(clk),
    .rst_n(rst_n),
    .load(load_f_out),
    .i_data(r_mux_out_reg2),
    .o_data(r_out_reg)
    );
    
    /************************************************************************************************************************************/
    /********************************************************** IP_inV Section **********************************************************/
    /************************************************************************************************************************************/
    
    wire [64:1] ip_inv_in;
    wire [64:1] ip_inv_out;
    
    assign ip_inv_in = {l_out_reg, r_out_reg};
    
    ip_inverse u_ip_inv_module (
    .in(ip_inv_in),
    .out(ip_inv_out)
    );
    
    gen_reg #(.WIDTH(64)) u_out_reg (
    .clk(clk),
    .rst_n(rst_n),
    .load(load_out),
    .i_data(ip_inv_out),
    .o_data(o_data)
    );
    
    /************************************************************************************************************************************/
    /******************************************************** FSM Instantiation *********************************************************/
    /************************************************************************************************************************************/
    
    wire [47:0] o_key1, o_key2, o_key3, o_key4, o_key5, o_key6, o_key7, o_key8, o_key9,
     o_key10, o_key11, o_key12, o_key13, o_key14, o_key15, o_key16;
    wire [3:0] key_sel;

    wire [48:1] ActiveKey_Encrypt;
    wire [48:1] ActiveKey_Decrypt;

    fsm_ctrl u_fsm_module(
    .clk(clk),
    .rst_n(rst_n),
    .i_valid(i_valid),
    .load_ip_out(load_ip_out),
    .load_e_out(load_e_out),
    .load_s_out(load_s_out),
    .load_f_out(load_f_out),
    .load_out(load_out),
    .load_key(load_key),
    .new_in_ready(new_in_ready),
    .key_sel(key_sel),
    .o_valid(o_valid),
    .round_i_sel(round_i_sel));
    
    key_gen u_key_gen(
    .i_key(i_key),
    .o_key1(o_key1),
    .o_key2(o_key2),
    .o_key3(o_key3),
    .o_key4(o_key4),
    .o_key5(o_key5),
    .o_key6(o_key6),
    .o_key7(o_key7),
    .o_key8(o_key8),
    .o_key9(o_key9),
    .o_key10(o_key10),
    .o_key11(o_key11),
    .o_key12(o_key12),
    .o_key13(o_key13),
    .o_key14(o_key14),
    .o_key15(o_key15),
    .o_key16(o_key16));
    
    mux_16x1 #(.WIDTH (48)) u_keys_mux_encrypt (
    .in0(o_key1),
    .in1(o_key2),
    .in2(o_key3),
    .in3(o_key4),
    .in4(o_key5),
    .in5(o_key6),
    .in6(o_key7),
    .in7(o_key8),
    .in8(o_key9),
    .in9(o_key10),
    .in10(o_key11),
    .in11(o_key12),
    .in12(o_key13),
    .in13(o_key14),
    .in14(o_key15),
    .in15(o_key16),
    .sel(key_sel),
    .out(ActiveKey_Encrypt));

    mux_16x1 #(.WIDTH (48)) u_keys_mux_decrypt (
    .in0(o_key16),
    .in1(o_key15),
    .in2(o_key14),
    .in3(o_key13),
    .in4(o_key12),
    .in5(o_key11),
    .in6(o_key10),
    .in7(o_key9),
    .in8(o_key8),
    .in9(o_key7),
    .in10(o_key6),
    .in11(o_key5),
    .in12(o_key4),
    .in13(o_key3),
    .in14(o_key2),
    .in15(o_key1),
    .sel(key_sel),
    .out(ActiveKey_Decrypt));

    mux_2x1 #(.WIDTH(48)) u_active_key_mux (
    .in0(ActiveKey_Decrypt),
    .in1(ActiveKey_Encrypt),
    .sel(mode),
    .out(active_key)
    );

    gen_reg #(.WIDTH(48)) u_key_reg (
    .clk(clk),
    .rst_n(rst_n),
    .load(load_key),
    .i_data(active_key),
    .o_data(active_key_reg)
    );
endmodule
