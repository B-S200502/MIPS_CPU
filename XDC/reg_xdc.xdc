## Allow clk to route on non-dedicated resources (only needed if clk is not on a proper clock pin)
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets clk];

## din_in[3:0] 
set_property -dict { PACKAGE_PIN J15 IOSTANDARD LVCMOS33 } [get_ports { din_in[0] }];
set_property -dict { PACKAGE_PIN L16 IOSTANDARD LVCMOS33 } [get_ports { din_in[1] }];
set_property -dict { PACKAGE_PIN M13 IOSTANDARD LVCMOS33 } [get_ports { din_in[2] }];
set_property -dict { PACKAGE_PIN R15 IOSTANDARD LVCMOS33 } [get_ports { din_in[3] }];

## reset (async, active-high)  
set_property -dict { PACKAGE_PIN R17 IOSTANDARD LVCMOS33 } [get_ports { reset }];

## clk (if this is not the 100 MHz clock pin, leave CLOCK_DEDICATED_ROUTE as above)
set_property -dict { PACKAGE_PIN T18 IOSTANDARD LVCMOS33 } [get_ports { clk }];

## write enable 
set_property -dict { PACKAGE_PIN U18 IOSTANDARD LVCMOS33 } [get_ports { write }];

## read_a_in[1:0]
set_property -dict { PACKAGE_PIN R13 IOSTANDARD LVCMOS33 } [get_ports { read_a_in[0] }];
set_property -dict { PACKAGE_PIN T8  IOSTANDARD LVCMOS33 } [get_ports { read_a_in[1] }];

## read_b_in[1:0]
set_property -dict { PACKAGE_PIN U8  IOSTANDARD LVCMOS33 } [get_ports { read_b_in[0] }];
set_property -dict { PACKAGE_PIN R16 IOSTANDARD LVCMOS33 } [get_ports { read_b_in[1] }];

## write_address_in[1:0]
set_property -dict { PACKAGE_PIN T13 IOSTANDARD LVCMOS33 } [get_ports { write_address_in[0] }];
set_property -dict { PACKAGE_PIN H6  IOSTANDARD LVCMOS33 } [get_ports { write_address_in[1] }];

## out_a_out[3:0] 
set_property -dict { PACKAGE_PIN H17 IOSTANDARD LVCMOS33 } [get_ports { out_a_out[0] }];
set_property -dict { PACKAGE_PIN K15 IOSTANDARD LVCMOS33 } [get_ports { out_a_out[1] }];
set_property -dict { PACKAGE_PIN J13 IOSTANDARD LVCMOS33 } [get_ports { out_a_out[2] }];
set_property -dict { PACKAGE_PIN N14 IOSTANDARD LVCMOS33 } [get_ports { out_a_out[3] }];

## out_b_out[3:0]
set_property -dict { PACKAGE_PIN V17 IOSTANDARD LVCMOS33 } [get_ports { out_b_out[0] }];
set_property -dict { PACKAGE_PIN U17 IOSTANDARD LVCMOS33 } [get_ports { out_b_out[1] }];
set_property -dict { PACKAGE_PIN U16 IOSTANDARD LVCMOS33 } [get_ports { out_b_out[2] }];
set_property -dict { PACKAGE_PIN V16 IOSTANDARD LVCMOS33 } [get_ports { out_b_out[3] }];
