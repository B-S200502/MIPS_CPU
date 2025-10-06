add wave -r /*

# Initialize inputs to known values
force reset 1
force write 0
force read_a "00000"
force read_b "00000"
force write_address "00000"
force din x"00000000"
# Provide a free-running 10ns clock
force clk 0 0ns, 1 5ns -repeat 10ns
run 20ns

# Release reset
force reset 0
run 20ns

# --- Write 0x00000008 into R1 ---
force write 1
force write_address "00001"
force din x"00000008"
run 10ns   ;# one clock edge will capture since write=1

# --- Write 0x00000005 into R2 ---
force write_address "00010"
force din x"00000005"
run 10ns

# Stop writing
force write 0
run 10ns

# --- Try a write with write=0 (should NOT change anything) ---
force write_address "11011"
force din x"FAFA3B3B"
run 20ns

# --- Enable write and clock once to store FAFA3B3B into R27 (11011) ---
force write 1
run 10ns
force write 0
run 10ns

# --- Read back: out_a=R1, out_b=R2 ---
force read_a "00001"
force read_b "00010"
run 20ns

# --- Read back: out_a=R27, out_b=R8 (R8 is unwritten -> 0) ---
force read_a "11011"
force read_b "01000"
run 20ns

# --- Assert reset and verify clears ---
force reset 1
run 20ns
force reset 0
run 10ns

# After reset, reading R1 and R27 should yield zero
force read_a "00001"
force read_b "11011"
run 20ns
