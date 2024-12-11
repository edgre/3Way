`timescale 1ns / 1ns

module tb_round;
    parameter ITERATIONS = 100;

    logic [95:0] iword;
    logic [95:0] oword;
    logic [95:0] key;
    logic [95:0] ref_oword;
    integer file, result;

    int length;
    logic current_bit;

    initial begin
        $dumpfile("work/wave.ocd");
        $dumpvars(0, tb_round);
    end

    initial begin
        file = $fopen("/home/kali/pj/3Way/round/sim/c_output.txt", "r"); // Открываем файл для чтения
        if (file == 0) begin
            $display("Ошибка открытия файла!");
            $finish;
        end

        // Чтение значений из файла
        for (integer i = 0; i < 100; i++) begin
            result = $fscanf(file, "%d %d %d %d %d %d %d %d %d\n", iword[31:0], iword[63:32], iword[95:64], ref_oword[31:0], ref_oword[63:32], ref_oword[95:64], key[31:0], key[63:32], key[95:64]);
            #20; // Подождите 10 временных единиц
            $display("%d %d %d %d %d %d %d %d %d\n", iword[31:0], iword[63:32], iword[95:64], oword[31:0], oword[63:32], oword[95:64], key[31:0], key[63:32], key[95:64]);
            // Сравнение с ожидаемым значением
            assert (oword == ref_oword) else
                $error("Неверное значение выходного сигнала для входного значения: \nожидаемое   %b \nфактическое %b", ref_oword, oword);
        end

        $fclose(file); // Закрываем файл
        $finish;
    end

    round dut (
        .idata (iword),
        .key (key),
        .odata (oword)
    );

endmodule
