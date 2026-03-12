`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/13/2026 01:05:26 AM
// Design Name: 
// Module Name: tb
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
module tb_fpu_system;

reg clk;
reg rst_n;
reg fifo_wr_en;
reg [31:0] instruction_in;

wire fifo_full;
wire [31:0] fpu_result_debug;

fpu_system_top uut (

.clk(clk),
.rst_n(rst_n),
.fifo_wr_en(fifo_wr_en),
.instruction_in(instruction_in),
.fifo_full(fifo_full),
.fpu_result_debug(fpu_result_debug)
);

always #5 clk = ~clk; 
initial begin
clk = 0;
rst_n = 0;
fifo_wr_en = 0;
instruction_in = 0;

#20
rst_n = 1;

#20
fifo_wr_en = 1;
instruction_in = {2'b00,5'd5,5'd1,5'd3,15'd0};
#10
fifo_wr_en = 0;

#40
fifo_wr_en = 1;
instruction_in = {2'b01,5'd6,5'd1,5'd4,15'd0};
#10
fifo_wr_en = 0;

#40
fifo_wr_en = 1;
instruction_in = {2'b10,5'd7,5'd3,5'd4,15'd0};
#10
fifo_wr_en = 0;
#200
$finish;
end
endmodule