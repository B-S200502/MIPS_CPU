vsim work.regfile_wrapper
add wave -r /*

-- Clock generation (10 time unit period, 50% duty cycle)
force clk 0 0, 1 5 -repeat 10

-- Phase 1: Apply and release reset
force reset 1
run 2
force reset 0
run 2

-- Phase 2: Write operations (write enable active)
force write 1

-- Write 0b1010 to register 0
force din_in 4'b1010
force write_address_in 2'b00
run 2

-- Write 0b1100 to register 1
force din_in 4'b1100
force write_address_in 2'b01
run 2

-- Disable writing
force write 0
run 2

-- Phase 3: Read from registers 0 and 1
force read_a_in 2'b00
force read_b_in 2'b01
run 2

-- Read from registers 2 and 3 (expected zeros)
force read_a_in 2'b10
force read_b_in 2'b11
run 2

-- Phase 4: Reset again to clear registers
force reset 1
run 2
force reset 0
run 2

-- Read again after reset (should be zeros)
force read_a_in 2'b00
force read_b_in 2'b01
run 2
