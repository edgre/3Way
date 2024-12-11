module pi_1(
  input  logic [95:0] x,
  output logic [95:0] y
);

always @(x) begin
y[95:64]=(x[95:64]>>10)^(x[95:64]<<22);
y[31:0]=(x[31:0]<<1)^(x[31:0]>>31);
end

endmodule
