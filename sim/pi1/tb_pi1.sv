`timescale 1ns / 1ns

module tb_pi1;
    parameter ITERATIONS = 100;

    logic [95:0] iword;
    logic [95:0] oword;
    logic [95:0] ref_oword;
    integer file, result;

    int length;
    logic current_bit;

    initial begin
        $dumpfile("work/wave.ocd");
        $dumpvars(0, tb_pi1);
    end

    initial begin
        file = $fopen("c_output.txt", "r"); // Открываем файл для чтения
        if (file == 0) begin
            $display("Ошибка открытия файла!");
            $finish;
        end

        // Чтение значений из файла
        for (integer i = 0; i < 100; i++) begin
            result = $fscanf(file, "%d %d %d %d %d %d\n", iword[31:0], iword[63:32], iword[95:64], ref_oword[31:0], ref_oword[63:32], ref_oword[95:64]);
            #10; // Подождите 10 временных единиц
            $display("%d %d %d %d %d %d\n", iword[31:0], iword[63:32], iword[95:64], oword[31:0], oword[63:32], oword[95:64]);
            #10
            // Сравнение с ожидаемым значением
            assert (oword == ref_oword) else
                $error("Неверное значение выходного сигнала для входного значения: \nожидаемое   %b \nфактическое %b", ref_oword, oword);
        end

        $fclose(file); // Закрываем файл
        $finish;
    end

    pi1 dut (
        .iword (iword ),
        .oword (oword)
    );

endmodule
