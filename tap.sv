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
    input  logic [1:0] ext_addr,
    input  logic [1:0] ext_din,
    input  logic       ext_wr,
    output logic [1:0] ext_dout

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
  localparam BSR_WIDTH    = WIDTH * 2 + AWIDTH + 1;
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

  localparam DESIGN_INST = 5'b1;

(* mark_debug = "true" *) logic              ram_wr;
(* mark_debug = "true" *) logic              ram_wr_gated;
(* mark_debug = "true" *) logic [WIDTH -1:0] ram_din;
(* mark_debug = "true" *) logic [WIDTH -1:0] ram_dout;
(* mark_debug = "true" *) logic [AWIDTH-1:0] ram_addr;

(* mark_debug = "true" *) logic [31:0] idcode_ff;
(* mark_debug = "true" *) logic [31:0] idcode_next;
(* mark_debug = "true" *) logic        idcode_en;

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
(* mark_debug = "true" *) logic                   bsr_wr_ff;
(* mark_debug = "true" *) logic                   bsr_addr0_ff;
(* mark_debug = "true" *) logic                   bsr_addr1_ff;
(* mark_debug = "true" *) logic                   bsr_din0_ff;
(* mark_debug = "true" *) logic                   bsr_din1_ff;
(* mark_debug = "true" *) logic                   bsr_dout0_ff;
(* mark_debug = "true" *) logic                   bsr_dout1_ff;
(* mark_debug = "true" *) logic                   bsr_upd_en;
(* mark_debug = "true" *) logic [BSR_WIDTH  -1:0] bsr_upd_ff;
(* mark_debug = "true" *) logic [BSR_WIDTH  -1:0] sample_sig;
(* mark_debug = "true" *) logic [BSR_WIDTH  -1:0] prld_sig;
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

// TAP FSM description
always_ff @(posedge tck )
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

always_ff @(posedge tck )
        tap_state_ff <= tap_state_next;

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

always_ff @(posedge tck )
    begin
        bsr_wr_ff    <= capture_dr ? ram_wr : sh_dr? tdi : bsr_wr_ff;
        bsr_addr1_ff <= capture_dr ? ram_addr[1] : sh_dr? bsr_wr_ff : bsr_addr1_ff;
        bsr_addr0_ff <= capture_dr ? ram_addr[0] : sh_dr? bsr_addr1_ff : bsr_addr0_ff;
        bsr_din1_ff  <= capture_dr ? ram_din[1] : sh_dr? bsr_addr0_ff : bsr_din1_ff;
        bsr_din0_ff  <= capture_dr ? ram_din[0] : sh_dr? bsr_din1_ff : bsr_din0_ff;
        bsr_dout1_ff <= capture_dr ? ram_dout[1] : sh_dr? bsr_din0_ff : bsr_dout1_ff;
        bsr_dout0_ff <= capture_dr ? ram_dout[0] : sh_dr? bsr_dout1_ff : bsr_dout0_ff;
        bypass_ff  <= bypass_sel ? bypass_next : bypass_ff;
    end

always_ff @(negedge tck )
     begin
        bsr_upd_ff <= (update_dr & bsr_sel) ? {bsr_wr_ff, bsr_addr1_ff, bsr_addr0_ff, bsr_din1_ff, bsr_din0_ff, bsr_dout1_ff, bsr_dout0_ff } : bsr_upd_ff ;
        instr_upd_ff <= tap_state_ff[ST_RST] ? INST_IDCODE
                                             : (update_ir ? instr_slr_ff : instr_upd_ff );
    end

assign tdo_next = sh_ir ? instr_slr_ff[0] : ( (instr_upd_ff == INST_BYPASS) ? bypass_ff
                                                                            : bsr_sel ? bsr_dout0_ff
                                                                            : ( instr_upd_ff == INST_IDCODE) ? idcode_ff[0]
                                                                                                             : 0) ;

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

assign ram_din = (instr_upd_ff == INST_INTEST) ? bsr_upd_ff[3:2]
                                               : ext_din;

assign ram_addr = (instr_upd_ff == INST_INTEST ) ? bsr_upd_ff[5:4]
                                                 : ext_addr;

assign ram_wr = (( instr_upd_ff == INST_INTEST ) & nrml_tmode_ff)
               ? bsr_upd_ff[6]
               :  nrml_tmode_ff & ~(( instr_upd_ff == INST_SAMPLE )
                                    | ( instr_upd_ff == INST_PRELOAD )
                                    | ( instr_upd_ff == INST_BYPASS )) ? 1'b0
                                                                        : ext_wr;

assign ext_dout = (( instr_upd_ff == INST_EXTEST ) & nrml_tmode_ff) ? bsr_upd_ff[1:0]
                                                                    : ( nrml_tmode_ff & ~(( instr_upd_ff == INST_SAMPLE )
                                                                                       | ( instr_upd_ff == INST_PRELOAD )
                                                                                       | ( instr_upd_ff == INST_BYPASS )) )? 'bz : ram_dout;
// This is for ILA
always_ff @(posedge clk )
    tdo_pos_ff <= tdo_next;
    
// add bufg_mux here for rams_wr
dut dut_ram (
    .wr   (ram_wr),
    .din  (ram_din),
    .dout (ram_dout),
    .addr (ram_addr)
);


endmodule