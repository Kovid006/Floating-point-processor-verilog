`timescale 1ns / 1ps

module fpu_system_top (

input clk,
input rst_n,
input fifo_wr_en,
input [31:0] instruction_in,
output fifo_full,
output [31:0] fpu_result_debug

);

wire [31:0] fifo_dout;
wire fifo_empty;

reg fifo_rd_en;

wire [31:0] rf_rdata1;
wire [31:0] rf_rdata2;

wire [31:0] fpu_out;

reg rf_we;

wire [1:0] opcode;
wire [4:0] rd;
wire [4:0] rs1;
wire [4:0] rs2;

reg [31:0] instruction_reg;

reg [1:0] state;

localparam

IDLE = 2'b00,
DECODE = 2'b01,
EXECUTE = 2'b10,
WRITEBACK = 2'b11;

instruction_fifo #(.DEPTH(16)) u_fifo (

.clk(clk),
.rst_n(rst_n),
.write_en(fifo_wr_en),
.read_en(fifo_rd_en),
.data_in(instruction_in),
.data_out(fifo_dout),
.full(fifo_full),
.empty(fifo_empty)

);

reg_file u_rf (

.clk(clk),
.we(rf_we),
.raddr1(rs1),
.raddr2(rs2),
.waddr(rd),
.wdata(fpu_out),
.rdata1(rf_rdata1),
.rdata2(rf_rdata2)

);

fpu_simple u_fpu (

.clk(clk),
.rst_n(rst_n),
.a(rf_rdata1),
.b(rf_rdata2),
.op(opcode),
.result(fpu_out)

);

assign fpu_result_debug = fpu_out;

assign opcode = instruction_reg[31:30];
assign rd = instruction_reg[29:25];
assign rs1 = instruction_reg[24:20];
assign rs2 = instruction_reg[19:15];

always @(posedge clk or negedge rst_n) begin

if(!rst_n) begin
state <= IDLE;
fifo_rd_en <= 0;
rf_we <= 0;
instruction_reg <= 0;
end
else begin

fifo_rd_en <= 0;
rf_we <= 0;

case(state)

IDLE:
begin
if(!fifo_empty) begin
fifo_rd_en <= 1;
state <= DECODE;
end
end

DECODE:
begin
instruction_reg <= fifo_dout;
state <= EXECUTE;
end

EXECUTE:
begin
state <= WRITEBACK;
end

WRITEBACK:
begin
rf_we <= 1;
state <= IDLE;
end

default: state <= IDLE;

endcase

end
end

endmodule
