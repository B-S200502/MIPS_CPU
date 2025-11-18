add wave -radix unsigned sim:/i_cache/address
add wave -radix hexadecimal sim:/i_cache/instruction

force clk_cpu 0
force reset_cpu 0

run 2
force clk_cpu 1
run 2
force clk_cpu 0
run 2


# GROUP 1 : Basic ADDI / ADD
force address 00000
run 2
force clk_cpu 1
run 2
force clk_cpu 0
run 2

force address 00001
run 2
force clk_cpu 1
run 2
force clk_CPU 0
run 2

force address 00010
run 2
force clk_cpu 1
run 2
force clk_cpu 0
run 2

force address 00011
run 2
force clk_cpu 1
run 2
force clk_cpu 0
run 2

force address 00100
run 2
force clk_cpu 1
run 2
force clk_cpu 0
run 2


# GROUP 2 : BEQ
# force address 00101
# run 2
# force clk_cpu 1
# run 2
# force clk_cpu 0
# run 2


# GROUP 3 : JUMP
# force address 00110
# run 2
# force clk_cpu 1
# run 2
# force clk_cpu 0
# run 2


# GROUP 4 : LOAD / STORE
# force address 00111
# run 2
# force clk_cpu 1
# run 2
# force clk_cpu 0
# run 2

# force address 01000
# run 2
# force clk_cpu 1
# run 2
# force clk_cpu 0
# run 2


# GROUP 5 : LOGICAL (ANDI / ORI / XORI)
# force address 01001
# run 2
# force clk_cpu 1
# run 2
# force clk_cpu 0
# run 2

# force address 01010
# run 2
# force clk_cpu 1
# run 2
# force clk_cpu 0
# run 2

# force address 01011
# run 2
# force clk_cpu 1
# run 2
# force clk_cpu 0
# run 2

# force address 01100
# run 2
# force clk_cpu 1
# run 2
# force clk_cpu 0
# run 2

run 5
