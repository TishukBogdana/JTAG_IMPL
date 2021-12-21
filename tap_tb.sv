`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.10.2021 20:43:50
// Design Name: 
// Module Name: tap_tb
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


module tap_tb();

localparam INSTR_SEQ      = 32'b011010010001110100100011011111; 
localparam IDCODE_SEQ     = 64'b0110000000000000000000000000000000010; 
localparam BYPASS_SEQ     = 32'b0110000111000011;
localparam INTEST_SEQ_RST = 32'b01100011100000011;
localparam INTEST_SEQ     = 32'b011000000011100000011;
localparam SAMPLE_SEQ     = 32'b011000000011100000011;
localparam PRELOAD_SEQ    = 32'b011011100000011;
localparam EXTEST_SEQ     = 32'b01100000011;
localparam BIST_SEQ       = 32'b01100011100000011;
localparam CAPT_DR_SEQ    = 5'b01101;

logic rst_n;
logic clk;
logic tck;
logic tdi;
logic tdo;
logic tms;

logic [3:0] ext_din;
logic finish1;
logic [63:0] tms_seq;


initial begin
 clk = 0;
  tck = 0; 
  tms_seq = INSTR_SEQ;
  ext_din = 4'b1111;
  rst_n = 1;
  tms = 1;
  #2 rst_n = 0;
  rst_n = 0;
  #18 rst_n = 1;
  rst_n = 1;
//  for (int  i = 0; i < 32 ; i ++ ) begin
  
//    tms = tms_seq[0];
//    tdi = 1;
//    tms_seq = tms_seq >> 1;
//      #20 ;
//  end  
//  $display ("TAP state test finished %t", $time);
  tms_seq = IDCODE_SEQ ;
  for (int  i = 0; i < 38 ; i ++ ) begin
    tms = tms_seq;
    tdi = 0;
    tms_seq = tms_seq >> 1;
    #20 ;
  end
  
  $display ("TAP IDCODE finished %t", $time);
  
//  tms_seq = BYPASS_SEQ ;
//  for (int  i = 0; i < 16 ; i ++ ) begin
//    tms = tms_seq;
//    tdi = 0;
//    tms_seq = tms_seq >> 1;
//    if ( ( i >= 3) && (i <= 5 )) tdi = 1 ;
//    if ( i == 10) tdi = 1 ;
//    if ( i == 11) tdi = 0 ;
//    if ( i == 12) tdi = 1 ;
//    #20 ;
//  end
//  $display ("TAP Bypass finished %t", $time);
   
  tms_seq = INTEST_SEQ_RST ;
  for (int  i = 0; i < 17 ; i ++ ) begin
    tms = tms_seq[i];
    tdi = 0;
    if ( i == 6)  tdi = 1;
   
    if ( i == 13) tdi = 1 ;
    if ( i == 14) tdi = 1 ;
    
    #20 ;
  end
  
  $display ("TAP FSM RST finished %t", $time);
  
  // ----------------------------------
  tms_seq = INTEST_SEQ_RST ;
  for (int  i = 0; i < 17 ; i ++ ) begin
    tms = tms_seq[i];
    tdi = 0;
    if ( i == 6)  tdi = 1;
    #20 ;
  end
  
  $display ("TAP FSM RST finished %t", $time);
  
  tms_seq = INTEST_SEQ ;
  for (int  i = 0; i < 21 ; i ++ ) begin
    tms = tms_seq[i];
    tdi = 0;
    if ( i == 6)  tdi = 1;
   
    if ( i == 16) tdi = 1 ;
    if ( i == 17) tdi = 1 ;
    
    #20 ;
  end
  
  // ----------------------------------
  tms_seq = INTEST_SEQ_RST ;
  for (int  i = 0; i < 17 ; i ++ ) begin
    tms = tms_seq[i];
    tdi = 0;
    if ( i == 6)  tdi = 1;
    #20 ;
  end
  
  tms_seq = INTEST_SEQ ;
  for (int  i = 0; i < 21 ; i ++ ) begin
    tms = tms_seq;
    tdi = 0;
    tms_seq = tms_seq >> 1;
 
    if ( i == 6)  tdi = 1;
  
    if ( i == 13) tdi = 1 ;
    if ( i == 16) tdi = 1 ;
    if ( i == 17) tdi = 1 ;
    #20 ;
  end
  $display ("TAP Intest finished %t", $time);
  
  
    // ----------------------------------
  tms_seq = INTEST_SEQ_RST ;
  for (int  i = 0; i < 17 ; i ++ ) begin
    tms = tms_seq[i];
    tdi = 0;
    if ( i == 6)  tdi = 1;
    #20 ;
  end
  
  
  tms_seq = INTEST_SEQ ;
  for (int  i = 0; i < 21 ; i ++ ) begin
    tms = tms_seq;
    tdi = 0;
    tms_seq = tms_seq >> 1;
 
    if ( i == 6)  tdi = 1;
  
    if ( i == 13) tdi = 1 ;
    if ( i == 16) tdi = 1 ;
    if ( i == 17) tdi = 1 ;
    #20 ;
  end
  $display ("TAP Intest finished %t", $time);
  
  ext_din = 4'b1111;
  tms_seq = SAMPLE_SEQ ;
  for (int  i = 0; i < 21 ; i ++ ) begin
    tms = tms_seq;
    tdi = 0;
    tms_seq = tms_seq >> 1;
    if ( i == 5)  tdi = 1; 
    #20 ;
  end
  $display ("TAP Sample finished %t", $time);
  
    ext_din = 4'b1111;
 
    tms_seq = PRELOAD_SEQ ;
  for (int  i = 0; i < 15 ; i ++ ) begin
    tms = tms_seq;
    tdi = 0;
    tms_seq = tms_seq >> 1;
    
    if ( i == 4)  tdi = 1; 
    if ( i == 5)  tdi = 1; 
    #20 ;
  end
  $display ("TAP Preload finished %t", $time);
  
  tms_seq = EXTEST_SEQ ;
  for (int  i = 0; i < 11 ; i ++ ) begin
    tms = tms_seq;
    tdi = 0;
    tms_seq = tms_seq >> 1;
    if ( i == 4)  tdi = 1;
    if ( i == 5)  tdi = 0;
    if ( i == 6)  tdi = 1;
    
  
    #20 ;
  end
  $display ("TAP EXTEST finished %t", $time);
  
  
  tms_seq = BIST_SEQ ;
  for (int  i = 0; i < 17 ; i ++ ) begin
    tms = tms_seq;
    tdi = 0;
    tms_seq = tms_seq >> 1;
    if ( i == 4)  tdi = 1;
    if ( i == 5)  tdi = 1;
    if ( i == 6)  tdi = 1;
    
    
    if ( i == 13) tdi = 0 ;
    if ( i == 14) tdi = 1 ;
    #20 ;
  end
  $display ("TAP BIST finished %t", $time);
  
  
  #700 ;        
  
  tms_seq = CAPT_DR_SEQ ;
  for (int  i = 0; i < 6 ; i ++ ) begin
    tms = tms_seq;
    tdi = 0;
    tms_seq = tms_seq >> 1;
    #20 ;
  end
  $display ("TAP BIST finished %t", $time);
      
  tms_seq = BIST_SEQ ;
  for (int  i = 0; i < 17 ; i ++ ) begin
    tms = tms_seq;
    tdi = 0;
    tms_seq = tms_seq >> 1;
    if ( i == 4)  tdi = 1;
    if ( i == 5)  tdi = 1;
    if ( i == 6)  tdi = 1;
    
    
    if ( i == 13) tdi = 1 ;
    if ( i == 14) tdi = 1 ;
    #20 ;
  end
  $display ("TAP BIST finished %t", $time);
  
  
  #700 ;        
  
  tms_seq = CAPT_DR_SEQ ;
  for (int  i = 0; i < 6 ; i ++ ) begin
    tms = tms_seq;
    tdi = 0;
    tms_seq = tms_seq >> 1;
    #20 ;
  end
  $display ("TAP BIST finished %t", $time);
  
               
  $finish();
end     

always 
    #10 tck = ~tck;

always 
    #5 clk = ~clk;

//always 
   // #20 ext_wr = ~ext_wr;
            
 tap i_tap(
    .rst_n (rst_n), // Async reset
    .clk   (clk), // system clock 
    .tck   (tck),
    .tdi   (tdi),
    .tms   (tms),
    .tdo   (tdo),
    .ext_din (ext_din),
    .ext_state ());
 
//  fsm_mur tmur(
//    .clk (clk),
//    .rst_n (rst_n),
//    .sig_in (drive_ff),
//    .state_o () ,
//    .tmode_i ('0),
//    .tmode_clk_en ('0),
//    .start_bist ('0),
//    .rst_state ('0)
//    );
       
endmodule
