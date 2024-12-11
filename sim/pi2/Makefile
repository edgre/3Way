DESIGN_NAME=pi2
SRC_PATH=../../rtl
C_PROGRAM_PATH=/home/kali/apka/3Way/Way.c  # Путь к программе на C
C_OUTPUT_FILE=/home/kali/apka/3Way/sim/pi2/c_output.txt  # Файл для сохранения результата

all: synth run_c_program sim

# Design and testbench synthesis

# Запуск программы на C
run_c_program:
	# Компиляция программы на C
	gcc -o Way $(C_PROGRAM_PATH)
	# Запуск программы на C
	./Way pi_2
	# Проверка на ошибки выполнения
	if [ $$? -ne 0 ]; then \
		echo "Ошибка выполнения программы на C"; \
		exit 1; \
	fi

synth:
	mkdir -p work
	iverilog -g2012 -o work/tb_$(DESIGN_NAME) $(SRC_PATH)/$(DESIGN_NAME).sv tb_$(DESIGN_NAME).sv

# Launch simulation
sim:
	./work/tb_$(DESIGN_NAME)

# Open waveform
wave:
	gtkwave work/wave.ocd \
		--rcvar 'fontname_signals Monospace 20' \
        --rcvar 'fontname_waves Monospace 20' \
        --rcvar 'scale_to_time_dimension n'

# Delete all artifacts
clean:
	rm -rf work
	rm -f Way $(C_OUTPUT_FILE)  # Удаляем скомпилированную программу и файл с результатами
