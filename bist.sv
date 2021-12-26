`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 12.12.2021 18:56:26
// Design Name:
// Module Name: bist
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module bist #(
parameter MEMSIZE = 128
)
(
  input  logic        clk,
  input  logic        rst_n,
  input  logic        tst_start_i,
  input  logic [3:0]  state_i,
  output logic [3:0]  drive_o,
  output logic        success_o,
  output logic [6:0]  duration_o,
  
  // RAM IF
  input logic mem_we_i,
  input logic [$clog2(MEMSIZE) -1 : 0] mem_addr_i,
  input logic [7 : 0] mem_data_i,
  output logic [7:0] mem_data_o,
  input logic start_addr_cfg_i,
  input logic [$clog2(MEMSIZE) -1 : 0] start_addr_i,
  
  input logic dur_cfg_i,
  input logic [$clog2(MEMSIZE) -1 : 0] duration_i,
  
  // Fault description
  output logic [3:0] fault_state_o,
  output logic [3:0] fault_trans_o,
  output logic [3:0] fault_drive_o,
  output logic [3:0] fault_ref_o
    );


logic [$clog2(MEMSIZE) -1 : 0] start_addr_ff;
logic [$clog2(MEMSIZE) -1 : 0] duration_ff;
logic bist_proc_ff;
logic bist_proc_del_ff;
logic [3:0] drive;
logic [3:0] ref_val_ff;
logic [7:0] ram_data;

logic [3:0] lstate_ff;
logic [3:0] ldrive_ff;

logic [$clog2(MEMSIZE) -1:0] ram_addr;
(* mark_debug = "true" *) logic  success_ff;
(* mark_debug = "true" *) logic  success_next;
logic [6:0] ctr_ff;
(* mark_debug = "true" *) logic [6:0] ctr;
logic bist_finish_ff;


// Fault
  logic [3:0] fault_state_ff;
  logic [3:0] fault_trans_ff;
  logic [3:0] fault_drive_ff;
  logic [3:0] fault_ref_ff;
  
 assign ram_addr = bist_proc_ff ? start_addr_ff + ctr  : mem_addr_i  ; 
 ram 
  #(
    .dat_width (8), 
    .adr_width (7), 
    .mem_size  (128)
  ) i_ram (
    .dat_i (mem_data_i),
    .adr_i (ram_addr),
    .we_i  (mem_we_i),
    .dat_o (ram_data),
    .clk   (clk)
  ); 

// Control logic
always_ff @(posedge clk or negedge rst_n)
    if (~rst_n) begin
        bist_proc_ff <= '0;
        ctr_ff <= '0;
        start_addr_ff <= '0;
        duration_ff   <= 93;
        bist_proc_del_ff <= '0;
    end else begin
        bist_proc_del_ff <= bist_proc_ff;
        start_addr_ff <= start_addr_cfg_i ? start_addr_i : start_addr_ff;
        duration_ff   <= dur_cfg_i ? duration_i : duration_ff;
        bist_proc_ff  <= tst_start_i ? '1 : ( (ctr_ff < duration_ff ) & success_ff);
        ctr_ff  <= tst_start_i ? '0 : ((ctr_ff >= duration_ff )? ctr_ff : ctr_ff + 1);
    end


assign ctr = (ctr_ff == duration_ff)? '0 : ctr_ff;

always_ff @(posedge clk )
    ref_val_ff <= ram_data[3:0];

assign drive = ram_data[7:4];


always_ff @(posedge clk )
    if (bist_proc_ff) begin
        lstate_ff <= state_i;
        ldrive_ff <= drive;
    end
    

  always_ff @(posedge clk)
    if(tst_start_i)
      success_ff <= 1;
    else if( (ctr_ff > 1) & bist_proc_ff  )
      success_ff <= (success_ff & (ref_val_ff == state_i ));

 

always_ff @(posedge clk)
    if (tst_start_i) begin
      fault_state_ff <= '0;
      fault_trans_ff <= '0;
      fault_drive_ff <= '0;
      fault_ref_ff   <= '0;
    end else if ( success_ff & (ref_val_ff != state_i)) begin
      fault_state_ff <= lstate_ff;
      fault_trans_ff <= state_i;
      fault_drive_ff <= ldrive_ff;
      fault_ref_ff   <= ref_val_ff;
    end

   assign fault_state_o = fault_state_ff;
   assign fault_trans_o = fault_trans_ff;
   assign fault_drive_o = fault_drive_ff;
   assign fault_ref_o   = fault_ref_ff;
  
assign success_o  = &success_ff;
assign drive_o = drive;
assign duration_o = ctr_ff;
assign mem_data_o = ram_data;
endmodule
