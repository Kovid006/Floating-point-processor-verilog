`timescale 1ns / 1ps

module fpu_simple (
input clk,
input rst_n,
input [31:0] a,
input [31:0] b,
input [1:0]  op,
output reg [31:0] result
);

reg [31:0] res_comb;

wire sign_a, sign_b;
wire [7:0] exp_a, exp_b;
wire [23:0] mant_a, mant_b;

assign sign_a = a[31];
assign sign_b = b[31];
assign exp_a  = a[30:23];
assign exp_b  = b[30:23];

assign mant_a = {1'b1, a[22:0]};
assign mant_b = {1'b1, b[22:0]};

reg op_sub;
reg res_sign;
reg [7:0] res_exp;
reg [24:0] res_mant;
reg [23:0] ma, mb;
reg [7:0] ea, eb;
reg [7:0] diff;

integer temp_exp;
reg [47:0] prod_mant;
reg [22:0] res_m;
integer i;

always @(*) begin

res_comb = 0;
op_sub = 0; res_sign = 0; res_exp = 0; res_mant = 0;
ma = 0; mb = 0; ea = 0; eb = 0; diff = 0;
temp_exp = 0; prod_mant = 0; res_m = 0;

case (op)

2'b00,2'b01: begin

op_sub = (op == 2'b00) ? (sign_a ^ sign_b) : (sign_a == sign_b);

if ({exp_a,mant_a} < {exp_b,mant_b}) begin
ma = mant_b; ea = exp_b;
res_sign = (op == 2'b01) ? !sign_b : sign_b;
mb = mant_a; eb = exp_a;
end
else begin
ma = mant_a; ea = exp_a;
res_sign = sign_a;
mb = mant_b; eb = exp_b;
end

diff = ea - eb;
mb = mb >> diff;

if (op_sub)
res_mant = ma - mb;
else
res_mant = ma + mb;

res_exp = ea;

if (res_mant[24]) begin
res_mant = res_mant >> 1;
res_exp = res_exp + 1;
end
else begin
for(i=0;i<24;i=i+1) begin
if(!res_mant[23] && res_exp>0) begin
res_mant = res_mant << 1;
res_exp = res_exp - 1;
end
end
end

if(res_mant==0)
res_comb = 0;
else
res_comb = {res_sign,res_exp,res_mant[22:0]};

end

2'b10: begin

res_sign = sign_a ^ sign_b;
temp_exp = exp_a + exp_b - 127;

prod_mant = mant_a * mant_b;

if(prod_mant[47]) begin
temp_exp = temp_exp + 1;
res_m = prod_mant[46:24];
end
else begin
res_m = prod_mant[45:23];
end

if(temp_exp > 254)
res_comb = {res_sign,8'hFF,23'b0};
else if(temp_exp < 1)
res_comb = 0;
else
res_comb = {res_sign,temp_exp[7:0],res_m};

end

default: res_comb = 0;

endcase
end

always @(posedge clk or negedge rst_n) begin
if(!rst_n)
result <= 0;
else
result <= res_comb;
end

endmodule
