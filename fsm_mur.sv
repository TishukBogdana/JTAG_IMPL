`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ITMO University
// Engineer: BTishchuk
//
// Create Date: 12.12.2021 18:55:46
// Design Name: Mur Finite State machine
// Module Name: fsm_mur
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


module fsm_mur(
    input  logic clk,
    input  logic rst_n,
    input  logic [3:0] sig_in,
    output logic [3:0] state_o,
    input  logic       start_bist,
    input  logic       rst_state
    );

    logic [3:0] state_ff;
    logic [3:0] state_next;

    logic [15:0] state_en ;
    logic state_ch;
    assign state_en[0] = ( ( ~|sig_in[3:1])
                           | ( (sig_in == 4'b1000))
                           | ( (sig_in[3] & ~sig_in[1] & sig_in[0]))
                           | ( &sig_in) ) & ( state_ff == 4'b0000) ;

    assign state_en[1] = ( ( &sig_in )
                         | ( (sig_in == 4'b1011) )
                         | ( (sig_in == 4'b1100) )
                         | ( (sig_in == 4'b0010) ) ) & ( state_ff == 4'b0001) ;
                         
   assign state_en[2] = ( ( (sig_in == 4'b1011) )
                         | ( &sig_in )
                         | ( (sig_in == 4'b0110) )
                         | ( (~|sig_in[3:2] & ~sig_in[0]) )
                         | ( (sig_in == 4'b1100) ))  & ( state_ff == 4'b0010);  
                         
   assign state_en[3] =  ( ( (sig_in == 4'b1010))
                           | ( (sig_in == 4'b0110))) & ( state_ff == 4'b0011) ;   
                           
   assign state_en[4] =  ( ( &sig_in )
                            | ( (sig_in == 4'b0001))
                            | ( (sig_in == 4'b0101)) ) & ( state_ff == 4'b0100) ;     
                            
   assign state_en[5] = (  ( (sig_in == 4'b1100 )
                                 | ( sig_in == 4'b0011) )
                                 | ( &sig_in )
                                 | ( (sig_in == 4'b0010)) ) & ( state_ff == 4'b0101);

   assign state_en[6] =   ( ( (sig_in == 4'b0001) )
                             | ( (sig_in == 4'b0010) )
                             | ( (sig_in == 4'b0011) )
                             | ( (sig_in == 4'b1001) )
                             | ( (sig_in == 4'b1111) )
                             | ( (sig_in == 4'b1110) ) )  & ( state_ff == 4'b0110);     
                             
   assign state_en[7] =  (( ~|sig_in  )
                         | (&sig_in[3:2] & ~sig_in[0])
                         | (sig_in == 4'b0101)
                         | (sig_in == 4'b0011) ) & ( state_ff == 4'b0111) ;
                         
                         
   assign state_en[8] = (( (sig_in == 4'b1010))
                                 | ( (sig_in == 4'b1101) )
                                 | ( (sig_in == 4'b0011) )
                                 | ( (sig_in == 4'b1011) )
                                 | ( (sig_in == 4'b0010) ) ) & ( state_ff == 4'b1000)  ;  
                                 
                                 
   assign state_en[9] =  (  ( ~|sig_in )
                                 | ( (sig_in == 4'b0001))
                                 | ( (sig_in == 4'b1110))
                                 | ( (sig_in == 4'b1010)) ) & ( state_ff == 4'b1001) ;
  
   
   assign state_en[10] =  (( (sig_in == 4'b0011) )
                                 | ( &sig_in )
                                 | ( (sig_in == 4'b1010) )
                                 | ( (sig_in == 4'b0001) ) ) & ( state_ff == 4'b1010) ;  
   
   assign state_en[11] =  ( ( (sig_in == 4'b1010) )
                                 | ( (sig_in == 4'b0101) )
                                 | ( (sig_in == 4'b1101) )
                                 | ( (sig_in == 4'b1001) ) & ( state_ff == 4'b1011) );   
                                 
                                 
   assign state_en[12] =  (  ( (sig_in == 4'b1110))
                                 | ( (sig_in == 4'b1010) )
                                 | ( (sig_in == 4'b1001) )
                                 | ( &sig_in)
                                 | ( ~|sig_in ))  & ( state_ff == 4'b1100) ; 
   
   assign state_en[13] = ( ( (sig_in == 4'b0010))
                                 | ( (sig_in == 4'b0101))
                                 | ((sig_in == 4'b1001))
                                 | ( (sig_in == 4'b1110))
                                 | ( &sig_in ) ) & ( state_ff == 4'b1101) ;
                         
   assign state_en[14] = ( ( &sig_in)
                                 | ( (sig_in == 4'b1101) )
                                 | ( (&sig_in[3:2] & ~sig_in[0]) ))  & ( state_ff == 4'b1110) ;  
                                 
    assign state_en[15] = ( ((sig_in == 4'b1100) )
                                 | ((sig_in == 4'b1010) )
                                 | (~|sig_in )
                                 | ((sig_in[3:2] == 2'b01) )) & ( state_ff == 4'b1111) ;                                               
    
     always_comb begin
        case(state_ff)
            4'b0000 : state_next = ( {4{~|sig_in[3:1]}} & 4'b0010)
                                 | ( {4{(sig_in == 4'b1000)}} & 4'b0110)
                                 | ( {4{(sig_in[3] & ~sig_in[1] & sig_in[0])}} & 4'b1010)
                                 | ( {4{&sig_in}} & 4'b1101);

            4'b0001 : state_next = ( {4{&sig_in}} & 4'b0000)
                                 | ( {4{(sig_in == 4'b1011)}} & 4'b0011)
                                 | ( {4{(sig_in == 4'b1100)}} & 4'b1000)
                                 | ( {4{(sig_in == 4'b0010)}} & 4'b1011)
                                 | ( {4{(~state_en[1])}} & 4'b0001);

            4'b0010 : state_next = ( {4{(sig_in == 4'b1011)}} & 4'b0001)
                                 | ( {4{&sig_in}} & 4'b0101)
                                 | ( {4{(sig_in == 4'b0110)}} & 4'b0111)
                                 | ( {4{(~|sig_in[3:2] & ~sig_in[0])}} & 4'b1001)
                                 | ( {4{(sig_in == 4'b1100)}} & 4'b1110)
                                 | ( {4{(~state_en[2])}} & 4'b0010);

            4'b0011 : state_next = ( {4{(sig_in == 4'b1010)}} & 4'b0100)
                                 | ( {4{(sig_in == 4'b0110)}} & 4'b1111)
                                 | ( {4{(~state_en[3])}} & 4'b0011);

            4'b0100 : state_next = ( {4{&sig_in}} & 4'b0001)
                                 | ( {4{(sig_in == 4'b0001)}} & 4'b0111)
                                 | ( {4{(sig_in == 4'b0101)}} & 4'b1100)
                                 | ( {4{(~state_en[4])}} & 4'b0100);

            4'b0101 : state_next = ( {4{(sig_in == 4'b1100)}} & 4'b0000)
                                 | ( {4{(sig_in == 4'b0011)}} & 4'b0010)
                                 | ( {4{&sig_in}} & 4'b0100)
                                 | ( {4{(sig_in == 4'b0010)}} & 4'b1000)
                                 | ( {4{(~state_en[5])}} & 4'b0101);

            4'b0110 : state_next = ( {4{(sig_in == 4'b0001)}} & 4'b0001)
                                 | ( {4{(sig_in == 4'b0010)}} & 4'b0101)
                                 | ( {4{(sig_in == 4'b0011)}} & 4'b1000)
                                 | ( {4{(sig_in == 4'b1001)}} & 4'b1011)
                                 | ( {4{(sig_in == 4'b1111)}} & 4'b1110)
                                 | ( {4{(sig_in == 4'b1110)}} & 4'b1111)
                                 | ( {4{(~state_en[6])}} & 4'b0110);

            4'b0111 : state_next = ( {4{~|sig_in }} & 4'b0000)
                                 | ( {4{(&sig_in[3:2] & ~sig_in[0])}} & 4'b0010)
                                 | ( {4{(sig_in == 4'b0101)}} & 4'b0101)
                                 | ( {4{(sig_in == 4'b0011)}} & 4'b1010)
                                 | ( {4{(~state_en[7])}} & 4'b0111);

            4'b1000 : state_next = ( {4{(sig_in == 4'b1010)}} & 4'b0001)
                                 | ( {4{(sig_in == 4'b1101)}} & 4'b0011)
                                 | ( {4{(sig_in == 4'b0011)}} & 4'b0111)
                                 | ( {4{(sig_in == 4'b1011)}} & 4'b1011)
                                 | ( {4{(sig_in == 4'b0010)}} & 4'b1101)
                                 | ( {4{(~state_en[8])}} & 4'b1000);

            4'b1001 : state_next = ( {4{~|sig_in }} & 4'b0100)
                                 | ( {4{(sig_in == 4'b0001)}} & 4'b0110)
                                 | ( {4{(sig_in == 4'b1110)}} & 4'b1100)
                                 | ( {4{(sig_in == 4'b1010)}} & 4'b1110)
                                 | ( {4{(~state_en[9])}} & 4'b1001);

            4'b1010 : state_next = ( {4{(sig_in == 4'b0011)}} & 4'b0010)
                                 | ( {4{&sig_in}} & 4'b0101)
                                 | ( {4{(sig_in == 4'b1010)}} & 4'b1000)
                                 | ( {4{(sig_in == 4'b0001)}} & 4'b1101)
                                 | ( {4{(~state_en[10])}} & 4'b1010) ;

            4'b1011 : state_next = ( {4{(sig_in == 4'b1010)}} & 4'b0001)
                                 | ( {4{(sig_in == 4'b0101)}} & 4'b0100)
                                 | ( {4{(sig_in == 4'b1101)}} & 4'b1000)
                                 | ( {4{(sig_in == 4'b1001)}} & 4'b1110)
                                 | ( {4{(~state_en[11])}} & 4'b1011);

            4'b1100 : state_next = ( {4{(sig_in == 4'b1110)}} & 4'b0011)
                                 | ( {4{(sig_in == 4'b1010)}} & 4'b1001)
                                 | ( {4{(sig_in == 4'b1001)}} & 4'b0110)
                                 | ( {4{&sig_in}} & 4'b1011)
                                 | ( {4{~|sig_in}} & 4'b1110)
                                 | ( {4{(~state_en[12])}} & 4'b1100);

            4'b1101 : state_next = ( {4{(sig_in == 4'b0010)}} & 4'b0000)
                                 | ( {4{(sig_in == 4'b0101)}} & 4'b0010)
                                 | ( {4{(sig_in == 4'b1001)}} & 4'b0011)
                                 | ( {4{(sig_in == 4'b1110)}} & 4'b0101)
                                 | ( {4{&sig_in}} & 4'b1010)
                                 | ( {4{(~state_en[13])}} & 4'b1101);

            4'b1110 : state_next = ( {4{&sig_in}} & 4'b0001)
                                 | ( {4{(sig_in == 4'b1101)}} & 4'b0100)
                                 | ( {4{(&sig_in[3:2] & ~sig_in[0])}} & 4'b0111)
                                 | ( {4{(~state_en[14])}} & 4'b1110);

            4'b1111 : state_next = ({4{(sig_in == 4'b1100)}} & 4'b0011)
                                 | ({4{(sig_in == 4'b1010)}} & 4'b0110)
                                 | ({4{~|sig_in}} & 4'b1010)
                                 | ({4{(sig_in[3:2] == 2'b01)}} & 4'b1100)
                                 | ( {4{(~state_en[15])}} & 4'b1111);

            default : state_next ='0;
        endcase
    end

assign state_ch = (|state_en);
    always_ff @(posedge clk or negedge rst_n)
      if (~rst_n)
        state_ff <= '0;
      else 
        state_ff <= (start_bist | rst_state) ? '0 : state_next;

assign state_o = state_ff;

endmodule
