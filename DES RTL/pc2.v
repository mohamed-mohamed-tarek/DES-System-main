/*

 Module Name : pc2
 
 Functionality:
 pc2 selects the 48-bit subkey for each round from the 56-bit
 key-schedule state.
 
 */

module pc2(input    [56:1] in   ,
           output   [48:1] out  );

    assign out =   {in[43], in[40], in[46], in[33], in[56], 
                    in[52], in[54], in[29], in[42], 
                    in[51], in[36], in[47], in[34], 
                    in[38], in[45], in[53], in[31], 
                    in[49], in[41], in[50], in[30], 
                    in[37], in[44], in[55], in[16], 
                    in[5],  in[26], in[20], in[10], 
                    in[2],  in[27], in[17], in[6], 
                    in[12], in[24], in[9], in[13], 
                    in[8],  in[18], in[1], in[23], 
                    in[4],  in[11], in[15], in[7], 
                    in[21], in[28], in[25]};

endmodule
