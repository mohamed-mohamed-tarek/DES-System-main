/*

 Module Name : rotate_left
 
 Functionality:
 The rotate_left is used In the Key generation where Some Levels
 Require Rotation by 2 bits and others require Single Bit Rotation 
 
 */

module rotate_left (input   wire [5:1]      current_level  ,
                    input   wire [28:1]     i_data         ,
                    output  wire [28:1]     o_data         );
    
    assign o_data = (current_level == 1 || current_level == 2 || current_level == 9 || current_level == 16)? {i_data [27:1], i_data [28]} : {i_data [26:1], i_data [28:27]};
    
endmodule
