`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/10 20:43:04
// Design Name: 
// Module Name: gameover_compositor
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


module gameover_compositor(
    input wire [15:0] i_x,
    input wire [15:0] i_y,
    input wire i_v_sync,
    input wire [2:0] i_state,
    output wire [7:0] o_red,
    output wire [7:0] o_green,
    output wire [7:0] o_blue,
    output wire o_sprite_hit

    );
    reg [15:0] sprite_x     = 16'd304;
    reg [15:0] sprite_y     = 16'd320; 
    
    wire sprite_hit_x, sprite_hit_y;
    wire [5:0] sprite_render_x;
    wire [5:0] sprite_render_y;
    
    parameter S0 = 3'd0;
    parameter S1 = 3'd1;
    parameter S2 = 3'd2;
    parameter S3 = 3'd3;
    
    localparam [0:1][2:0][7:0] palette_colors =  {
        8'h00, 8'h00, 8'h00,
        8'hFF, 8'hFF, 8'hFF
    };
    
    localparam [0:4][0:41][1:0] sprite_data = {
        2'd0, 2'd1,2'd1, 2'd1,  2'd0,   2'd0,2'd1, 2'd1, 2'd0,  2'd0,    2'd1, 2'd0,2'd0, 2'd0,2'd1,    2'd0,   2'd1, 2'd1,2'd1, 2'd1,  2'd0, 2'd0,2'd0, 2'd0,  2'd0, 2'd1,2'd1, 2'd0,  2'd0,   2'd1,2'd0, 2'd1,    2'd0,   2'd1,2'd1, 2'd1,2'd1,   2'd0,   2'd1, 2'd1, 2'd1, 2'd0, 
        2'd1, 2'd0,2'd0, 2'd0,  2'd0,   2'd1,2'd0, 2'd0, 2'd1,  2'd0,    2'd1, 2'd1,2'd0, 2'd1,2'd1,    2'd0,   2'd1, 2'd0,2'd0, 2'd0,  2'd0, 2'd0,2'd0, 2'd0,  2'd1, 2'd0,2'd0, 2'd1,  2'd0,   2'd1,2'd0, 2'd1,    2'd0,   2'd1,2'd0, 2'd0,2'd0,   2'd0,   2'd1, 2'd0, 2'd0, 2'd1, 
        2'd1, 2'd0,2'd1, 2'd1,  2'd0,   2'd1,2'd1, 2'd1, 2'd1,  2'd0,    2'd1, 2'd0,2'd1, 2'd0,2'd1,    2'd0,   2'd1, 2'd1,2'd1, 2'd1,  2'd0, 2'd0,2'd0, 2'd0,  2'd1, 2'd0,2'd0, 2'd1,  2'd0,   2'd1,2'd0, 2'd1,    2'd0,   2'd1,2'd1, 2'd1,2'd0,   2'd0,   2'd1, 2'd1, 2'd1, 2'd0,
        2'd1, 2'd0,2'd0, 2'd1,  2'd0,   2'd1,2'd0, 2'd0, 2'd1,  2'd0,    2'd1, 2'd0,2'd0, 2'd0,2'd1,    2'd0,   2'd1, 2'd0,2'd0, 2'd0,  2'd0, 2'd0,2'd0, 2'd0,  2'd1, 2'd0,2'd0, 2'd1,  2'd0,   2'd1,2'd0, 2'd1,    2'd0,   2'd1,2'd0, 2'd0,2'd0,   2'd0,   2'd1, 2'd0, 2'd1, 2'd0, 
        2'd0, 2'd1,2'd1, 2'd1,  2'd0,   2'd1,2'd0, 2'd0, 2'd1,  2'd0,    2'd1, 2'd0,2'd0, 2'd0,2'd1,    2'd0,   2'd1, 2'd1,2'd1, 2'd1,  2'd0, 2'd0,2'd0, 2'd0,  2'd0, 2'd1,2'd1, 2'd0,  2'd0,   2'd0,2'd1, 2'd0,    2'd0,   2'd1,2'd1, 2'd1,2'd1,   2'd0,   2'd1, 2'd0, 2'd0, 2'd1
    };
    
    assign sprite_hit_x = (i_x >= sprite_x) && (i_x < sprite_x + 42 * 16);
    assign sprite_hit_y = (i_y >= sprite_y) && (i_y < sprite_y + 5 * 16);
    assign sprite_render_x = (i_x - sprite_x)>>4;
    assign sprite_render_y = (i_y - sprite_y)>>4;
    
    wire [1:0] selected_palette;

    assign selected_palette = sprite_data[sprite_render_y][sprite_render_x];
                                                                             
    assign o_red    = (sprite_hit_x && sprite_hit_y) ? palette_colors[selected_palette][2] : 8'hXX;
    assign o_green  = (sprite_hit_x && sprite_hit_y) ? palette_colors[selected_palette][1] : 8'hXX;
    assign o_blue   = (sprite_hit_x && sprite_hit_y) ? palette_colors[selected_palette][0] : 8'hXX;
    assign o_sprite_hit = (i_state==S3) && (sprite_hit_y & sprite_hit_x) && (selected_palette != 2'd0);
    
endmodule
