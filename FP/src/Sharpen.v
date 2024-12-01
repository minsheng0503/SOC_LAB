`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/02 23:40:54
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


module Sharpen(
    input clk, rstn,
    
    input [7:0] s_axis_tdata,
    input s_axis_tkeep,
    input s_axis_tlast,
    input s_axis_tvalid,
    output reg s_axis_tready,
    
    output reg [7:0] m_axis_tdata,
    output reg m_axis_tkeep,
    output reg m_axis_tlast,
    output reg m_axis_tvalid,
    input m_axis_tready
    );
    
    parameter IDLE = 0,     //initial state
            RECEIVE = 1,  //receive data
            SEND = 2;     //send data
    
    reg [9:0] cnt_x, cnt_y;
    //state machine
    reg [1:0] state;
    always@(posedge clk) begin
        if(!rstn)
            state <= IDLE;
        else begin
            case(state)
            IDLE: state <= RECEIVE;
            RECEIVE: state <= (cnt_x >=3 || (cnt_x == 2 && cnt_y >= 2)) && s_axis_tvalid && s_axis_tready ? SEND : RECEIVE;
            SEND: begin
                if(m_axis_tlast)
                    state <= m_axis_tvalid && m_axis_tready ? IDLE : SEND;
                else
                    state <= cnt_y == 1 || cnt_y == 2 ? RECEIVE : (m_axis_tvalid && m_axis_tready ? RECEIVE : SEND);
            end
            endcase
        end
    end
    
    //signals
    wire [7:0] sharpen_out;
    always@(posedge clk) begin
        if(!rstn) begin
            s_axis_tready <= 0;
            m_axis_tdata <= 0;
            m_axis_tkeep <= 0;
            m_axis_tlast <= 0;
            m_axis_tvalid <= 0;
            cnt_x <= 0;
            cnt_y <= 0;
        end
        else begin
            case(state)
            IDLE: begin
                s_axis_tready <= 0;
                m_axis_tdata <= 0;
                m_axis_tkeep <= 0;
                m_axis_tlast <= 0;
                m_axis_tvalid <= 0;
                cnt_x <= 0;
                cnt_y <= 0;
            end
            RECEIVE: begin
                if(s_axis_tvalid && s_axis_tready) begin //wait for s_axis_tvalid
                    if(cnt_x >=3 || (cnt_x == 2 && cnt_y >= 2))
                        s_axis_tready <= 0; //only recieve one cycle of data
                    m_axis_tkeep <= s_axis_tkeep;
                    m_axis_tlast <= s_axis_tlast;
                    cnt_y <= cnt_y == 639 ? 0 : cnt_y + 1;
                    cnt_x <= cnt_y == 639 ? cnt_x + 1 : cnt_x;
                end
                else begin
                    s_axis_tready <= 1;
                end
            end
            SEND: begin
                if(m_axis_tvalid && m_axis_tready) begin //wait for m_axis_tready
                    m_axis_tvalid <= 0; //only send one cycle of data
                end
                else begin
                    if(cnt_y != 1 && cnt_y != 2) begin
                        m_axis_tvalid <= 1;
                        m_axis_tdata <= sharpen_out;
                    end
                end
            end
            endcase
        end
    end
    
    wire line_enable;
    assign line_enable = state == RECEIVE && s_axis_tvalid && s_axis_tready;
    LineBuffer line_module(.clk(clk), .rstn(rstn), .enable(line_enable), .pixel_in(s_axis_tdata), .sharpen_out(sharpen_out));
    
endmodule
