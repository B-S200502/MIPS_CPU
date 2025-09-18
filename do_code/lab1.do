add wave *

# ADD: 1 + 1
force x 32'h00000001
force y 32'h00000001
force add_sub 0
force logic_func 2#00
force func 2#10
run 2

# ADD overflow: 0x7FFFFFFF + 1
force x 32'h7FFFFFFF
force y 32'h00000001
force add_sub 0
force logic_func 2#00
force func 2#10
run 2

# SUB: 3 - 1
force x 32'h00000003
force y 32'h00000001
force add_sub 1
force logic_func 2#00
force func 2#10
run 2

# SUB overflow: 0x80000000 - 1
force x 32'h80000000
force y 32'h00000001
force add_sub 1
force logic_func 2#00
force func 2#10
run 2

# SLT: 1 < 2  (expect LSB=1)
force x 32'h00000001
force y 32'h00000002
force logic_func 2#00
force add_sub 0
force func 2#01
run 2

# LOGIC: AND (FFFFFFFF & 0000FFFF) = 0000FFFF
force x 32'hFFFFFFFF
force y 32'h0000FFFF
force logic_func 2#00
force add_sub 0
force func 2#11
run 2

# LOGIC: OR (0F0F0F0F | F0F0F0F0) = FFFFFFFF
force x 32'h0F0F0F0F
force y 32'hF0F0F0F0
force logic_func 2#01
force add_sub 0
force func 2#11
run 2

# LOGIC: XOR (AAAAAAAA ^ 55555555) = FFFFFFFF
force x 32'hAAAAAAAA
force y 32'h55555555
force logic_func 2#10
force add_sub 0
force func 2#11
run 2

# LOGIC: NOR (FFFFFFFF nor 00000000) = 00000000
force x 32'hFFFFFFFF
force y 32'h00000000
force logic_func 2#11
force add_sub 0
force func 2#11
run 2

# LUI row (per lab: output <= y)
force x 32'hFFFFFFFF
force y 32'h00000000
force logic_func 2#00
force add_sub 0
force func 2#00
run 2
