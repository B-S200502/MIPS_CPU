vsim work.regfile_wrapper
add wave -r /*

# 10 ns clock
force clk 0 0ns, 1 5ns -repeat 10ns

# Initialize all inputs so nothing is 'U'
force reset 1
force write 0
force din_in "0000"
force read_a_in "00"
force read_b_in "00"
force write_address_in "00"
run 20ns

# Release reset
force reset 0
run 10ns

# Write 0xA to R0
force write 1
force din_in "1010"          ;# 4-bit value as a quoted binary string
force write_address_in "00"  ;# R0
run 10ns

# Write 0xC to R1
force din_in "1100"
force write_address_in "01"  ;# R1
run 10ns

# Stop writing
force write 0
run 10ns

# Read back R0 and R1 -> expect out_a=1010, out_b=1100
force read_a_in "00"
force read_b_in "01"
run 10ns

# Read unwritten R2 and R3 -> expect zeros
force read_a_in "10"
force read_b_in "11"
run 10ns

# Assert reset and verify everything clears
force reset 1
run 10ns
force reset 0
run 10ns

# After reset, reads should be zero
force read_a_in "00"
force read_b_in "01"
run 10ns
