SRC_PATH=../../rtl

all: synth sim

# Design and testbench synthesis
synth:
	mkdir -p work
	iverilog -g2012 -o work/tb_3Way_pipeline $(SRC_PATH)/3Way_pipeline.sv $(SRC_PATH)/round.sv  $(SRC_PATH)/nonlinear.sv $(SRC_PATH)/linear.sv $(SRC_PATH)/pi1.sv $(SRC_PATH)/pi2.sv tb_3Way_pipeline.sv

# Launch simulation
sim:
	./work/tb_3Way_pipeline

# Open waveform
wave:
	gtkwave work/wave.ocd \
		--rcvar 'fontname_signals Monospace 20' \
        --rcvar 'fontname_waves Monospace 20' \
        --rcvar 'scale_to_time_dimension n'

# Delete all artifacts
clean:
	rm -rf work
