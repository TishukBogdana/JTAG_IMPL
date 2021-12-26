`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ITMO University
// Engineer: Bogdana Tishchuk
//
// Create Date: 02.10.2021 16:32:04
// Design Name:  JTAG simple TAP controller
// Module Name: tap
// Project Name: Lab1 SoC Verification
// Target Devices: xc7a100tcsg324-1
// Tool Versions: 2019.1
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module tap(
    input  logic rst_n, // Async reset
    input  logic clk, // system clock
    (* mark_debug = "true" *) input  logic tck,
    (* mark_debug = "true" *) input  logic tdi,
    (* mark_debug = "true" *) input  logic tms,
    (* mark_debug = "true" *) output logic tdo,
    input  logic [3:0] ext_din,
    output logic [3:0] ext_state

    );

  localparam DEPTH  = 4;
  localparam WIDTH  = 2;
  localparam AWIDTH = $clog2(DEPTH);

  localparam INST_BYPASS  = 5'b11111;
  localparam INST_IDCODE  = 5'b00001;
  localparam INST_SAMPLE  = 5'b00010;
  localparam INST_PRELOAD = 5'b00011;
  localparam INST_INTEST  = 5'b00100;
  localparam INST_EXTEST  = 5'b00101;
  localparam INST_BIST    = 5'b00111;
  localparam INST_CFG_MEM = 5'b01000;
  localparam INST_CFG_CTR = 5'b01001;
   

  localparam BSR_WIDTH    = 10;
  localparam IDCODE       = 32'hdeadbeef;

  localparam ST_RST      = 0;
  localparam ST_RUN_IDLE = 1;
  localparam ST_IR_SEL   = 2;
  localparam ST_CAPIR    = 3;
  localparam ST_SHIR     = 4;
  localparam ST_EX1_IR   = 5;
  localparam ST_EX2_IR   = 6;
  localparam ST_PAUSE_IR = 7;
  localparam ST_UPDIR    = 8;
  localparam ST_DR_SEL   = 9;
  localparam ST_CAPDR    = 10;
  localparam ST_SHDR     = 11;
  localparam ST_EX1_DR   = 12;
  localparam ST_EX2_DR   = 13;
  localparam ST_PAUSE_DR = 14;
  localparam ST_UPDDR    = 15;
  localparam NUMSTATES   = 16;

  localparam DESIGN_INST  = 5'b1;
  localparam BIST_RLENGTH = 25;

(* mark_debug = "true" *) logic [3:0] drive;
(* mark_debug = "true" *) logic [3:0] bist_drive;
(* mark_debug = "true" *) logic [3:0] state;
(* mark_debug = "true" *) logic clk_muxed;
(* mark_debug = "true" *) logic bdscan_tmode;
(* mark_debug = "true" *) logic bist_tmode;
 logic [31:0] idcode_ff;
 logic [31:0] idcode_next;
 logic        idcode_en;
                          logic single_sw_ff;
                          logic tmode_clk_ff;
                          logic bist_start_ff;
                          logic bist_prohibit_ff;
                          logic bist_run_ff;
                          logic bist_fsm_rst_ff;
(* mark_debug = "true" *) logic [4 :0] instr_slr_next;
(* mark_debug = "true" *) logic [4 :0] instr_slr_ff;
(* mark_debug = "true" *) logic [4 :0] instr_upd_ff;

(* mark_debug = "true" *) logic                   tdo_next;
(* mark_debug = "true" *) logic                   tdo_ff;
(* mark_debug = "true" *) logic                   tdo_pos_ff;
(* mark_debug = "true" *) logic                   bypass_sel;
(* mark_debug = "true" *) logic                   bypass_next;
(* mark_debug = "true" *) logic                   bypass_ff;
(* mark_debug = "true" *) logic                   bsr_sel;
(* mark_debug = "true" *) logic                   bsr_in0_ff;
(* mark_debug = "true" *) logic                   bsr_in1_ff;
(* mark_debug = "true" *) logic                   bsr_in2_ff;
(* mark_debug = "true" *) logic                   bsr_in3_ff;
(* mark_debug = "true" *) logic                   bsr_st0_ff;
 logic                   bsr_st1_ff;
 logic                   bsr_st2_ff;
 logic                   bsr_st3_ff;
 logic                   bsr_sw_ff;
 logic                   bsr_rst_ff;
 logic                   bsr_upd_en;
 logic [BSR_WIDTH  -1:0] bsr_upd_ff;
 logic                     bist_sel;
 logic [BIST_RLENGTH -1:0] bist_slr_next;
 logic [3:0] fault_state;
 logic [3:0] fault_trans;
 logic [3:0] fault_drive;
 logic [3:0] fault_ref;
(* mark_debug = "true" *) logic [BIST_RLENGTH -1:0] bist_slr_ff;
(* mark_debug = "true" *) logic [BIST_RLENGTH -1:0] bist_upd_ff;
(* mark_debug = "true" *) logic                     bist_suc;
(* mark_debug = "true" *) logic [6:0]               bist_duration;
 logic clk_fsm;
 logic [BSR_WIDTH  -1:0] sample_sig;
 logic [BSR_WIDTH  -1:0] prld_sig;
(* mark_debug = "true" *) logic [NUMSTATES  -1:0] tap_state_ff;
(* mark_debug = "true" *) logic [NUMSTATES  -1:0] tap_state_next;
(* mark_debug = "true" *) logic [5:0]             tms_one_ctr_ff;
(* mark_debug = "true" *) logic                   sh_ir;
(* mark_debug = "true" *) logic                   capture_ir;
(* mark_debug = "true" *) logic                   update_ir;
(* mark_debug = "true" *) logic                   capture_dr;
(* mark_debug = "true" *) logic                   update_dr;
(* mark_debug = "true" *) logic                   sh_dr;
(* mark_debug = "true" *) logic                   nrml_tmode_ff;

logic [23:0] mem_cfg_next;
logic [7:0] bist_mem_data;
logic [23:0] mem_cfg_ff;
logic [15:0] dur_cfg_next;
logic [15:0] dur_cfg_ff;
logic [15:0] dur_upd_ff;
logic [23:0] mem_upd_ff;
// This is for ILA
always_ff @(posedge clk )
    tdo_pos_ff <= tdo_next;
    
// TAP FSM description
always_ff @(posedge tck or negedge rst_n)
        if (~rst_n)
             tms_one_ctr_ff <= '0;
        else
        tms_one_ctr_ff <= ( tms & ~tap_state_ff[ST_RST] ) ? ( tms_one_ctr_ff[5] ? tms_one_ctr_ff : tms_one_ctr_ff << 1)  : 6'b1 ;

assign tap_state_next[ST_RST] = tms_one_ctr_ff[5]
                              | ( tap_state_ff[ST_RST] & tms );

assign tap_state_next[ST_RUN_IDLE] = ( tap_state_ff[ST_RUN_IDLE] & ~tms )
                                   | ( tap_state_ff[ST_RST]      & ~tms )
                                   | ( tap_state_ff[ST_UPDIR]    & ~tms )
                                   | ( tap_state_ff[ST_UPDDR]    & ~tms );

assign tap_state_next[ST_IR_SEL] = ( tap_state_ff[ST_DR_SEL] & tms )
                                 | ( tap_state_ff[ST_IR_SEL] & tms & ~tms_one_ctr_ff[5] ); //! ??

assign tap_state_next[ST_CAPIR] = ( tap_state_ff[ST_IR_SEL] & ~tms );

assign tap_state_next[ST_SHIR]  = (  tap_state_ff[ST_CAPIR]  & ~tms )
                                | (  tap_state_ff[ST_SHIR]   & ~tms )
                                | (  tap_state_ff[ST_EX2_IR] & ~tms );

assign tap_state_next[ST_EX1_IR] = (  tap_state_ff[ST_CAPIR]  & tms )
                                 | (  tap_state_ff[ST_SHIR]   & tms );

assign tap_state_next[ST_PAUSE_IR] = ( tap_state_ff[ST_EX1_IR]    & ~tms )
                                   | ( tap_state_ff[ST_PAUSE_IR]  & ~tms );

assign tap_state_next[ST_EX2_IR]  =  ( tap_state_ff[ST_PAUSE_IR]  & tms );

assign tap_state_next[ST_UPDIR]   =  (  tap_state_ff[ST_EX2_IR] & tms )
                                  |  (  tap_state_ff[ST_EX1_IR] & tms ) ;

assign tap_state_next[ST_DR_SEL] = ( tap_state_ff[ST_RUN_IDLE] & tms )
                                 | ( tap_state_ff[ST_UPDIR]    & tms );

assign tap_state_next[ST_CAPDR]  =  ( tap_state_ff[ST_DR_SEL] & ~tms );

assign tap_state_next[ST_SHDR]  = (  tap_state_ff[ST_CAPDR]  & ~tms )
                                | (  tap_state_ff[ST_SHDR]   & ~tms )
                                | (  tap_state_ff[ST_EX2_DR] & ~tms );

assign tap_state_next[ST_EX1_DR] = (  tap_state_ff[ST_CAPDR]  & tms )
                                 | (  tap_state_ff[ST_SHDR]   & tms );

assign tap_state_next[ST_PAUSE_DR] = ( tap_state_ff[ST_EX1_DR]    & ~tms )
                                   | ( tap_state_ff[ST_PAUSE_DR]  & ~tms );

assign tap_state_next[ST_EX2_DR]  =  ( tap_state_ff[ST_PAUSE_DR]  & tms );

assign tap_state_next[ST_UPDDR]   =  (  tap_state_ff[ST_EX2_DR] & tms )
                                  |  (  tap_state_ff[ST_EX1_DR] & tms ) ;

always_ff @(posedge tck or negedge rst_n )
    if (~rst_n) tap_state_ff <= 1;
    else    tap_state_ff <= tap_state_next;

assign update_ir   = tap_state_ff[ST_UPDIR];
assign update_dr   = tap_state_ff[ST_UPDDR];
assign sh_ir       = tap_state_ff[ST_SHIR];
assign sh_dr       = tap_state_ff[ST_SHDR];
assign capture_ir  = tap_state_ff[ST_CAPIR];
assign capture_dr  = tap_state_ff[ST_CAPDR];

always_ff @(posedge tck )
        nrml_tmode_ff <= tap_state_next[ST_RST] ? 1'b0 :  1'b1;


// TAP instruction register

assign instr_slr_next = capture_ir ? DESIGN_INST
                                   : sh_ir ? {tdi, instr_slr_ff[4:1] }
                                           : instr_slr_ff;

always_ff @(posedge tck )
        instr_slr_ff <= instr_slr_next;



//// TAP data registers and commands


assign bypass_sel = &(instr_upd_ff);
assign bypass_next  = ( capture_dr | tap_state_ff[ST_RST] ) ? 0 : ( sh_dr ? tdi : bypass_ff );



assign bsr_sel = ( instr_upd_ff == INST_INTEST )
               | ( instr_upd_ff == INST_EXTEST )
               | ( instr_upd_ff == INST_SAMPLE )
               | ( instr_upd_ff == INST_PRELOAD );

always_ff @(posedge tck or negedge rst_n )
    if (~rst_n) begin
        bsr_rst_ff   <= '0;
        bsr_sw_ff    <= '0;
        bsr_in3_ff   <= '0;
        bsr_in2_ff   <= '0;
        bsr_in1_ff   <= '0;
        bsr_in0_ff   <= '0;
        bsr_st3_ff   <= '0;
        bsr_st2_ff   <= '0;
        bsr_st1_ff   <= '0;
        bsr_st0_ff   <= '0;
    end else begin
        bsr_rst_ff   <= capture_dr ? '0 : sh_dr ? tdi : bsr_rst_ff;
        bsr_sw_ff    <= capture_dr ? '0 : sh_dr ? bsr_rst_ff : bsr_sw_ff;
        bsr_in3_ff   <= capture_dr ? drive[3] : sh_dr? bsr_sw_ff : bsr_in3_ff;
        bsr_in2_ff   <= capture_dr ? drive[2] : sh_dr? bsr_in3_ff : bsr_in2_ff;
        bsr_in1_ff   <= capture_dr ? drive[1] : sh_dr? bsr_in2_ff : bsr_in1_ff;
        bsr_in0_ff   <= capture_dr ? drive[0] : sh_dr? bsr_in1_ff : bsr_in0_ff;
        bsr_st3_ff   <= capture_dr ? state[3] : sh_dr? bsr_in0_ff : bsr_st3_ff;
        bsr_st2_ff   <= capture_dr ? state[2] : sh_dr? bsr_st3_ff : bsr_st2_ff;
        bsr_st1_ff   <= capture_dr ? state[1] : sh_dr? bsr_st2_ff : bsr_st1_ff;
        bsr_st0_ff   <= capture_dr ? state[0] : sh_dr? bsr_st1_ff : bsr_st0_ff;
        bypass_ff  <= bypass_sel ? bypass_next : bypass_ff;
    end

always_ff @(negedge tck or negedge rst_n) 
    if (~rst_n) begin
        bsr_upd_ff <= '0;
        instr_upd_ff <= '0;
     end else begin
        bsr_upd_ff <= (update_dr & bsr_sel) ? { bsr_rst_ff,
                                                bsr_sw_ff,
                                                bsr_in3_ff,
                                                bsr_in2_ff,
                                                bsr_in1_ff,
                                                bsr_in0_ff,
                                                bsr_st3_ff,
                                                bsr_st2_ff,
                                                bsr_st1_ff,
                                                bsr_st0_ff } : bsr_upd_ff ;

        instr_upd_ff <= tap_state_ff[ST_RST] ? INST_IDCODE
                                             : (update_ir ? instr_slr_ff : instr_upd_ff );
    end

assign mem_cfg_next = capture_dr ? {1'b0, mem_cfg_ff[22:8], bist_mem_data } : (sh_dr ? {tdi, mem_cfg_ff[23:1]} : mem_cfg_ff );
assign dur_cfg_next = sh_dr ? {tdi, dur_cfg_ff[15:1]} : dur_cfg_ff;

always_ff @(posedge tck or negedge rst_n)
  if (~rst_n)begin 
    mem_cfg_ff <= '0;
    dur_cfg_ff <= '0;
  end else begin
    dur_cfg_ff <= ( instr_upd_ff == INST_CFG_CTR) ? dur_cfg_next : dur_cfg_ff ;
    mem_cfg_ff <= ( instr_upd_ff == INST_CFG_MEM) ? mem_cfg_next : mem_cfg_ff ;
 end
    
 always_ff @(negedge tck or negedge rst_n)
  if (~rst_n)begin 
    mem_upd_ff <= '0;
    dur_upd_ff <= '0;
  end else begin
    dur_upd_ff <= (( instr_upd_ff == INST_CFG_CTR) & update_dr) ?  dur_cfg_ff : dur_upd_ff ;
    mem_upd_ff <= (( instr_upd_ff == INST_CFG_MEM) & update_dr) ?  mem_cfg_ff : mem_upd_ff;
 end
    
assign tdo_next = sh_ir ? instr_slr_ff[0] : ( (instr_upd_ff == INST_BYPASS) ? bypass_ff
                                                                            : bsr_sel ? bsr_st0_ff
                                                                            : ( instr_upd_ff == INST_IDCODE) ? idcode_ff[0]
                                                                                                             :( bist_sel ? bist_slr_ff[0] 
                                                                                                                         : ( ( instr_upd_ff == INST_CFG_MEM) ?  mem_cfg_ff[0]
                                                                                                                                                           : ( ( instr_upd_ff == INST_CFG_CTR )? dur_cfg_ff[0]
                                                                                                                                                                                               :0 )) )) ;

always_ff @(negedge tck)
     if (sh_dr | sh_ir)
        tdo_ff <= tdo_next;

assign tdo = tdo_ff;

assign idcode_next = capture_dr ? IDCODE
                                : sh_dr ? {tdi, idcode_ff[31:1] } : idcode_ff;

assign idcode_en = ( instr_upd_ff == INST_IDCODE);
always_ff @(posedge tck)
  if ( idcode_en )
        idcode_ff <= idcode_next;

assign drive = (instr_upd_ff == INST_INTEST) ? bsr_upd_ff[7:4]
                                             : ( (instr_upd_ff == INST_BIST) ? bist_drive : ext_din);

assign ext_state = (( instr_upd_ff == INST_EXTEST ) & nrml_tmode_ff) ? bsr_upd_ff[3:0]
                                                                    : ( nrml_tmode_ff & ~(( instr_upd_ff == INST_SAMPLE )
                                                                                       | ( instr_upd_ff == INST_PRELOAD )
                                                                                       | ( instr_upd_ff == INST_BYPASS )) )? 'bz : state;

// BIST
assign bist_sel = (instr_upd_ff == INST_BIST);

assign bist_slr_next = capture_dr ? {1'b0, fault_state, fault_drive, fault_trans, fault_ref, bist_duration, bist_suc} : (sh_dr ? {tdi, bist_slr_ff [BIST_RLENGTH-1:1]} : bist_slr_ff);

always_ff @(posedge tck or negedge rst_n)
  if(~rst_n)
    bist_slr_ff <= '0;
  else if (bist_sel)
    bist_slr_ff <= bist_slr_next;

always_ff @(negedge tck or negedge rst_n)
  if (~rst_n)
    bist_upd_ff <= '0;
  else if (bist_sel)
    bist_upd_ff <= bist_slr_ff;

  assign bdscan_tmode = ( nrml_tmode_ff & ~(( instr_upd_ff == INST_SAMPLE )
                                         | ( instr_upd_ff == INST_PRELOAD )
                                         | ( instr_upd_ff == INST_BIST )
                                         | ( instr_upd_ff == INST_BYPASS )) );

  assign bist_tmode  = ( instr_upd_ff == INST_BIST ) & bist_upd_ff[24]; // and bist_start
    
  always_ff @(posedge tck or negedge rst_n)
    if(~rst_n) begin
      single_sw_ff  <= '0;
      tmode_clk_ff  <= '0;
      bist_start_ff <= '0;
      bist_fsm_rst_ff <= '0;
      bist_run_ff   <= '0;
    end else begin
      single_sw_ff <= ~single_sw_ff & bsr_upd_ff[8] & ~tmode_clk_ff;
      tmode_clk_ff <= bsr_upd_ff[8];
      bist_run_ff  <= bist_tmode;
      bist_start_ff <= ~bist_start_ff & bist_tmode & ~bist_run_ff;
      bist_fsm_rst_ff <= bist_start_ff;
      
    end

    assign clk_muxed = bist_tmode? tck :clk;
    assign clk_fsm = bdscan_tmode? bsr_upd_ff[8]:clk_muxed;

  fsm_mur fsm_dut(
    .clk          (clk_fsm),
    .rst_n        (rst_n),
    .sig_in       (drive),
    .state_o      (state),
    .start_bist   (bist_fsm_rst_ff),
    .rst_state    (bsr_upd_ff[9])
    );

  bist i_bist(
    .clk         (tck),
    .rst_n       (rst_n),
    .tst_start_i (bist_start_ff),
    .state_i     (state),
    .drive_o     (bist_drive),
    .success_o   (bist_suc),
    .duration_o  (bist_duration),
    .mem_we_i    (mem_upd_ff[23]),
    .mem_addr_i  (mem_upd_ff[22:16]),
    .mem_data_i  (mem_upd_ff[15:8]),
    .mem_data_o  (bist_mem_data),
    .start_addr_cfg_i(dur_upd_ff[7]),
    .start_addr_i(dur_upd_ff[6:0]),
    
    .fault_state_o (fault_state),
    .fault_trans_o (fault_trans),
    .fault_drive_o (fault_drive),
    .fault_ref_o   (fault_ref),
    .dur_cfg_i (dur_upd_ff[15]),
    .duration_i (dur_upd_ff[14:8])
    );

endmodule