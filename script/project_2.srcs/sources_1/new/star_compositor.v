`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/08 16:34:11
// Design Name: 
// Module Name: star_compositor
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


module star_compositor(
    input wire [15:0] i_x,
    input wire [15:0] i_y,
    input wire i_v_sync,
    input wire [2:0] i_state,
    input wire [15:0] i_ball_position_x,
    input wire [15:0] i_ball_position_y,
    output wire [7:0] o_red,
    output wire [7:0] o_green,
    output wire [7:0] o_blue,
    output wire o_sprite_hit
    );
    
    reg [15:0] sprite_x = 16'b00;
    reg [15:0] sprite_y = 16'b00;
    
    wire sprite_hit_x, sprite_hit_y;
    reg hit;
    wire [3:0] sprite_render_x;
    wire [3:0] sprite_render_y;
    
    parameter S0 = 3'd0;
    parameter S1 = 3'd1;
    parameter S2 = 3'd2;
    parameter S3 = 3'd3;
    
    localparam [0:1][2:0][7:0] palette_colors =  {
        8'h00, 8'h00, 8'h00,
        8'hFF, 8'h42, 8'h4C
    }; 
    
    localparam [0:15][0:15][1:0] sprite_data = {
    2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,
    2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,
    2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,
    2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,
    2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,
    2'd0,2'd0,2'd1,2'd0,2'd0,2'd1,2'd0,2'd1,2'd0,2'd1,2'd1,2'd1,2'd0,2'd1,2'd0,2'd0,
    2'd0,2'd0,2'd1,2'd0,2'd0,2'd1,2'd0,2'd1,2'd0,2'd0,2'd1,2'd0,2'd0,2'd1,2'd0,2'd0,
    2'd0,2'd0,2'd1,2'd1,2'd1,2'd1,2'd0,2'd1,2'd0,2'd0,2'd1,2'd0,2'd0,2'd1,2'd0,2'd0,
    2'd0,2'd0,2'd1,2'd0,2'd0,2'd1,2'd0,2'd1,2'd0,2'd0,2'd1,2'd0,2'd0,2'd0,2'd0,2'd0,
    2'd0,2'd0,2'd1,2'd0,2'd0,2'd1,2'd0,2'd1,2'd0,2'd0,2'd1,2'd0,2'd0,2'd1,2'd0,2'd0,
    2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,
    2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,
    2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,
    2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,
    2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,
    2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0
    };
    
        
    reg [31:0] cnt;
    
    always @(posedge i_v_sync) begin
        cnt <= cnt +1 ;
        if (i_state == S2) begin
            hit <= 1'b1;
            sprite_x <= i_ball_position_x;
            sprite_y <= i_ball_position_y;
            cnt <= 0;
        end
        
        if (cnt > 15) begin
            hit <= 1'b0;
        end
    end
    
    
    assign sprite_hit_x = (i_x >= sprite_x) && (i_x < sprite_x + 16 * 4);
    assign sprite_hit_y = (i_y >= sprite_y) && (i_y < sprite_y + 16 * 4);
    assign sprite_render_x = (i_x - sprite_x)>>2; 
    assign sprite_render_y = (i_y - sprite_y)>>2; 
    
    wire [1:0] selected_palette;

    assign selected_palette = sprite_data[sprite_render_y][sprite_render_x];
    
    assign o_red    = (sprite_hit_x && sprite_hit_y) ? palette_colors[selected_palette][2] : 8'hXX; 
    assign o_green  = (sprite_hit_x && sprite_hit_y) ? palette_colors[selected_palette][1] : 8'hXX;
    assign o_blue   = (sprite_hit_x && sprite_hit_y) ? palette_colors[selected_palette][0] : 8'hXX;

    assign o_sprite_hit = (hit) && (sprite_hit_y & sprite_hit_x) && (selected_palette != 2'd0); 
    
endmodule
