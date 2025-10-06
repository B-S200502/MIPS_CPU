add wave clk
add wave reset
add wave write
add wave write_address
add wave din
add wave read_a
add wave read_b
add wave out_a
add wave out_b
add wave register_array

# reset at the beginning

force reset 1
force clk 0
run 2
force reset 0
force din X"FAFA3B3B"
force write 1
force write_address "00001"
force read_a "00000"
force read_b "00001"
run 2

# Deassert write & reset from Register 1

force clk 1
run 2
force clk 0
run 2

force write_address "11110"
run 2
force read_a "11110"
force read_b "11110"
force clk 1 
run 2
force clk 0
run 2

force write 1
run 2
force clk 1
run 2
force clk 0
run 2

# Write data in Register 1 up until Register 31

# Register R1
force write_address "00001"
force din X"00000001"
force read_a "00000"
force read_b "00001"
force clk 1
run 2
force clk 0
run 2

# Register R2
force write_address "00010"
force din X"00000002"
force read_a "00001"
force read_b "00010"
force clk 1
run 2
force clk 0
run 2

# Register R3
force write_address "00011"
force din X"00000003"
force read_a "00010"
force read_b "00011"
force clk 1
run 2
force clk 0
run 2

# Register R4
force write_address "00100"
force din X"00000004"
force read_a "00011"
force read_b "00100"
force clk 1
run 2
force clk 0 
run 2

# Register R5
force write_address "00101"
force din X"00000005"
force read_a "00100"
force read_b "00101"
force clk 1
run 2
force clk 0 
run 2

# Register R6
force write_address "00110"
force din X"00000006"
force read_a "00101"
force read_b "00110"
force clk 1
run 2
force clk 0
run 2

# Register R7
force write_address "00111"
force din X"00000007"
force read_a "00110"
force read_b "00111"
force clk 1
run 2
force clk 0 
run 2

# Register R8
force write_address "01000"
force din X"00000008"
force read_a "00111"
force read_b "01000"
force clk 1
run 2
force clk 0
run 2

# Register R9
force write_address "01001"
force din X"00000009"
force read_a "01000"
force read_b "01001"
force clk 1
run 2
force clk 0
run 2

# Register R10
force write_address "01010"
force din X"0000000A"
force read_a "01001"
force read_b "01010"
force clk 1
run 2 
force clk 0 
run 2

# Register R11
force write_address "01011"
force din X"0000000B"
force read_a "01010"
force read_b "01011"
force clk 1
run 2
force clk 0
run 2

# Register R12
force write_address "01100"
force din X"0000000C"
force read_a "01011"
force read_b "01100"
force clk 1
run 2
force clk 0
run 2

# Register R13
force write_address "01101"
force din X"0000000D"
force read_a "01100"
force read_b "01101"
force clk 1
run 2
force clk 0
run 2

# Register R14
force write_address "01110"
force din X"0000000E"
force read_a "01101"
force read_b "01110"
force clk 1
run 2
force clk 0
run 2

# Register R15
force write_address "01111"
force din X"0000000F"
force read_a "01110"
force read_b "01111"
force clk 1
run 2
force clk 0 
run 2

# Register R16
force write_address "10000"
force din X"00000010"
force read_a "01111"
force read_b "10000"
force clk 1
run 2
force clk 0
run 2

# Register R17
force write_address "10001"
force din X"00000011"
force read_a "10000"
force read_b "10001"
force clk 1
run 2
force clk 0
run 2

# Register R18
force write_address "10010"
force din X"00000012"
force read_a "10001"
force read_b "10010"
force clk 1
run 2
force clk 0
run 2

# Register R19
force write_address "10011"
force din X"00000013"
force read_a "10010"
force read_b "10011"
force clk 1
run 2
force clk 0
run 2

# Register R20
force write_address "10100"
force din X"00000014"
force read_a "10011"
force read_b "10100"
force clk 1
run 2
force clk 0 
run 2

# Register R21
force write_address "10101"
force din X"00000015"
force read_a "10100"
force read_b "10101"
force clk 1
run 2
force clk 0
run 2

# Register R22
force write_address "10110"
force din X"00000016"
force read_a "10101"
force read_b "10110"
force clk 1
run 2
force clk 0
run 2

# Register R23
force write_address "10111"
force din X"00000017"
force read_a "10110"
force read_b "10111"
force clk 1
run 2
force clk 0 
run 2

# Register R24
force write_address "11000"
force din X"00000018"
force read_a "10111"
force read_b "11000"
force clk 1
run 2
force clk 0
run 2

# Register R25
force write_address "11001"
force din X"00000019"
force read_a "11000"
force read_b "11001"
force clk 1
run 2
force clk 0
run 2

# Register R26
force write_address "11010"
force din X"0000001A"
force read_a "11001"
force read_b "11010"
force clk 1
run 2
force clk 0 
run 2

# Register R27
force write_address "11011"
force din X"0000001B"
force read_a "11010"
force read_b "11011"
force clk 1
run 2
force clk 0
run 2

#Register R28
force write_address "11100"
force din X"0000001C"
force read_a "11011"
force read_b "11100"
force clk 1
run 2
force clk 0
run 2

# Register R29
force write_address "11101"
force din X"0000001D"
force read_a "11100"
force read_b "11101"
force clk 1
run 2
force clk 0 
run 2

# Register R30
force write_address "11110"
force din X"0000001E"
force read_a "11101"
force read_b "11110"
force clk 1
run 2
force clk 0
run 2

# Register R31
force write_address "11111"
force din X"0000001F"
force read_a "11110"
force read_b "11111"
force clk 1
run 2
force clk 0
run 2
