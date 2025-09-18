add wave -r /*

force x X"00000001"
force y X"00000001"
force add_sub 0
force logic_func 00
force func 10
run 2

force x X"7FFFFFFF"
force y X"00000001"
force add_sub 0
force logic_func 00
force func 10
run 2

force x X"00000003"
force y X"00000001"
force add_sub 1
force logic_func 00
force func 10
run 2

force x X"80000000"
force y X"00000001"
force add_sub 1
force logic_func 00
force func 10
run 2

force x X"00000001"
force y X"00000002"
force logic_func 00
force add_sub 0
force func 01
run 2

force x X"FFFFFFFF"
force y X"0000FFFF"
force logic_func 00
force add_sub 0
force func 11
run 2

force x X"0F0F0F0F"
force y X"F0F0F0F0"
force logic_func 01
force add_sub 0
force func 11
run 2

force x X"AAAAAAAA"
force y X"55555555"
force logic_func 10
force add_sub 0
force func 11
run 2

force x X"FFFFFFFF"
force y X"00000000"
force logic_func 11
force add_sub 0
force func 11
run 2

force x X"FFFFFFFF"
force y X"00000000"
force logic_func 00
force add_sub 0
force func 00
run 2
