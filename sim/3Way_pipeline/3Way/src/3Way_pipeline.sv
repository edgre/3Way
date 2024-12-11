module three_way_pipeline (
  input logic rst,
  input logic clk,
  
  input logic [95:0] key,
  
  input logic [95:0] s_axis_tdata,
  input logic s_axis_tvalid,
  output logic s_axis_tready,
  
  output logic [95:0] m_axis_tdata,
  output logic m_axis_tvalid,
  input logic m_axis_tready
);
  logic [95:0] block [12];
  logic valid [12];
  
  logic [95:0] enc_block [12];
  logic [95:0] round_key [12];
  logic [15:0] round_const[12];
  logic [95:0] fin;
  
  generate
    for (genvar i = 0; i < 12; i++) begin
      case(i)
	0:assign round_const[i] = 16'h0B0B;
	1:assign round_const[i] = 16'h1616;
	2:assign round_const[i] = 16'h2C2C;
	3:assign round_const[i] = 16'h5858;
	4:assign round_const[i] = 16'hB0B0;
	5:assign round_const[i] = 16'h7171;
	6:assign round_const[i] = 16'hE2E2;
	7:assign round_const[i] = 16'hD5D5;
	8:assign round_const[i] = 16'hBBBB;
	9:assign round_const[i] = 16'h6767;
	10:assign round_const[i] = 16'hCECE;
	11:assign round_const[i] = 16'h8D8D;
	
	
      endcase
      
      	assign round_key[i][31:0] = key[31:0] ^ (round_const[i]<<16);
      	assign round_key[i][63:32] = key[63:32];
      	assign round_key[i][95:64] = key[95:64] ^ round_const[i];
      	
      	
      if (i==11) begin
      assign fin = block[i] ^ round_key[i];
      linear linear_inst (
      .iword (fin),
      .oword (enc_block[i])
      );
      end
      
      else begin
      round round_inst (
        .idata (block [i]),
        .key (round_key[i]),
        .odata (enc_block[i])
      );
      end;
      
      always @(posedge clk) begin
        if (rst) begin
          valid[i] <= 1'b0;
          block[i] <= '0;
        end else if (m_axis_tready) begin
          if (i == 0) begin
            valid[i] <= s_axis_tvalid;
            block[i] <= s_axis_tdata;
          end else begin
            valid[i] <= valid[i-1];
            block[i] <= enc_block[i-1];
          end
        end
      end
    end
  endgenerate
  
  
  always @(posedge clk) begin
    if (rst) begin
      m_axis_tdata <= '0;
      m_axis_tvalid <= 1'b0;
    end else if (m_axis_tready&&valid[11]==1) begin
      m_axis_tdata <= enc_block[11];
      m_axis_tvalid <= valid[11];
    end
  end
  
  assign s_axis_tready = m_axis_tready;
  
endmodule


