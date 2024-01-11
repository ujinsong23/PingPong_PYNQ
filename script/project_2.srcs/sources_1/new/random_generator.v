`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/07 17:28:45
// Design Name: 
// Module Name: random_generator
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module random_generator(
    output wire [15:0] rand_x,
    output wire [15:0] rand_y,
    output wire [3:0] randv_x,
    output wire [3:0] randv_y
    );
    
    reg [15:0] a;
    reg [15:0] b;
    reg [3:0] c=3;
    reg [4:0] d=1;
    
    initial a = $urandom_range(1280-30-32, 30);
    initial b = $urandom_range(720-30-32, 30);
    
    assign rand_x = a;
    assign rand_y = b;
    assign randv_x = c;
    assign randv_y = d;
    
endmodule
