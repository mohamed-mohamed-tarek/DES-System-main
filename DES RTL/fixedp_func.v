/*
 
 Module Name : exp_permutation
 
 Functionality :
 The fixedp_func is Used In Each Round Logic to re-order the S Boxes Output
 Following The Standard Order Before Being XORed with The Left Portion
 Generating The Function Output Which Will Be the Right Portion Of the New Round
 
 */

module fixedp_func(input    [32:1] in   ,
                   output   [32:1] out  );

    assign out =   {in[17], in[26], in[13], in[12], in[4], 
                    in[21], in[5],  in[16], in[32], 
                    in[18], in[10], in[7],  in[28], 
                    in[15], in[2],  in[23], in[31], 
                    in[25], in[9],  in[19], in[1], 
                    in[6],  in[30], in[24], in[14], 
                    in[20], in[3],  in[27], in[11], 
                    in[22], in[29], in[8]};

endmodule
