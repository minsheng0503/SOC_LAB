`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/02 23:13:25
// Design Name: 
// Module Name: LineBuffer
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


module LineBuffer(
    input clk, rstn, enable,
    input [7:0] pixel_in,
    output [7:0] sharpen_out
    );
    
    reg [7:0] line0 [639:0];
    reg [7:0] line1 [639:0];
    reg [7:0] line2 [639:0];
    
    integer i;
    always@(posedge clk) begin
        if(!rstn) begin
            for(i = 0; i <= 639; i = i + 1) begin
                line0[i] <= 0;
                line1[i] <= 0;
                line2[i] <= 0;
            end
        end
        else begin
            if(enable) begin
                line0[0] <= pixel_in;
                line1[0] <= line0[639];
                line2[0] <= line1[639];
                for(i = 0; i < 639; i = i + 1) begin
                    line0[i+1] <= line0[i];
                    line1[i+1] <= line1[i];
                    line2[i+1] <= line2[i];
                end
            end
        end
    end
    
    Sharpen_core sharpen_op(.p0(line2[2]), .p1(line2[1]), .p2(line2[0]), .p3(line1[2]), .p4(line1[1]), .p5(line1[0]), .p6(line0[2]), .p7(line0[1]), .p8(line0[0]), .out(sharpen_out));
    
endmodule
