/*
 
 Module Name : key_gen
 
 Functionality :
 
 The key_gen Module takes the input key and generates 16 Sub-Keys each of size 48 Bits
 where Round 1 Should use o_key1 and So On in case of encryption. While for decryption
 The First Round Should Use Key 16, Round 2 Uses key 15 and So On.
 
 */

module key_gen(input    wire [64:1] i_key,
               output   wire [48:1] o_key1   ,
               output   wire [48:1] o_key2   ,
               output   wire [48:1] o_key3   ,
               output   wire [48:1] o_key4   ,
               output   wire [48:1] o_key5   ,
               output   wire [48:1] o_key6   ,
               output   wire [48:1] o_key7   ,
               output   wire [48:1] o_key8   ,
               output   wire [48:1] o_key9   ,
               output   wire [48:1] o_key10  ,
               output   wire [48:1] o_key11  ,
               output   wire [48:1] o_key12  ,
               output   wire [48:1] o_key13  ,
               output   wire [48:1] o_key14  ,
               output   wire [48:1] o_key15  ,
               output   wire [48:1] o_key16  );

    wire [56:1] PC1_Out;

    pc1 PC1_Module (
    .in(i_key),
    .out(PC1_Out)
    );

    wire [48:1] o_key_Levels [1:16];           // The Keys Generated At Different Levels
    wire [28:1] Left_Part [0:16];               // The Left Portions at Diff. Levels in Addition To the pc1 Portions
    wire [28:1] Right_Part [0:16];              // The Right Portions at Diff. Levels in Addition To the pc1 Portions

    assign Left_Part[0]  = PC1_Out [56:29];     // Left Portion At Level 0 (pc1 Output)
    assign Right_Part[0] = PC1_Out [28:1];      // Right Portion At Level 0 (pc1 Output)


    // Now We Generate The Levels Consisting Of Rotation Units in addition to The pc2
    genvar i;
    generate
    for (i = 1; i <= 16; i = i + 1) begin : blk
        wire [5:1] Level = i;
        rotate_left LeftPart_Rotate(Level, Left_Part[i - 1], Left_Part[i]);
        rotate_left RightPart_Rotate(Level, Right_Part[i - 1], Right_Part[i]);
        pc2 PC2_Module({Left_Part[i], Right_Part[i]}, o_key_Levels[i]);
    end
    endgenerate

    assign o_key1  = o_key_Levels[1]  ;
    assign o_key2  = o_key_Levels[2]  ;
    assign o_key3  = o_key_Levels[3]  ;
    assign o_key4  = o_key_Levels[4]  ;
    assign o_key5  = o_key_Levels[5]  ;
    assign o_key6  = o_key_Levels[6]  ;
    assign o_key7  = o_key_Levels[7]  ;
    assign o_key8  = o_key_Levels[8]  ;
    assign o_key9  = o_key_Levels[9]  ;
    assign o_key10 = o_key_Levels[10] ;
    assign o_key11 = o_key_Levels[11] ;
    assign o_key12 = o_key_Levels[12] ;
    assign o_key13 = o_key_Levels[13] ;
    assign o_key14 = o_key_Levels[14] ;
    assign o_key15 = o_key_Levels[15] ;
    assign o_key16 = o_key_Levels[16] ;

endmodule
