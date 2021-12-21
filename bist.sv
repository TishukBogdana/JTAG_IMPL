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


module bist(
  input  logic        clk,
  input  logic        rst_n,
  input  logic        tst_start_i,
  input  logic        pattern_sel_i,
  input  logic [3:0]  state_i,
  output logic [3:0]  drive_o,
  output logic        success_o,
  output logic [4:0]  duration_o
    );

localparam STOP = 92;

logic [3:0] drive_ff;
logic [3:0] ref_val;

logic [3:0] force_state_next;

logic [3:0] tst_val [0:128] ={4'b1000, 4'b0001, 4'b1111, 4'b0001, 4'b1011, 4'b1011,
                              4'b1010, 4'b1111, 4'b1100, 4'b1010, 4'b0010, 4'b1010,
                              4'b1111, 4'b1001, 4'b0011, 4'b1111, 4'b1100, 4'b1111,
                              4'b0010, 4'b0000, 4'b0110, 4'b0000, 4'b0001, 4'b0010,
                              4'b0000, 4'b0001, 4'b1110, 4'b1100, 4'b1101, 4'b0101,
                              4'b1001, 4'b0010, 4'b1111, 4'b0101, 4'b1110, 4'b0110,
                              4'b1100, 4'b0110, 4'b1010, 4'b0011, 4'b1101, 4'b1010,
                              4'b0001, 4'b0101, 4'b0010, 4'b0011, 4'b0101, 4'b0011,
                              4'b0000, 4'b0001, 4'b1001, 4'b0101, 4'b0101, 4'b1010,
                              4'b1110, 4'b1111, 4'b1101, 4'b1011, 4'b1001, 4'b1110,
                              4'b0011, 4'b1111, 4'b0010, 4'b0010, 4'b0101, 4'b1111,
                              4'b1000, 4'b1111, 4'b1111, 4'b1100, 4'b0010, 4'b1001,
                              4'b0110, 4'b0000, 4'b0001, 4'b1110, 4'b0010, 4'b0010,
                              4'b1111, 4'b0001, 4'b1001, 4'b0110, 4'b0111, 4'b1111,
                              4'b1101, 4'b0011, 4'b1100, 4'b0010, 4'b1010, 4'b1101,
                              4'b0101, 4'b0000};

logic [3:0] check_val [0:16] = {4'b0110, 4'b0001, 4'b0000, 4'b0010, 4'b0001, 4'b0011,
                                4'b0100, 4'b0001, 4'b1000, 4'b0001, 4'b1011, 4'b0001,
                                4'b0000, 4'b1010, 4'b0010, 4'b0101, 4'b0000, 4'b1101,
                                4'b0000, 4'b0010, 4'b0111, 4'b0000, 4'b0010, 4'b1001,
                                4'b0100, 4'b0111, 4'b0010, 4'b1110, 4'b0100, 4'b1100,
                                4'b0110, 4'b0101, 4'b0100, 4'b1100, 4'b0011, 4'b1111,
                                4'b0011, 4'b1111, 4'b0100, 4'b1000, 4'b0011, 4'b0100,
                                4'b0111, 4'b0101, 4'b1000, 4'b0111, 4'b0101, 4'b0010,
                                4'b1001, 4'b0110, 4'b1011, 4'b0100, 4'b1100, 4'b1001,
                                4'b1100, 4'b1011, 4'b1000, 4'b1011, 4'b1110, 4'b0111,
                                4'b1010, 4'b0101, 4'b1000, 4'b1101, 4'b0001, 4'b0000,
                                4'b0110, 4'b1110, 4'b0001, 4'b1000, 4'b1101, 4'b0011,
                                4'b1111, 4'b1010, 4'b1101, 4'b0101, 4'b1000, 4'b1101,
                                4'b1010, 4'b1101, 4'b0011, 4'b1111, 4'b1100, 4'b1011,
                                4'b1000, 4'b0111, 4'b0010, 4'b1001, 4'b1110, 4'b0100,
                                4'b1100, 4'b1110} ;

logic [16:0] success_ff;
logic [4:0] ctr_ff;
logic [4:0] ref_ptr;
logic bist_finish_ff;
logic pattern_ff;

assign ref_ptr = |ctr_ff ? ctr_ff -1 : ctr_ff;
assign ref_val = pattern_ff ? check_val1[ref_ptr] : check_val[ref_ptr];

always_ff @(posedge clk or negedge rst_n)
    if (~rst_n) begin
        bist_finish_ff <= '0;
        ctr_ff <= '0;
        pattern_ff <='0;
    end else begin
        pattern_ff <= tst_start_i ? pattern_sel_i : pattern_ff;
        bist_finish_ff <= tst_start_i ? '0 : (ctr_ff >= 17 );
        ctr_ff  <= tst_start_i ? '0 : ((ctr_ff >= 17 )? ctr_ff : ctr_ff + 1);
    end

always_ff @(posedge clk or negedge rst_n)
  if (~rst_n)
    drive_ff <= '0;
  else if (tst_start_i)
    drive_ff <= pattern_sel_i ? tst_val1[0] : tst_val[0];
  else if (ctr_ff < 17)
    drive_ff <= pattern_sel_i ? tst_val1[ctr_ff] : tst_val[ctr_ff];

for (genvar ii = 0; ii < 17; ii = ii + 1) begin : g_success
  always_ff @(posedge clk)
    if(tst_start_i)
      success_ff[ii] <= 0;
    else if(|ctr_ff & ~bist_finish_ff )
      success_ff[ii] <= (ii == (ctr_ff - 1)) ? (ref_val == state_i ) : success_ff[ii] ;
end

assign success_o  = &success_ff;
assign drive_o = drive_ff;
assign duration_o = ctr_ff;
endmodule
