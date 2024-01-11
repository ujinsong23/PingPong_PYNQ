`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/08 11:53:01
// Design Name: 
// Module Name: testbench
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


module testbench( );
 reg clk;
 reg btn_up;
 reg btn_down;
 reg [15:0] i_x ;
 reg [15:0] i_y ;
 
 wire hit;
 wire [15:0] racket_position = 16'b10;
 wire [23:0] etc;
 
 initial begin
    clk<=0;
    forever #10 clk <= ~clk;
 end
 
 initial begin
    i_x = 16'b0;
    i_y = 16'd28;
    forever #10 i_y <= i_y+1;
    
 end
 
 initial begin
    
    #15 btn_down <=1;
    #10 btn_down<=0;
    
    btn_up <=1;
    #10 btn_up <=0;
    
    #20 btn_down <=1;
    #10 btn_down<=0;
    
    #20 btn_down <=1;
    #10 btn_down<=0;
    
    btn_up <=1;
    #10 btn_up <=0;
    
    #20 btn_down <=1;
    #10 btn_down<=0;
    
 end
 
     racket_compositor racket(
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (clk),
        .i_v_down   (btn_down),
        .i_v_up     (btn_up),
        .o_red      (etc[23:16]),
        .o_green    (etc[15:8]),
        .o_blue     (etc[7:0]),
        .o_sprite_hit   (hit),
        .o_racket_position (racket_position)
    );
 
endmodule
