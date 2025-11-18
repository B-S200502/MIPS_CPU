add wave -radix unsigned address
add wave -radix hexadecimal instruction

# Initial run to open the waveform window
run 2

# GROUP 1 : ADDI / ADD
force address 00000
run 2
force address 00001
run 2
force address 00010
run 2
force address 00011
run 2
force address 00100
run 2

# GROUP 2 : BEQ
# force address 00101
# run 2

# GROUP 3 : JUMP
# force address 00110
# run 2

# GROUP 4 : SW / LW
# force address 00111
# run 2
# force address 01000
# run 2

# GROUP 5 : ANDI / ORI / XORI
# force address 01001
# run 2
# force address 01010
# run 2
# force address 01011
# run 2
# force address 01100
# run 2

run 5
