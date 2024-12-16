//Copyright (C)2014-2024 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//Tool Version: V1.9.9.03  Education
//Created Time: 2024-12-11 10:15:13
create_clock -name clk -period 37.037 -waveform {0 18.518} [get_ports {clk}]
set_false_path -from [get_ports {rst_n}] 
set_false_path -from [get_regs {my_synchronizer_instance/pipeline_0_s0 my_synchronizer_instance/pipeline_1_s0}] 
