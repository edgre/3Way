/*module synchronizer #(
  parameter STAGES = 2
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
assign q = pipeline[STAGES-1];
endmodule*/

module top (
input logic rst_n,
input logic clk = 0,
input logic rxd,
output logic txd);

logic new_rst;
logic new_clk;
logic [95:0] key = 96'h0123456789ABCDEF11112222;

logic s_cipher_tvalid;
logic s_cipher_tready;
logic [95:0] s_cipher_tdata;

logic m_cipher_tvalid;
logic m_cipher_tready;
logic [95:0] m_cipher_tdata;

logic s_uart_tvalid;
logic s_uart_tready;
logic [7:0] s_uart_tdata;

logic m_uart_tvalid;
logic m_uart_tready;
logic [7:0] m_uart_tdata;

parameter STAGES=2;


synchronizer #(
  .STAGES(STAGES)
) my_synchronizer_instance (
  .clk(clk),

  .d(rst_n),
  .q(new_rst)
);


Gowin_rPLL PLL_inst(
        .clkout(clk), //output clkout
        .reset(new_reset), //input reset
        .clkin(new_clk) //input clkin
    );
    
 uart uart_pll(
 .clk(new_clk),
 .rst(new_rst),
 .rxd(rxd),
 .s_axis_tdata(s_uart_tdata),
 .s_axis_tvalid(s_uart_tvalid),
 .s_axis_tready(s_uart_tready),
 .m_axis_tdata(m_uart_tdata),
 .m_axis_tvalid(m_uart_tvalid),
 .m_axis_tready(m_uart_tready),
 .prescale(100_000_000 / (115200 * 8))
 );
 
 three_way_pipeline cipher_pll(
 .rst(new_rst),
 .clk(new_clk),
 .key(key),
 .s_axis_tdata(s_cipher_tdata),
 .s_axis_tvalid(s_cipher_tvalid),
 .s_axis_tready(s_cipher_tready),
 .m_axis_tdata(m_cipher_tdata),
 .m_axis_tvalid(m_cipher_tvalid),
 .m_axis_tready(m_cipher_tready)
 );
 
 axis_fifo fifo_in_cipher(
 .rst(new_rst),
 .clk(new_clk),
 .s_axis_tdata(m_uart_tdata),
 .s_axis_tvalid(m_uart_tvalid),
 .s_axis_tready(m_uart_tready),
 .m_axis_tdata(s_cipher_tdata),
 .m_axis_tvalid(s_cipher_tvalid),
 .m_axis_tready(s_cipher_tready)
 );
 
 axis_fifo fifo_from_cipher(
 .rst(new_rst),
 .clk(new_clk),
 .s_axis_tdata(m_cipher_tdata),
 .s_axis_tvalid(m_cipher_tvalid),
 .s_axis_tready(m_cipher_tready),
 .s_axis_tkeep(96'hFFFFFFFFFFFFFFFFFFFFFFFF),
 .m_axis_tdata(s_uart_tdata),
 .m_axis_tvalid(s_uart_tvalid),
 .m_axis_tready(s_uart_tready)
 );
 

endmodule








