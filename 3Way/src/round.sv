
module round (
  input logic [95:0] idata,
  input logic [95:0] key,
  output logic [95:0] odata
);
  logic [95:0] key_added, theta_substituted, pi1_permuted, gamma_substituted, pi2_permuted;
  
  assign key_added = idata ^ key;
  
 linear linear_inst (
    .iword(key_added),
    .oword(theta_substituted)
  );
  
  pi1 pi1_inst (
    .iword(theta_substituted),
    .oword(pi1_permuted)
  );
  
  nonlinear nonlinear_inst (
    .iword(pi1_permuted),
    .oword(gamma_substituted)
  );
  
  pi2 pi2_inst (
    .iword(gamma_substituted),
    .oword(pi2_permuted)
  );
    
  assign odata = pi2_permuted;
  
endmodule
