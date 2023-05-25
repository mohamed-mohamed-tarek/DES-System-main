/*
 
 Module Name : fsm_ctrl
 
 Functionality :
 The fsm_ctrl is responsible for Controlling The Data Flow In the Architecture
 Through The load Flags, and It Selects The Appropriate Key And Round Inputs In
 addition to Generating the o_valid Flag When The Encryption/Decryption is Done
 
 */

module fsm_ctrl (input  wire    clk             ,
                 input  wire    rst_n           ,
                 input  wire    i_valid         ,
                 output wire    load_ip_out     ,
                 output wire    load_e_out      ,
                 output wire    load_s_out      ,
                 output wire    load_f_out      ,
                 output wire    load_out        ,
                 output wire    load_key        ,
                 output wire    [3:0] key_sel   ,
                 output reg     new_in_ready    ,
                 output reg     o_valid         ,
                 output wire    round_i_sel     );
    
    /************************************************************************************************************************************/
    /********************************************************* State Definition *********************************************************/
    /************************************************************************************************************************************/
    
    localparam IDLE   = 3'd0   ;
    localparam LOAD_1 = 3'd1   ;
    localparam LOAD_2 = 3'd2   ;
    localparam LOAD_3 = 3'd3   ;
    localparam LOAD_4 = 3'd4   ;
    localparam LOAD_5 = 3'd5   ;
    
    reg [2:0] PS, NS;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            PS <= IDLE;
        else
            PS <= NS;
    end
    
    localparam EARLY_I_IDLE = 3'd0   ;
    localparam EARLY_LOAD_1 = 3'd1   ;
    localparam EARLY_LOAD_2 = 3'd2   ;
    localparam EARLY_LOAD_3 = 3'd3   ;
    localparam EARLY_LOAD_4 = 3'd4   ;
    
    reg [2:0] EARLY_I_PS, EARLY_I_NS;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            EARLY_I_PS <= EARLY_I_IDLE;
        else
            EARLY_I_PS <= EARLY_I_NS;
    end

    /************************************************************************************************************************************/
    /********************************************************** Rounds Counter **********************************************************/
    /************************************************************************************************************************************/
    
    reg [3:0] Rounds_CNT    ;
    wire Round_Incr         ;
    reg early_in_rec        ;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            Rounds_CNT <= 4'd0;
        else if (EARLY_I_PS == EARLY_LOAD_4)
            Rounds_CNT <= 4'd1;
        else if (Round_Incr)
            Rounds_CNT <= Rounds_CNT + 1;
    end
            
    /************************************************************************************************************************************/
    /********************************************************* Next State Logic *********************************************************/
    /************************************************************************************************************************************/
    
    always @(*) begin
        case (PS)
            IDLE : begin
                if (EARLY_I_PS == EARLY_LOAD_4)
                    NS = LOAD_2;
                else if (i_valid && EARLY_I_PS == EARLY_I_IDLE)
                    NS = LOAD_1;
                else
                    NS = IDLE;
            end
            
            LOAD_1 :   NS = LOAD_2;
            
            LOAD_2 :   NS = LOAD_3;
            
            LOAD_3 :   NS = LOAD_4;
            
            LOAD_4 : begin
                if ((& Rounds_CNT) != 1)
                    NS = LOAD_2;
                else
                    NS = LOAD_5;
            end
            
            LOAD_5 : begin
                if (EARLY_I_PS == EARLY_LOAD_4)
                    NS = LOAD_2;
                else if (EARLY_I_PS != EARLY_I_IDLE)
                    NS = IDLE;
                else if (i_valid)
                    NS = LOAD_1;
                else
                    NS = IDLE;
            end
            
            default: NS = IDLE;
        endcase
    end
        
    /************************************************************************************************************************************/
    /********************************************************* o_valid Logic ************************************************************/
    /************************************************************************************************************************************/
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            o_valid <= 1'b0;
        else if (PS == LOAD_5)
            o_valid <= 1'b1;
        else if (PS == LOAD_2)
            o_valid <= 1'b0;
    end
               
    /************************************************************************************************************************************/
    /****************************************************** Handling Early Input ********************************************************/
    /************************************************************************************************************************************/
    
    always @(*) begin
        case (EARLY_I_PS)
            IDLE : begin
                if (i_valid && new_in_ready && PS != IDLE)
                    EARLY_I_NS = EARLY_LOAD_1;
                else
                    EARLY_I_NS = EARLY_I_IDLE;
            end
            
            EARLY_LOAD_1 : EARLY_I_NS = EARLY_LOAD_2;
            
            EARLY_LOAD_2 : EARLY_I_NS = EARLY_LOAD_3;
            
            EARLY_LOAD_3 : EARLY_I_NS = EARLY_LOAD_4;
            
            EARLY_LOAD_4 : EARLY_I_NS = EARLY_I_IDLE;
            
            default: EARLY_I_NS = EARLY_I_IDLE;
        endcase
    end
    
    /************************************************************************************************************************************/
    /********************************************************** new_in_ready ************************************************************/
    /************************************************************************************************************************************/
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            new_in_ready <= 1'b1;
        end
        else if ((PS == LOAD_4) && ((Rounds_CNT) == 4'd14))
            new_in_ready <= 1'b1;
        else if (i_valid)
            new_in_ready <= 1'b0;
    end

    /************************************************************************************************************************************/
    /*********************************************************** load Flags *************************************************************/
    /************************************************************************************************************************************/
    
    assign load_ip_out = ((PS == LOAD_1) || (EARLY_I_PS == EARLY_LOAD_1))       ?    1'b1:1'b0  ;
    assign load_e_out  = ((PS == LOAD_2) || (EARLY_I_PS == EARLY_LOAD_2))       ?    1'b1:1'b0  ;
    assign load_s_out  = ((PS == LOAD_3) || (EARLY_I_PS == EARLY_LOAD_3))       ?    1'b1:1'b0  ;
    assign load_f_out  = ((PS == LOAD_4) || (EARLY_I_PS == EARLY_LOAD_4))       ?    1'b1:1'b0  ;
    assign load_out    = (PS == LOAD_5)                                         ?    1'b1:1'b0  ;
    assign Round_Incr  = (PS == LOAD_4)                                         ?    1'b1:1'b0  ;

    assign load_key    = load_e_out;

    /************************************************************************************************************************************/
    /******************************************************* Round Input Selection ******************************************************/
    /************************************************************************************************************************************/
    
    assign round_i_sel = ((PS == LOAD_2 && Rounds_CNT == 4'd0) || EARLY_I_PS == LOAD_2) ? 1'b0 : 1'b1;

    /************************************************************************************************************************************/
    /******************************************************** Active Key Selection ******************************************************/
    /************************************************************************************************************************************/

    assign key_sel = (EARLY_I_PS == EARLY_LOAD_2) ? 4'd0:Rounds_CNT;
           
endmodule
