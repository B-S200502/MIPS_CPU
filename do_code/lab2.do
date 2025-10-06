vsim work.regfile_wrapper
add wave -r /*
force clk 0 0, 1 5 -repeat 10
force reset 1
run 2
force reset 0
run 2
force write 1
force din_in 4'b1010
force write_address_in 2'b00
run 2
force din_in 4'b1100
force write_address_in 2'b01
run 2
force write 0
run 2
force read_a_in 2'b00
force read_b_in 2'b01
run 2
force read_a_in 2'b10
force read_b_in 2'b11
run 2
force reset 1
run 2
force reset 0
run 2
force read_a_in 2'b00
force read_b_in 2'b01
run 2
