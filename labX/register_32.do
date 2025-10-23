# Add signals to the waveform
add wave clk
add wave reset
add wave write
add wave din
add wave write_address
add wave read_a
add wave read_b
add wave out_a
add wave out_b

force clk 0 0, 1 {5 ns} -r 10

#reset
force reset 1
run 20 ns
force reset 0
run 10 ns

#case 1: Write into two registers and read back
#Write to register 1
force write 1
force din x"AAAAAAAA"
force write_address "00001"
run 10 ns

#Write to register 2
force din x"BBBBBBBB"
force write_address "00010"
run 10 ns

force write 0
run 10 ns

#Read back from register 1 (out_a) and register 2 (out_b)
force read_a "00001"
run 5 ns
force read_b "00010"
run 10 ns

#case 2: Read from registers that weren't written to
# Read from register 3
force read_a "00011"
run 5 ns
force read_b "00100"
run 10 ns

#case 3: Reset the registers 
force reset 1
run 20 ns
force reset 0
run 10 ns

#Verify reset by reading registers 1 and 2
force read_a "00001"
run 5 ns
force read_b "00010"
run 10 ns

run -all

