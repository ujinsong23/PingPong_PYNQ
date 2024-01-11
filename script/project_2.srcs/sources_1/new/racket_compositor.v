`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/03 17:07:56
// Design Name: 
// Module Name: racket_compositor
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


module racket_compositor(
    input wire [15:0] i_x,
    input wire [15:0] i_y,
    input wire i_v_sync,
    input wire i_v_down,
    input wire i_v_up,
    output wire [7:0] o_red,
    output wire [7:0] o_green,
    output wire [7:0] o_blue,
    output wire o_sprite_hit,
    output reg [15:0] o_racket_position

    );
    
    reg [15:0] sprite_x     = 16'd00;
    reg [15:0] sprite_y     = 16'd28; 
    wire sprite_hit_x, sprite_hit_y;
    wire [3:0] sprite_render_x;
    wire [5:0] sprite_render_y;
    

    localparam [0:1][2:0][7:0] palette_colors =  {
        8'hFF, 8'hFF, 8'hFF,
        8'h00, 8'h00, 8'h00
    };
   

    localparam [0:50][0:6][3:0] sprite_data = {
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    
    4'd0,4'd1,4'd0,4'd0,4'd1,4'd0,4'd0,
    4'd0,4'd1,4'd1,4'd0,4'd0,4'd1,4'd0,
    4'd0,4'd1,4'd0,4'd1,4'd0,4'd1,4'd0,
    4'd0,4'd1,4'd0,4'd0,4'd1,4'd0,4'd0, //2 
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    
    4'd0,4'd0,4'd1,4'd1,4'd1,4'd0,4'd0,
    4'd0,4'd1,4'd0,4'd0,4'd0,4'd1,4'd0,
    4'd0,4'd1,4'd0,4'd0,4'd0,4'd1,4'd0,
    4'd0,4'd0,4'd1,4'd1,4'd1,4'd0,4'd0, //0
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    
    4'd0,4'd1,4'd0,4'd0,4'd1,4'd0,4'd0,
    4'd0,4'd1,4'd1,4'd1,4'd1,4'd1,4'd0,
    4'd0,4'd1,4'd0,4'd0,4'd0,4'd0,4'd0, //1
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    
    4'd0,4'd0,4'd0,4'd0,4'd1,4'd0,4'd0,
    4'd0,4'd1,4'd0,4'd1,4'd0,4'd1,4'd0,
    4'd0,4'd1,4'd0,4'd1,4'd0,4'd1,4'd0,
    4'd0,4'd0,4'd1,4'd1,4'd1,4'd0,4'd0,//9
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    
    4'd0,4'd1,4'd0,4'd0,4'd1,4'd0,4'd0,
    4'd0,4'd1,4'd1,4'd1,4'd1,4'd1,4'd0,
    4'd0,4'd1,4'd0,4'd0,4'd0,4'd0,4'd0, //1
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    
    4'd0,4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd1,4'd0,4'd1,4'd0,
    4'd0,4'd1,4'd1,4'd1,4'd1,4'd1,4'd0,
    4'd0,4'd0,4'd0,4'd1,4'd0,4'd0,4'd0,//4
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    
    4'd0,4'd1,4'd0,4'd0,4'd1,4'd0,4'd0,
    4'd0,4'd1,4'd1,4'd0,4'd0,4'd1,4'd0,
    4'd0,4'd1,4'd0,4'd1,4'd0,4'd1,4'd0,
    4'd0,4'd1,4'd0,4'd0,4'd1,4'd0,4'd0, //2
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    
    4'd0,4'd0,4'd1,4'd1,4'd1,4'd0,4'd0,
    4'd0,4'd1,4'd0,4'd0,4'd0,4'd1,4'd0,
    4'd0,4'd1,4'd0,4'd0,4'd0,4'd1,4'd0,
    4'd0,4'd0,4'd1,4'd1,4'd1,4'd0,4'd0, //0
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    
    4'd0,4'd0,4'd1,4'd1,4'd1,4'd0,4'd0,
    4'd0,4'd1,4'd0,4'd0,4'd0,4'd1,4'd0,
    4'd0,4'd1,4'd0,4'd0,4'd0,4'd1,4'd0,
    4'd0,4'd0,4'd1,4'd1,4'd1,4'd0,4'd0, //0
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    
    4'd0,4'd1,4'd0,4'd0,4'd1,4'd0,4'd0,
    4'd0,4'd1,4'd1,4'd0,4'd0,4'd1,4'd0,
    4'd0,4'd1,4'd0,4'd1,4'd0,4'd1,4'd0,
    4'd0,4'd1,4'd0,4'd0,4'd1,4'd0,4'd0, //2
    
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0
    };

    assign sprite_hit_x = (i_x >= sprite_x) && (i_x < sprite_x + 7*4);
    assign sprite_hit_y = (i_y >= sprite_y) && (i_y < sprite_y + 51*4);
    assign sprite_render_x = (i_x - sprite_x)>>2;
    assign sprite_render_y = (i_y - sprite_y)>>2;
    
    
    wire [1:0] selected_palette;

    assign selected_palette = sprite_data[sprite_render_y][sprite_render_x];
                                                              
    assign o_red    = (sprite_hit_x && sprite_hit_y) ? palette_colors[selected_palette][2] : 8'hXX;
    assign o_green  = (sprite_hit_x && sprite_hit_y) ? palette_colors[selected_palette][1] : 8'hXX;
    assign o_blue   = (sprite_hit_x && sprite_hit_y) ? palette_colors[selected_palette][0] : 8'hXX;
    assign o_sprite_hit = (sprite_hit_y & sprite_hit_x);
    
    
    localparam racket_v = 3'd4;
    always @(posedge i_v_sync) begin
        if (i_v_down || i_v_up) begin
            if (sprite_y >= 720-51*4-30) begin
                sprite_y <= sprite_y - racket_v * i_v_up;
            end
            else if (sprite_y <=30) begin
                sprite_y <= sprite_y + racket_v * i_v_down;
            end
            else begin
                sprite_y <= sprite_y + racket_v * (i_v_down - i_v_up);
            end
        end
        o_racket_position <= sprite_y;
    end
    

    
endmodule
