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
    input  logic tck,
    input  logic tdi,
    input  logic tms,
    output logic tdo,
    input  logic [1:0] ext_addr,
    input  logic [1:0] ext_din,
    input  logic       ext_wr,
    output logic [1:0] ext_dout
    
    );
    
  localparam DEPTH  = 4;
  localparam WIDTH  = 2;
  localparam AWIDTH = $clog2(DEPTH);
  
  localparam INST_BYPASS  = 3'b111;
  localparam INST_IDCODE  = 3'b001;
  localparam INST_SAMPLE  = 3'b010;
  localparam INST_PRELOAD = 3'b011;
  localparam INST_INTEST  = 3'b100;
  localparam INST_EXTEST  = 3'b101;
  localparam BSR_WIDTH    = WIDTH * 2 + AWIDTH + 1;
  
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
  
logic              ram_wr;
logic              ram_wr_gated;
logic [WIDTH -1:0] ram_din;
logic [WIDTH -1:0] ram_dout;
logic [AWIDTH-1:0] ram_addr;

logic [31:0] idcode_ff;

logic [4 :0] instr_slr_next;
logic [4 :0] instr_slr_ff;
logic [4 :0] instr_upd_ff;

logic                   bypass_sel;
logic                   bypass_next;
logic                   bypass_ff;
logic                   bsr_sel;
logic [BSR_WIDTH  -1:0] bsr_slr_prld;
logic [BSR_WIDTH  -1:0] bsr_slr_next;
logic [BSR_WIDTH  -1:0] bsr_slr_ff;
logic                   bsr_upd_en;
logic [BSR_WIDTH  -1:0] bsr_upd_ff;
logic [BSR_WIDTH  -1:0] sample_sig;
logic [BSR_WIDTH  -1:0] prld_sig;
logic [NUMSTATES  -1:0] tap_state_ff;
logic [NUMSTATES  -1:0] tap_state_next;
logic [5:0]             tms_one_ctr_ff;

// TAP FSM description
always_ff @(posedge tck or negedge rst_n)
    if (~rst_n)
        tms_one_ctr_ff <= '1;
    else
        tms_one_ctr_ff <= tms ? ( tms_one_ctr_ff[5] ? tms_one_ctr_ff : tms_one_ctr_ff << 1)  : '1 ;
        
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
                                                                                                                                                                                                                       
always_ff @(posedge tck or negedge rst_n)
    if (~rst_n)
        tap_state_ff <= 1 ;
    else
        tap_state_ff <= tap_state_next;

// TAP instruction register

assign instr_slr_next = ( tap_state_ff[ST_CAPIR] | tap_state_ff[ST_RST] )? DESIGN_INST
                                                                         : tap_state_ff[ST_SHIR] ? {tdi, (instr_slr_ff >> 1)} 
                                                                                                 : instr_slr_ff;

always_ff @(posedge tck or negedge rst_n)
    if (~rst_n) begin
        instr_slr_ff <= 0;
        instr_upd_ff <= 0;
    end else begin
        instr_slr_ff <= instr_slr_next;
        instr_upd_ff <=  tap_state_ff[ST_UPDIR] ? instr_slr_ff : instr_upd_ff ;
    end


// TAP data registers and commands
assign sample_sig = {ram_wr, ram_din, ram_addr, ram_dout };
assign prld_sig   = {2'b0, ext_wr, ext_addr, ext_din};

assign bypass_sel = &(instr_upd_ff);
assign bypass_next  = ( tap_state_ff[ST_CAPDR] | tap_state_ff[ST_RST] ) ? 0 : ( tap_state_ff[ST_SHDR] ? tdi : bypass_ff );

assign bsr_slr_prld = ( instr_upd_ff == INST_SAMPLE ) ? sample_sig
                                                      : ( ( instr_upd_ff == INST_PRELOAD ) ? prld_sig
                                                                                           : bsr_slr_ff );
assign bsr_slr_next = tap_state_ff[ST_CAPDR] ? bsr_slr_prld
                                             : ( tap_state_ff[ST_SHDR] ? {tdi, (bsr_slr_ff >> 1)} 
                                                                       : ( tap_state_ff[ST_RST] ? '0 : bsr_slr_ff ) );

assign bsr_upd_en =  tap_state_ff[ST_UPDDR] & (( instr_upd_ff == INST_INTEST ) | ( instr_upd_ff == INST_EXTEST ));

assign bsr_sel = ( instr_upd_ff == INST_INTEST )
               | ( instr_upd_ff == INST_EXTEST ) 
               | ( instr_upd_ff == INST_SAMPLE )   
               | ( instr_upd_ff == INST_PRELOAD ); 
                                                                                 
always_ff @(posedge tck or negedge rst_n)
    if (~rst_n) begin
        bsr_slr_ff <= 0;
        bsr_upd_ff <= 0;
        bypass_ff  <= 0;
    end else begin
        bsr_slr_ff <= bsr_slr_next;
        bsr_upd_ff <= bsr_upd_en ? bsr_slr_ff : bsr_upd_ff ;
        bypass_ff  <= bypass_sel ? bypass_next : bypass_ff;
    end
    
assign tdo = &(instr_upd_ff) ? bypass_ff
                             : bsr_sel ? bsr_slr_ff[0]
                                       : ( instr_upd_ff == INST_IDCODE) ? idcode_ff[0] 
                                                                        : instr_slr_ff;
                                                                        
 
assign ram_din = (( instr_upd_ff == INST_INTEST ) & tap_state_ff[ST_RUN_IDLE]) ? bsr_upd_ff[1:0]
                                                                               : ext_din;
                                                                          
assign ram_addr = (( instr_upd_ff == INST_INTEST ) & tap_state_ff[ST_RUN_IDLE]) ? bsr_upd_ff[3:2]
                                                                                : ext_addr;
                                                                                
assign ram_wr = (( instr_upd_ff == INST_INTEST ) & tap_state_ff[ST_RUN_IDLE]) ? bsr_upd_ff[4]
                                                                              : ext_wr; 

assign ext_dout = (( instr_upd_ff == INST_EXTEST ) & tap_state_ff[ST_RUN_IDLE]) ? bsr_upd_ff[6:5]
                                                                                : ram_dout;
// add bufg_mux here for rams_wr                                                                              
dut dut_ram (
    .wr   (ram_wr_gated),
    .din  (ram_din),
    .dout (ram_dout),
    .addr (ram_addr)
);


endmodule