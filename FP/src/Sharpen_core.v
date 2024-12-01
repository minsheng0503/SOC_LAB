`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/02 21:39:34
// Design Name: 
// Module Name: Sharpen
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


module Sharpen_core(
    input [7:0] p0, p1, p2, p3, p4, p5, p6, p7, p8,
    output [7:0] out
    );
    
    wire signed [11:0] gx_a, gx_b, gx_c;
    assign gx_a = ~((p3 + p5) << 1) + 1;
    assign gx_b = p4 << 3 + p4;
    assign gx_c = ~((p1 + p7) << 1) + 1;
    wire signed [13:0] gx;
    assign gx = gx_a + gx_b + gx_c;
    
    wire [12:0] abs_gx;
    assign abs_gx = gx[13] ? ~gx + 1 : gx;
    
    wire [7:0] max_gx;
    assign max_gx = |abs_gx[12:8] ? 8'hff : abs_gx[7:0];
    
    assign out = max_gx;
    
endmodule
