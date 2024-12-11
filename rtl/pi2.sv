module pi2(
  input  logic [95:0] iword,
  output logic [95:0] oword
);

always @(iword) begin
oword[31:0]=(iword[31:0]<<1)^(iword[31:0]>>31);
oword[63:32]=iword[63:32];
oword[95:64]=(iword[95:64]>>10)^(iword[95:64]<<22);
end

endmodule
