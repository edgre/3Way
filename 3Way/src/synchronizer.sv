 module synchronizer #
 (parameter STAGES = 2
)(
  input clk,

  input   d,
  output  q
);

logic pipeline [STAGES];

generate
  for (genvar i = 0; i < STAGES; i++) begin

    always @(posedge clk) begin
      pipeline[i] <= (i == 0) ? d : pipeline[i-1];
    end

  end
endgenerate
assign q = ~pipeline[STAGES-1];
endmodule
