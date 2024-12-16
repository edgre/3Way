`timescale 1ns / 1ns
module tb_three_way_pipeline;
    logic rst = 1;
    logic clk = 0;
    logic [95:0]key;
    logic [95:0]s_axis_tdata;
    logic [95:0]m_axis_tdata;
    logic [95:0] ref_oword;
    logic s_axis_tvalid;
    logic s_axis_tready;
    logic m_axis_tvalid;
    logic m_axis_tready;
    integer file, result;
   

  // Мониторинг сигналов
  initial begin
    $dumpfile("work/wave.ocd");
    $dumpvars(0, tb_three_way_pipeline);
  end
  
  initial begin
    m_axis_tready = 1'b1;
  end     

  // Процедура начальной настройки
  initial begin
    file = $fopen("c_output.txt", "r"); // Открываем файл для чтения
    if (file == 0) begin
         $display("Ошибка открытия файла!");
         $finish;
    end
   
    for (integer i = 0; i < 100; i++) begin
    	  @(posedge clk);
          rst<=1'b1;
    	  @(posedge clk);
          rst<=1'b0;

	  @(posedge clk);
          s_axis_tvalid<=1'b0;

          
          result = $fscanf(file, "%d %d %d %d %d %d %d %d %d\n", s_axis_tdata[31:0], s_axis_tdata[63:32], s_axis_tdata[95:64], ref_oword[31:0], ref_oword[63:32], ref_oword[95:64], key[31:0], key[63:32], key[95:64]);
          
          @(posedge clk);
          s_axis_tvalid<=1'b1;

          // Сравнение с ожидаемым значением
          while (m_axis_tvalid!=1'b1) @(posedge clk);
          
          $display("%d %d %d %d %d %d %d %d %d\n", s_axis_tdata[31:0], s_axis_tdata[63:32], s_axis_tdata[95:64], m_axis_tdata[31:0], m_axis_tdata[63:32], m_axis_tdata[95:64], key[31:0], key[63:32], key[95:64]);
          assert (m_axis_tdata == ref_oword) else
              $error("Неверное значение выходного сигнала для входного значения: \nожидаемое   %b \nфактическое %b", ref_oword, m_axis_tdata);
      end
    // Завершение симуляции
    $fclose(file); 
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
