all: sim synth

sim:
	vlib work
	vlog /usr/local/synopsys/syn/dw/sim_ver/DW02_mult*.v
	vlog +acc part3_mac.sv
	vlog +acc part3_tb.sv
	vsim tb_part3_mac -c -do "run -all"

synth:
	dc_shell -f runsynth.tcl | tee output.txt

clean:
	rm -rf *.log *.txt *.svf *.wlf transcript output.txt gates.v work work_synth
