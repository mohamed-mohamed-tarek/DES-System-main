/*
 
 Module Name : pc1
 
 Functionality:
 The Module is used to re-order the key bits. However, it drops the parity bits
 where the output is 56 bits wide (64-8).
 
 */

module pc1(input [64:1] in,
           output [56:1] out);

assign out =   {in[8],  in[16], in[24], in[32], in[40], 
                in[48], in[56], in[64], in[7], 
                in[15], in[23], in[31], in[39], 
                in[47], in[55], in[63], in[6], 
                in[14], in[22], in[30], in[38], 
                in[46], in[54], in[62], in[5], 
                in[13], in[21], in[29], in[2], 
                in[10], in[18], in[26], in[34], 
                in[42], in[50], in[58], in[3], 
                in[11], in[19], in[27], in[35], 
                in[43], in[51], in[59], in[4], 
                in[12], in[20], in[28], in[36], 
                in[44], in[52], in[60], in[37], 
                in[45], in[53], in[61]};

endmodule
