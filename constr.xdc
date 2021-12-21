set_property PACKAGE_PIN H17 [get_ports {ext_dout[0]}]
set_property PACKAGE_PIN K15 [get_ports {ext_dout[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_dout[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_dout[1]}]
set_property PACKAGE_PIN J15 [get_ports {ext_din[0]}]
set_property PACKAGE_PIN L16 [get_ports {ext_din[1]}]
set_property PACKAGE_PIN M13 [get_ports {ext_addr[0]}]
set_property PACKAGE_PIN R15 [get_ports {ext_addr[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_din[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_din[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_addr[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_addr[1]}]
set_property PACKAGE_PIN E3 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property PACKAGE_PIN R17 [get_ports ext_wr]
set_property IOSTANDARD LVCMOS33 [get_ports ext_wr]
set_property PACKAGE_PIN C12 [get_ports rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]

create_clock -period 10.000 -name clk -waveform {0.000 5.000} [get_ports -filter { NAME =~  "*clk*" && DIRECTION == "IN" }]
create_clock -period 100.000 -name tck -waveform {0.000 50.000} [get_ports -filter { NAME =~  "*tck*" && DIRECTION == "IN" }]



set_property IOSTANDARD LVCMOS33 [get_ports tdo]
set_property PACKAGE_PIN C17 [get_ports tdi]
set_property IOSTANDARD LVCMOS33 [get_ports tdi]
set_property PACKAGE_PIN E18 [get_ports tms]
set_property IOSTANDARD LVCMOS33 [get_ports tms]
set_property PACKAGE_PIN D18 [get_ports tck]
set_property IOSTANDARD LVCMOS33 [get_ports tck]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets tck_IBUF]


set_property PACKAGE_PIN G17 [get_ports tdo]
set_property PULLUP true [get_ports tms]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]





set_property PACKAGE_PIN M13 [get_ports {ext_din[2]}]
set_property PACKAGE_PIN R15 [get_ports {ext_din[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_din[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_din[3]}]
set_property PACKAGE_PIN H17 [get_ports {ext_state[0]}]
set_property PACKAGE_PIN K15 [get_ports {ext_state[1]}]
set_property PACKAGE_PIN J13 [get_ports {ext_state[2]}]
set_property PACKAGE_PIN N14 [get_ports {ext_state[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_state[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_state[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_state[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_state[0]}]
