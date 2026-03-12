`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/13/2026 12:57:20 AM
// Design Name: 
// Module Name: Instr_fifo
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
module instruction_fifo #(
parameter DATA_WIDTH = 32,
parameter DEPTH = 16
)(
input clk,
input rst_n,
input write_en,
input read_en,
input [DATA_WIDTH-1:0] data_in,
output reg  [DATA_WIDTH-1:0] data_out,
output full,
output empty
);

function integer clog2;
input integer value;
begin
value = value - 1;
for (clog2 = 0; value > 0; clog2 = clog2 + 1)
value = value >> 1;
end
endfunction

localparam ADDR_WIDTH = clog2(DEPTH);
reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];
reg [ADDR_WIDTH-1:0] wr_ptr;
reg [ADDR_WIDTH-1:0] rd_ptr;
reg [ADDR_WIDTH:0] count;

assign full  = (count == DEPTH);
assign empty = (count == 0);

always @(posedge clk or negedge rst_n) begin
if (!rst_n) begin
wr_ptr <= 0;
rd_ptr <= 0;
count <= 0;
data_out <= 0;
end 
else begin

if (write_en && !full) begin
mem[wr_ptr] <= data_in;
if (wr_ptr == DEPTH-1)
wr_ptr <= 0;
else
wr_ptr <= wr_ptr + 1;
end

if (read_en && !empty) begin
data_out <= mem[rd_ptr];
if (rd_ptr == DEPTH-1)
rd_ptr <= 0;
else
rd_ptr <= rd_ptr + 1;
end

if (write_en && !read_en && !full)
count <= count + 1;
else if (read_en && !write_en && !empty)
count <= count - 1;

end
end
endmodule 