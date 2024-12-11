

module tb_three_way_pipeline;
    logic rst = 1;
    logic clk = 0;
    logic [95:0]key;
    logic [95:0]s_axis_tdata;
    logic [95:0]m_axis_tdata;
    logic s_axis_tvalid;
    logic s_axis_tready;
    logic m_axis_tvalid;
    logic m_axis_tready;
   

  // Мониторинг сигналов
  initial begin
    $dumpfile("work/wave.ocd");
    $dumpvars(0, tb_three_way_pipeline);
  end

  // Процедура начальной настройки
  initial begin
    key = 96'h0123456789ABCDEF11112222;
    s_axis_tdata = 96'hFEDCBA9876543210BBBBAAAA;
    s_axis_tvalid = 1;
    m_axis_tready = 1;
    
    #10 rst = 0;
    #10 s_axis_tvalid = 0;

    // Завершение симуляции
    #200;
    
    $finish;
  end

always #5 clk = ~clk;
   
  
  three_way_pipeline uut (
    .rst(rst),
    .clk(clk),
    .key(key),
    .s_axis_tdata(s_axis_tdata),
    .s_axis_tvalid(s_axis_tvalid),
    .s_axis_tready(s_axis_tready),
    .m_axis_tdata(m_axis_tdata),
    .m_axis_tvalid(m_axis_tvalid),
    .m_axis_tready(m_axis_tready)
  );

endmodule
