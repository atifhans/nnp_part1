all: sim synth

ssim:
	vlib work
	vlog +acc part2_mac.sv
	vlog +acc part2_tb_simple.sv
	vsim simple_tb_part2_mac -c -do "run -all"

sim:
	vlib work
	vlog +acc part2_mac.sv
	vlog +acc part2_tb.sv
	vsim tb_part2_mac -c -do "run -all"

synth:
	dc_shell -f runsynth.tcl | tee output.txt

clean:
	rm -rf *.log *.txt *.svf *.wlf transcript output.tcl gates.v work work_synth
