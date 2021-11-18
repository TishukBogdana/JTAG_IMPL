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

set_property PACKAGE_PIN H17 [get_ports {ext_dout[0]}]

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



create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 8192 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list clk_IBUF_BUFG]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 7 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {bsr_slr_next[0]} {bsr_slr_next[1]} {bsr_slr_next[2]} {bsr_slr_next[3]} {bsr_slr_next[4]} {bsr_slr_next[5]} {bsr_slr_next[6]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 7 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {bsr_upd_ff[0]} {bsr_upd_ff[1]} {bsr_upd_ff[2]} {bsr_upd_ff[3]} {bsr_upd_ff[4]} {bsr_upd_ff[5]} {bsr_upd_ff[6]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 32 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {idcode_ff[0]} {idcode_ff[1]} {idcode_ff[2]} {idcode_ff[3]} {idcode_ff[4]} {idcode_ff[5]} {idcode_ff[6]} {idcode_ff[7]} {idcode_ff[8]} {idcode_ff[9]} {idcode_ff[10]} {idcode_ff[11]} {idcode_ff[12]} {idcode_ff[13]} {idcode_ff[14]} {idcode_ff[15]} {idcode_ff[16]} {idcode_ff[17]} {idcode_ff[18]} {idcode_ff[19]} {idcode_ff[20]} {idcode_ff[21]} {idcode_ff[22]} {idcode_ff[23]} {idcode_ff[24]} {idcode_ff[25]} {idcode_ff[26]} {idcode_ff[27]} {idcode_ff[28]} {idcode_ff[29]} {idcode_ff[30]} {idcode_ff[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 7 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {bsr_slr_prld[0]} {bsr_slr_prld[1]} {bsr_slr_prld[2]} {bsr_slr_prld[3]} {bsr_slr_prld[4]} {bsr_slr_prld[5]} {bsr_slr_prld[6]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 5 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {instr_slr_ff[0]} {instr_slr_ff[1]} {instr_slr_ff[2]} {instr_slr_ff[3]} {instr_slr_ff[4]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 5 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {instr_slr_next[0]} {instr_slr_next[1]} {instr_slr_next[2]} {instr_slr_next[3]} {instr_slr_next[4]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 2 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {ram_addr[0]} {ram_addr[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 2 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {ram_din[0]} {ram_din[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 2 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {ram_dout[0]} {ram_dout[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 7 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {sample_sig[0]} {sample_sig[1]} {sample_sig[2]} {sample_sig[3]} {sample_sig[4]} {sample_sig[5]} {sample_sig[6]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 7 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {prld_sig[0]} {prld_sig[1]} {prld_sig[2]} {prld_sig[3]} {prld_sig[4]} {prld_sig[5]} {prld_sig[6]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 5 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {instr_upd_ff[0]} {instr_upd_ff[1]} {instr_upd_ff[2]} {instr_upd_ff[3]} {instr_upd_ff[4]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 16 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {tap_state_ff[0]} {tap_state_ff[1]} {tap_state_ff[2]} {tap_state_ff[3]} {tap_state_ff[4]} {tap_state_ff[5]} {tap_state_ff[6]} {tap_state_ff[7]} {tap_state_ff[8]} {tap_state_ff[9]} {tap_state_ff[10]} {tap_state_ff[11]} {tap_state_ff[12]} {tap_state_ff[13]} {tap_state_ff[14]} {tap_state_ff[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 16 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list {tap_state_next[0]} {tap_state_next[1]} {tap_state_next[2]} {tap_state_next[3]} {tap_state_next[4]} {tap_state_next[5]} {tap_state_next[6]} {tap_state_next[7]} {tap_state_next[8]} {tap_state_next[9]} {tap_state_next[10]} {tap_state_next[11]} {tap_state_next[12]} {tap_state_next[13]} {tap_state_next[14]} {tap_state_next[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 7 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list {bsr_slr_ff[0]} {bsr_slr_ff[1]} {bsr_slr_ff[2]} {bsr_slr_ff[3]} {bsr_slr_ff[4]} {bsr_slr_ff[5]} {bsr_slr_ff[6]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 32 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list {idcode_next[0]} {idcode_next[1]} {idcode_next[2]} {idcode_next[3]} {idcode_next[4]} {idcode_next[5]} {idcode_next[6]} {idcode_next[7]} {idcode_next[8]} {idcode_next[9]} {idcode_next[10]} {idcode_next[11]} {idcode_next[12]} {idcode_next[13]} {idcode_next[14]} {idcode_next[15]} {idcode_next[16]} {idcode_next[17]} {idcode_next[18]} {idcode_next[19]} {idcode_next[20]} {idcode_next[21]} {idcode_next[22]} {idcode_next[23]} {idcode_next[24]} {idcode_next[25]} {idcode_next[26]} {idcode_next[27]} {idcode_next[28]} {idcode_next[29]} {idcode_next[30]} {idcode_next[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 6 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list {tms_one_ctr_ff[0]} {tms_one_ctr_ff[1]} {tms_one_ctr_ff[2]} {tms_one_ctr_ff[3]} {tms_one_ctr_ff[4]} {tms_one_ctr_ff[5]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 1 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list bsr_sel]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 1 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list bsr_upd_en]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 1 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list bypass_ff]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 1 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list bypass_next]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
set_property port_width 1 [get_debug_ports u_ila_0/probe21]
connect_debug_port u_ila_0/probe21 [get_nets [list bypass_sel]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
set_property port_width 1 [get_debug_ports u_ila_0/probe22]
connect_debug_port u_ila_0/probe22 [get_nets [list capture_dr]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe23]
set_property port_width 1 [get_debug_ports u_ila_0/probe23]
connect_debug_port u_ila_0/probe23 [get_nets [list capture_ir]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe24]
set_property port_width 1 [get_debug_ports u_ila_0/probe24]
connect_debug_port u_ila_0/probe24 [get_nets [list idcode_en]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe25]
set_property port_width 1 [get_debug_ports u_ila_0/probe25]
connect_debug_port u_ila_0/probe25 [get_nets [list nrml_tmode_ff]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe26]
set_property port_width 1 [get_debug_ports u_ila_0/probe26]
connect_debug_port u_ila_0/probe26 [get_nets [list p_0_in5_in]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe27]
set_property port_width 1 [get_debug_ports u_ila_0/probe27]
connect_debug_port u_ila_0/probe27 [get_nets [list p_1_in]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe28]
set_property port_width 1 [get_debug_ports u_ila_0/probe28]
connect_debug_port u_ila_0/probe28 [get_nets [list ram_wr]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe29]
set_property port_width 1 [get_debug_ports u_ila_0/probe29]
connect_debug_port u_ila_0/probe29 [get_nets [list ram_wr_gated]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe30]
set_property port_width 1 [get_debug_ports u_ila_0/probe30]
connect_debug_port u_ila_0/probe30 [get_nets [list sh_dr]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe31]
set_property port_width 1 [get_debug_ports u_ila_0/probe31]
connect_debug_port u_ila_0/probe31 [get_nets [list sh_ir]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe32]
set_property port_width 1 [get_debug_ports u_ila_0/probe32]
connect_debug_port u_ila_0/probe32 [get_nets [list tck_IBUF_BUFG]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe33]
set_property port_width 1 [get_debug_ports u_ila_0/probe33]
connect_debug_port u_ila_0/probe33 [get_nets [list tdo_ff]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe34]
set_property port_width 1 [get_debug_ports u_ila_0/probe34]
connect_debug_port u_ila_0/probe34 [get_nets [list tdo_next]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe35]
set_property port_width 1 [get_debug_ports u_ila_0/probe35]
connect_debug_port u_ila_0/probe35 [get_nets [list tdo_OBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe36]
set_property port_width 1 [get_debug_ports u_ila_0/probe36]
connect_debug_port u_ila_0/probe36 [get_nets [list tdo_pos_ff]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe37]
set_property port_width 1 [get_debug_ports u_ila_0/probe37]
connect_debug_port u_ila_0/probe37 [get_nets [list update_dr]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe38]
set_property port_width 1 [get_debug_ports u_ila_0/probe38]
connect_debug_port u_ila_0/probe38 [get_nets [list update_ir]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk_IBUF_BUFG]
