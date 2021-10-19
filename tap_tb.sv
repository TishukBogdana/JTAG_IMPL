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

localparam INSTR_SEQ = 32'b011010010001110100100011011111; 
localparam IDCODE_SEQ = 64'b0110000000000000000000000000000000010; 
localparam BYPASS_SEQ = 32'b0110000111000011;
localparam INTEST_SEQ = 32'b011000000111000011;
localparam SAMPLE_SEQ = 32'b011000000111000011;
localparam PRELOAD_SEQ = 32'b0110111000011;
localparam EXTEST_SEQ = 32'b0110111000011;

logic rst_n;
logic clk;
logic tck;
logic tdi;
logic tdo;
logic tms;
logic [1:0] ext_addr;
logic [1:0] ext_din;
logic ext_wr;
logic finish1;
logic [63:0] tms_seq;


initial begin
 clk = 0;
  tck = 0; 
  tms_seq = INSTR_SEQ;
  ext_addr = 0;
  ext_din = 2'b11;
  ext_wr = 0;
  rst_n = 1;
  tms = 1;
  #2 rst_n = 0;
  
  #18 rst_n = 1;
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
  
  $display ("TAP Bypass finished %t", $time);
  
  tms_seq = BYPASS_SEQ ;
  for (int  i = 0; i < 16 ; i ++ ) begin
    tms = tms_seq;
    tdi = 0;
    tms_seq = tms_seq >> 1;
    if ( ( i >= 4) && (i <= 6 )) tdi = 1 ;
    if ( i == 11) tdi = 1 ;
    if ( i == 12) tdi = 0 ;
    if ( i == 13) tdi = 1 ;
    #20 ;
  end
  $display ("TAP Bypass finished %t", $time);
   
  tms_seq = INTEST_SEQ ;
  for (int  i = 0; i < 18 ; i ++ ) begin
    tms = tms_seq;
    tdi = 0;
    tms_seq = tms_seq >> 1;
    if ( i == 4)  tdi = 0;
    if ( i == 5)  tdi = 0;
    if ( i == 6)  tdi = 1;
    
    if ( i == 11) tdi = 1 ;
    if ( i == 12) tdi = 0 ;
    if ( i == 13) tdi = 1 ;
    if ( i == 14) tdi = 1 ;
    if ( i == 15) tdi = 1 ;
    #20 ;
  end
  $display ("TAP Intest finished %t", $time);
  
  ext_addr = 2'b11;
  ext_din = 0;
  ext_wr = 0;
  
  tms_seq = SAMPLE_SEQ ;
  for (int  i = 0; i < 18 ; i ++ ) begin
    tms = tms_seq;
    tdi = 0;
    tms_seq = tms_seq >> 1;
    if ( i == 4)  tdi = 0;
    if ( i == 5)  tdi = 1;
    if ( i == 6)  tdi = 0;
    
  
    #20 ;
  end
  $display ("TAP Sample finished %t", $time);
  
    ext_addr = 2'b11;
    ext_din = 2'b10;
    ext_wr = 0;
    tms_seq = PRELOAD_SEQ ;
  for (int  i = 0; i < 13 ; i ++ ) begin
    tms = tms_seq;
    tdi = 0;
    tms_seq = tms_seq >> 1;
    if ( i == 4)  tdi = 1;
    if ( i == 5)  tdi = 1;
    if ( i == 6)  tdi = 0;
    
  
    #20 ;
  end
  $display ("TAP Preload finished %t", $time);
  
  tms_seq = EXTEST_SEQ ;
  for (int  i = 0; i < 13 ; i ++ ) begin
    tms = tms_seq;
    tdi = 0;
    tms_seq = tms_seq >> 1;
    if ( i == 4)  tdi = 1;
    if ( i == 5)  tdi = 0;
    if ( i == 6)  tdi = 1;
    
  
    #20 ;
  end
  $display ("TAP EXTEST finished %t", $time);
  
  #20 ;
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
    .ext_addr (ext_addr),
    .ext_din (ext_din),
    .ext_wr (ext_wr),
    .ext_dout ());
    
endmodule
