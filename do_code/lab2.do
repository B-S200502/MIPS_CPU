vsim work.regfile_wrapper
add wave -r /*

-- Clock: 10 time unit period (edges at 5, 15, 25, ...)
force clk 0 0, 1 5 -repeat 10

-- Initialize all inputs to known values at t=0
force reset 1
force write 0
force din_in "0000"
force read_a_in "00"
force read_b_in "00"
force write_address_in "00"

-- Let reset settle before the first rising edge at t=5
run 4      ;# now at t=4
force reset 0
run 2      ;# crosses rising edge at t=5; still no writes (write=0)

-- Write 0b1010 to address 0 (make signals stable before the next rising edge)
force write 1
force din_in "1010"
force write_address_in "00"
run 10     ;# covers a full period so write is captured at rising edge t=15

-- Write 0b1100 to address 1
force din_in "1100"
force write_address_in "01"
run 10     ;# captured at next rising edge t=25

-- Disable writes
force write 0
run 2

-- Read back A=0, B=1
force read_a_in "00"
force read_b_in "01"
run 10

-- Read locations 2 and 3 (expect 0s)
force read_a_in "10"
force read_b_in "11"
run 10

-- Reset to clear registers
force reset 1
run 4
force reset 0
run 6

-- After reset, reading 0 and 1 should be 0s
force read_a_in "00"
force read_b_in "01"
run 10
