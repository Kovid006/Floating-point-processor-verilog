`timescale 1ns / 1ps

module reg_file (
input clk,
input we,
input [4:0] raddr1,
input [4:0] raddr2,
input [4:0] waddr,
input [31:0] wdata,
output [31:0] rdata1,
output [31:0] rdata2
);

reg [31:0] regs [0:31];
integer i;

assign rdata1 = regs[raddr1];
assign rdata2 = regs[raddr2];

always @(posedge clk) begin
if (we)
regs[waddr] <= wdata;
end

initial begin
for(i=0; i<32; i=i+1)
regs[i] = 32'b0;

regs[1] = 32'h40A00000;
regs[2] = 32'h3F800000;
regs[3] = 32'h40400000;
regs[4] = 32'h40000000;
end

endmodule
