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



connect_debug_port u_ila_0/probe28 [get_nets [list p_0_in]]

connect_debug_port u_ila_0/probe3 [get_nets [list {i_bist/ref_ptr[0]} {i_bist/ref_ptr[1]} {i_bist/ref_ptr[2]} {i_bist/ref_ptr[3]} {i_bist/ref_ptr[4]} {i_bist/ref_ptr[5]} {i_bist/ref_ptr[6]}]]
connect_debug_port u_ila_0/probe5 [get_nets [list {i_bist/success_ff[0]} {i_bist/success_ff[1]} {i_bist/success_ff[2]} {i_bist/success_ff[3]} {i_bist/success_ff[4]} {i_bist/success_ff[5]} {i_bist/success_ff[6]} {i_bist/success_ff[7]} {i_bist/success_ff[8]} {i_bist/success_ff[9]} {i_bist/success_ff[10]} {i_bist/success_ff[11]} {i_bist/success_ff[12]} {i_bist/success_ff[13]} {i_bist/success_ff[14]} {i_bist/success_ff[15]} {i_bist/success_ff[16]} {i_bist/success_ff[17]} {i_bist/success_ff[18]} {i_bist/success_ff[19]} {i_bist/success_ff[20]} {i_bist/success_ff[21]} {i_bist/success_ff[22]} {i_bist/success_ff[23]} {i_bist/success_ff[24]} {i_bist/success_ff[25]} {i_bist/success_ff[26]} {i_bist/success_ff[27]} {i_bist/success_ff[28]} {i_bist/success_ff[29]} {i_bist/success_ff[30]} {i_bist/success_ff[31]} {i_bist/success_ff[32]} {i_bist/success_ff[33]} {i_bist/success_ff[34]} {i_bist/success_ff[35]} {i_bist/success_ff[36]} {i_bist/success_ff[37]} {i_bist/success_ff[38]} {i_bist/success_ff[39]} {i_bist/success_ff[40]} {i_bist/success_ff[41]} {i_bist/success_ff[42]} {i_bist/success_ff[43]} {i_bist/success_ff[44]} {i_bist/success_ff[45]} {i_bist/success_ff[46]} {i_bist/success_ff[47]} {i_bist/success_ff[48]} {i_bist/success_ff[49]} {i_bist/success_ff[50]} {i_bist/success_ff[51]} {i_bist/success_ff[52]} {i_bist/success_ff[53]} {i_bist/success_ff[54]} {i_bist/success_ff[55]} {i_bist/success_ff[56]} {i_bist/success_ff[57]} {i_bist/success_ff[58]} {i_bist/success_ff[59]} {i_bist/success_ff[60]} {i_bist/success_ff[61]} {i_bist/success_ff[62]} {i_bist/success_ff[63]} {i_bist/success_ff[64]} {i_bist/success_ff[65]} {i_bist/success_ff[66]} {i_bist/success_ff[67]} {i_bist/success_ff[68]} {i_bist/success_ff[69]} {i_bist/success_ff[70]} {i_bist/success_ff[71]} {i_bist/success_ff[72]} {i_bist/success_ff[73]} {i_bist/success_ff[74]} {i_bist/success_ff[75]} {i_bist/success_ff[76]} {i_bist/success_ff[77]} {i_bist/success_ff[78]} {i_bist/success_ff[79]} {i_bist/success_ff[80]} {i_bist/success_ff[81]} {i_bist/success_ff[82]} {i_bist/success_ff[83]} {i_bist/success_ff[84]} {i_bist/success_ff[85]} {i_bist/success_ff[86]} {i_bist/success_ff[87]} {i_bist/success_ff[88]} {i_bist/success_ff[89]} {i_bist/success_ff[90]} {i_bist/success_ff[91]} {i_bist/success_ff[92]}]]
connect_debug_port u_ila_0/probe31 [get_nets [list p_0_in6_in]]
connect_debug_port u_ila_0/probe35 [get_nets [list tdi_IBUF]]

connect_debug_port u_ila_0/probe31 [get_nets [list p_1_in2_in]]

