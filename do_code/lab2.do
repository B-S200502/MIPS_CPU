vsim work.regfile_wrapper
add wave -r /*

# Clock generation: 10ns period
force clk 0 0, 1 5 -repeat 10   

# Step 1: Reset all registers
force reset 1                   
run 2                          
force reset 0                   
run 2

# Step 2: Write values into registers
force write 1                   
force din_in b1010              ;# Write 0xA into R0
force write_address_in b00      
run 2

force din_in b1100              ;# Write 0xC into R1
force write_address_in b01      
run 2

# Step 3: Disable write
force write 0                   
run 2

# Step 4: Read back from registers
force read_a_in b00             ;# Expect out_a = 0xA
force read_b_in b01             ;# Expect out_b = 0xC
run 2

force read_a_in b10             ;# Expect out_a = 0 (R2 unwritten)
force read_b_in b11             ;# Expect out_b = 0 (R3 unwritten)
run 2

# Step 5: Reset again and verify all cleared
force reset 1                   
run 2
force reset 0                   
run 2

force read_a_in b00             ;# Expect out_a = 0 (cleared)
force read_b_in b01             ;# Expect out_b = 0 (cleared)
run 2
