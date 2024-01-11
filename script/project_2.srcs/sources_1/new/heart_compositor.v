`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/10 23:51:36
// Design Name: 
// Module Name: heart_compositor
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


module heart_compositor(
    input wire [15:0] i_x,
    input wire [15:0] i_y,
    input wire i_v_sync,
    input wire [2:0] i_state,
    input wire [1:0] i_life,
    output wire [7:0] o_red,
    output wire [7:0] o_green,
    output wire [7:0] o_blue,
    output wire o_sprite_hit
    );
    reg [15:0] sprite_x     = 16'd1122;
    reg [15:0] sprite_y     = 16'd35; 
    
    wire sprite_hit_x, sprite_hit_y;
    wire [5:0] sprite_render_x;
    wire [5:0] sprite_render_y;
    
    parameter S0 = 3'd0;
    parameter S1 = 3'd1;
    parameter S2 = 3'd2;
    parameter S3 = 3'd3;
    
    localparam [0:3][2:0][7:0] palette_colors =  {
        8'h00, 8'h00, 8'h00,
        8'h01, 8'h01, 8'h01,
        8'hFF, 8'h00, 8'h00,
        8'hFF, 8'hFF, 8'hFF
    };
    
    localparam [0:15][0:31][3:0] one_heart = {
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,   4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,    
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,   4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,   4'd0,4'd0,4'd0,4'd1,4'd1,4'd1,4'd0,4'd0,4'd0,4'd1,4'd1,4'd1,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,   4'd0,4'd0,4'd1,4'd2,4'd2,4'd2,4'd1,4'd0,4'd1,4'd2,4'd2,4'd2,4'd1,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,   4'd0,4'd1,4'd2,4'd3,4'd3,4'd2,4'd2,4'd1,4'd2,4'd2,4'd2,4'd2,4'd2,4'd1,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,   4'd0,4'd1,4'd2,4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd1,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,   4'd0,4'd1,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd1,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,   4'd0,4'd1,4'd2,4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd1,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,   4'd0,4'd0,4'd1,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd1,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,   4'd0,4'd0,4'd0,4'd1,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd1,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,   4'd0,4'd0,4'd0,4'd0,4'd1,4'd2,4'd2,4'd2,4'd2,4'd2,4'd1,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,   4'd0,4'd0,4'd0,4'd0,4'd0,4'd1,4'd2,4'd2,4'd2,4'd1,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,   4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd1,4'd2,4'd1,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,   4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd1,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,   4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,   4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0
    };
    
    localparam [0:15][0:31][3:0] two_heart = {
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,    
    
    4'd0,4'd0,4'd0,4'd1,4'd1,4'd1,4'd0,4'd0,4'd0,4'd1,4'd1,4'd1,4'd0,4'd0,4'd0,4'd0,    4'd0,4'd0,4'd0,4'd1,4'd1,4'd1,4'd0,4'd0,4'd0,4'd1,4'd1,4'd1,4'd0,4'd0,4'd0,4'd0,    
    4'd0,4'd0,4'd1,4'd2,4'd2,4'd2,4'd1,4'd0,4'd1,4'd2,4'd2,4'd2,4'd1,4'd0,4'd0,4'd0,    4'd0,4'd0,4'd1,4'd2,4'd2,4'd2,4'd1,4'd0,4'd1,4'd2,4'd2,4'd2,4'd1,4'd0,4'd0,4'd0,    
    4'd0,4'd1,4'd2,4'd3,4'd3,4'd2,4'd2,4'd1,4'd2,4'd2,4'd2,4'd2,4'd2,4'd1,4'd0,4'd0,    4'd0,4'd1,4'd2,4'd3,4'd3,4'd2,4'd2,4'd1,4'd2,4'd2,4'd2,4'd2,4'd2,4'd1,4'd0,4'd0,    
    4'd0,4'd1,4'd2,4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd1,4'd0,4'd0,    4'd0,4'd1,4'd2,4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd1,4'd0,4'd0,    
    4'd0,4'd1,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd1,4'd0,4'd0,    4'd0,4'd1,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd1,4'd0,4'd0,    
    4'd0,4'd1,4'd2,4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd1,4'd0,4'd0,    4'd0,4'd1,4'd2,4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd1,4'd0,4'd0,    
    4'd0,4'd0,4'd1,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd1,4'd0,4'd0,4'd0,    4'd0,4'd0,4'd1,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd1,4'd0,4'd0,4'd0,    
    4'd0,4'd0,4'd0,4'd1,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd1,4'd0,4'd0,4'd0,4'd0,    4'd0,4'd0,4'd0,4'd1,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd1,4'd0,4'd0,4'd0,4'd0,    
    4'd0,4'd0,4'd0,4'd0,4'd1,4'd2,4'd2,4'd2,4'd2,4'd2,4'd1,4'd0,4'd0,4'd0,4'd0,4'd0,    4'd0,4'd0,4'd0,4'd0,4'd1,4'd2,4'd2,4'd2,4'd2,4'd2,4'd1,4'd0,4'd0,4'd0,4'd0,4'd0,    
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd1,4'd2,4'd2,4'd2,4'd1,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,    4'd0,4'd0,4'd0,4'd0,4'd0,4'd1,4'd2,4'd2,4'd2,4'd1,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,    
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd1,4'd2,4'd1,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd1,4'd2,4'd1,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,    
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd1,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd1,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,    
    
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,    
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0 
    };
    
    
    assign sprite_hit_x = (i_x >= sprite_x) && (i_x < sprite_x + 128);
    assign sprite_hit_y = (i_y >= sprite_y) && (i_y < sprite_y + 64);
    assign sprite_render_x = (i_x - sprite_x)>>2;
    assign sprite_render_y = (i_y - sprite_y)>>2;
    
    wire [1:0] selected_palette;

    assign selected_palette = (i_life==2'd2)? two_heart[sprite_render_y][sprite_render_x] : one_heart[sprite_render_y][sprite_render_x];
                                                                             
    assign o_red    = (sprite_hit_x && sprite_hit_y) ? palette_colors[selected_palette][2] : 8'hXX;
    assign o_green  = (sprite_hit_x && sprite_hit_y) ? palette_colors[selected_palette][1] : 8'hXX;
    assign o_blue   = (sprite_hit_x && sprite_hit_y) ? palette_colors[selected_palette][0] : 8'hXX;
    assign o_sprite_hit = i_life && (i_state==S1 || i_state==S2) && (sprite_hit_y & sprite_hit_x) && (selected_palette != 2'd0);
endmodule
