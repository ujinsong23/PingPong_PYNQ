`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/03 17:06:42
// Design Name: 
// Module Name: ball_compositor
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


module ball_compositor(
    input wire [15:0] i_x,
    input wire [15:0] i_y,
    input wire i_v_sync,
    input wire restart,
    input wire [15:0] i_racket_position,
    output wire [7:0] o_red,
    output wire [7:0] o_green,
    output wire [7:0] o_blue,
    output wire o_sprite_hit,
    output reg [2:0] o_state,
    output reg [1:0] o_life,
    output reg [15:0] o_ball_position_x,
    output reg [15:0] o_ball_position_y
    
    );
    
    reg [15:0] sprite_x = 16'd00;
    reg [15:0] sprite_y = 16'd28;  
    reg sprite_x_direction  = 1;
    reg sprite_y_direction  = 1;
    reg [3:0] sprite_x_speed  = 4'd1;
    reg [3:0] sprite_y_speed  = 4'd1;
    
    wire sprite_hit_x, sprite_hit_y;
    wire [3:0] sprite_render_x;
    wire [3:0] sprite_render_y;

    parameter S0 = 3'd0;
    parameter S1 = 3'd1;
    parameter S2 = 3'd2;
    parameter S3 = 3'd3;
    parameter S4 = 3'd4;
    
    localparam [0:1][2:0][7:0] palette_colors =  {
        8'h00, 8'h00, 8'h00,
        8'hFF, 8'hC3, 8'h0B
    }; 
    
    
    localparam [0:15][0:15][1:0] sprite_data = {
    2'd0,2'd0,2'd0,2'd0,2'd0,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd0,2'd0,2'd0,2'd0,2'd0,
    2'd0,2'd0,2'd0,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd0,2'd0,2'd0,
    2'd0,2'd0,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd0,2'd0,
    2'd0,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd0,
    2'd0,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd0,
    2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,
    2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,
    2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,
    2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,
    2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,
    2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,
    2'd0,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd0,
    2'd0,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd0,
    2'd0,2'd0,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd0,2'd0,
    2'd0,2'd0,2'd0,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd0,2'd0,2'd0,
    2'd0,2'd0,2'd0,2'd0,2'd0,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd0,2'd0,2'd0,2'd0,2'd0
    };
    
    assign sprite_hit_x = (i_x >= sprite_x) && (i_x < sprite_x + 32);
    assign sprite_hit_y = (i_y >= sprite_y) && (i_y < sprite_y + 32);
    assign sprite_render_x = (i_x - sprite_x)>>1; 
    assign sprite_render_y = (i_y - sprite_y)>>1; 
    
    wire [1:0] selected_palette;

    assign selected_palette = sprite_data[sprite_render_y][sprite_render_x];
    
    assign o_red    = (sprite_hit_x && sprite_hit_y) ? palette_colors[selected_palette][2] : 8'hXX; //
    assign o_green  = (sprite_hit_x && sprite_hit_y) ? palette_colors[selected_palette][1] : 8'hXX;
    assign o_blue   = (sprite_hit_x && sprite_hit_y) ? palette_colors[selected_palette][0] : 8'hXX;
    assign o_sprite_hit = (sprite_hit_y & sprite_hit_x) && (selected_palette != 2'd0); //

    localparam [0:1][0:8][3:0] random_speed = {
        4'd4, 4'd4, 4'd4, 4'd3, 4'd3, 4'd2, 4'd2, 4'd1,4'd3,
        4'd3, 4'd1, 4'd2, 4'd2, 4'd3, 4'd3, 4'd4, 4'd4,4'd4
    };
    localparam [0:1][0:3] random_direction = {
        1'b1, 1'b1, 1'b0, 1'b0,
        1'b1, 1'b0, 1'b0, 1'b1
    };
    reg [31:0] cnt;
    reg [31:0] seed1;
    reg [31:0] seed2;
    reg [31:0] seed3;
    reg [31:0] seed4;
    reg prev_restart;
    
    always @(posedge i_v_sync) begin
        cnt <= cnt + 1 ;
        seed1 <= sprite_y * cnt;
        seed2 <= sprite_x * cnt;
        seed3 <= sprite_x * sprite_y;
        seed4 <= sprite_x * sprite_y + cnt;
        
        if (o_state==S0 || prev_restart==1 && restart==0) begin
            if  (prev_restart==1 && restart==0) begin
                o_state <= S0;
                o_life <= 2'd2;
            end
            else begin
                sprite_x <= (seed1) % (1280-60-32) + 30;
                sprite_y <= (seed2) % (720-60-32) + 30 ;
                sprite_x_speed <= random_speed[0][seed3 % 9];
                sprite_y_speed <= random_speed[1][seed3 % 9];
                
                sprite_x_direction <= random_direction[0][seed4 % 4]; 
                sprite_y_direction <= random_direction[1][seed4 % 4]; 
                o_state <= S1;
            end
        end
        
        else if (o_state ==S1 || o_state ==S2) begin
            o_state <= S1 ;
            sprite_x <= sprite_x + sprite_x_speed * (sprite_x_direction ? 1 : -1);
            if (sprite_x >= 1280-32-30) begin //bounce
                sprite_x_direction <= 0;
                o_state <= S2 ; 
            end
            else if (sprite_x <= 30) begin
                if (sprite_y >= i_racket_position - 31 && sprite_y < i_racket_position + 51*4) begin //bounce
                    sprite_x_direction <= 1;
                    o_state <= S2;
                end
                else begin //over
                    sprite_x_direction <= 0;
                    o_state <= S4;
                end                
            end
            
            sprite_y <= sprite_y + sprite_y_speed* (sprite_y_direction ? 1 : -1);
            if (sprite_y >= 720-32-30) begin //bounce
                 sprite_y_direction <= 0;
                 o_state <= S2;
            end
            else if (sprite_y <=30) begin //bounce
                sprite_y_direction <= 1 ;
                o_state <= S2;
            end
        
        end
        
        else if (o_state == S4 || o_state ==S3) begin
            if (o_state ==S4 && o_life!=2'd0) begin
                o_state <= S0;
                o_life <= o_life - 1;
            end
            else if (o_life == 2'd0 || o_state==S3 ) begin
                o_state <= S3;
            end
        end
        
        
        prev_restart <= restart;
        o_ball_position_x <= sprite_x;
        o_ball_position_y <= sprite_y;
    end
    
endmodule