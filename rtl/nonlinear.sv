module nonlinear(
  input  logic [95:0] iword,
  output logic [95:0] oword
);

always @(iword) begin
   oword[31:0]=iword[31:0]^(iword[63:32]|(~iword[95:64]));
   oword[63:32]=iword[63:32]^(iword[95:64]|(~iword[31:0]));
   oword[95:64]=iword[95:64]^(iword[31:0]|(~iword[63:32]));
end

endmodule
