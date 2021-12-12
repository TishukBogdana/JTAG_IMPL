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
    input  logic [3:0]  sig_in,
    output logic [3:0] state_o,
    //! add test ports
    );

    logic [3:0] state_ff;
    logic [3:0] state_next;

    always_comb begin
        case(state_ff)
            4'b0000 : state_next = ( {4{~|sig_in[3:1]}} & 4'b0010)
                                 | ( {4{(sig_in == 4'b1000)}} & 4'b0110)
                                 | ( {4{(sig_in[3] & ~sig_in[1] & sig_in[0])}} & 4'b1010)
                                 | ( {4{&sig_in}} & 4'b1101);

            4'b0001 : state_next = ( {4{&sig_in}} & 4'b0000)
                                 | ( {4{(sig_in == 4'b1011)}} & 4'b0011)
                                 | ( {4{(sig_in == 4'b1100)}} & 4'b1000)
                                 | ( {4{(sig_in == 4'b0010)}} & 4'b1011);

            4'b0010 : state_next = ( {4{(sig_in == 4'b1011)}} & 4'b0001)
                                 | ( {4{&sig_in}} & 4'b0101)
                                 | ( {4{(sig_in == 4'b0110)}} & 4'b0111)
                                 | ( {4{(~|sig_in[3:2] & ~sig_in[0])}} & 4'b1001)
                                 | ( {4{(sig_in == 4'b1100)}} & 4'b1110);

            4'b0011 : state_next = ( {4{(sig_in == 4'b1010)}} & 4'b0100)
                                 | ( {4{(sig_in == 4'b0110)}} & 4'b1111);

            4'b0100 : state_next = ( {4{&sig_in}} & 4'b0001)
                                 | ( {4{(sig_in == 4'b0001)}} & 4'b0111)
                                 | ( {4{(sig_in == 4'b0101)}} & 4'b1100);

            4'b0101 : state_next = ( {4{(sig_in == 4'b1100)}} & 4'b0000)
                                 | ( {4{(sig_in == 4'b0011)}} & 4'b0010)
                                 | ( {4{&sig_in}} & 4'b0100)
                                 | ( {4{(sig_in == 4'b0010)}} & 4'b1000);

            4'b0110 : state_next = ( {4{(sig_in == 4'b0001)}} & 4'b0001)
                                 | ( {4{(sig_in == 4'b0010)}} & 4'b0101)
                                 | ( {4{(sig_in == 4'b1001)}} & 4'b1011)
                                 | ( {4{(sig_in == 4'b1111)}} & 4'b1110)
                                 | ( {4{(sig_in == 4'b1110)}} & 4'b1111);

            4'b0111 : state_next = ( {4{~|sig_in }} & 4'b0000)
                                 | ( {4{(&sig_in[3:2] & ~sig_in[0])}} & 4'b0010)
                                 | ( {4{(sig_in == 4'b0101)}} & 4'b0101)
                                 | ( {4{(sig_in == 4'b0011)}} & 4'b1010);

            4'b1000 : state_next = ( {4{(sig_in == 4'b1010)}} & 4'b0001)
                                 | ( {4{(sig_in == 4'b1101)}} & 4'b0011)
                                 | ( {4{(sig_in == 4'b0011)}} & 4'b0111)
                                 | ( {4{(sig_in == 4'b1011)}} & 4'b1011)
                                 | ( {4{(sig_in == 4'b0010)}} & 4'b1101);

            4'b1001 : state_next = ( {4{~|sig_in }} & 4'b0100)
                                 | ( {4{(sig_in == 4'b0001)}} & 4'b0110)
                                 | ( {4{(sig_in == 4'b1110)}} & 4'b1100)
                                 | ( {4{(sig_in == 4'b1010)}} & 4'b1110);

            4'b1010 : state_next = ( {4{(sig_in == 4'b0011)}} & 4'b0100)
                                 | ( {4{&sig_in}} & 4'b0101)
                                 | ( {4{(sig_in == 4'b1010)}} & 4'b1000)
                                 | ( {4{(sig_in == 4'b0001)}} & 4'b1101);

            4'b1011 : state_next = ( {4{(sig_in == 4'b1010)}} & 4'b0001)
                                 | ( {4{(sig_in == 4'b0101)}} & 4'b0100)
                                 | ( {4{(sig_in == 4'b1101)}} & 4'b1000)
                                 | ( {4{(sig_in == 4'b1001)}} & 4'b1110);

            4'b1100 : state_next = ( {4{(sig_in == 4'b1110)}} & 4'b0011)
                                 | ( {4{(sig_in == 4'b1001)}} & 4'b0110)
                                 | ( {4{&sig_in}} & 4'b1011)
                                 | ( {4{~|sig_in}} & 4'b1110);

            4'b1101 : state_next = ( {4{(sig_in == 4'b0010)}} & 4'b0000)
                                 | ( {4{(sig_in == 4'b0101)}} & 4'b0010)
                                 | ( {4{(sig_in == 4'b1001)}} & 4'b0011)
                                 | ( {4{(sig_in == 4'b1110)}} & 4'b0101)
                                 | ( {4{&sig_in}} & 4'b1010);

            4'b1110 : state_next = ( {4{&sig_in}} & 4'b0001)
                                 | ( {4{(sig_in == 4'b1101)}} & 4'b0100)
                                 | ( {4{(&sig_in[3:2] & ~sig_in[0])}} & 4'b0111);

            4'b1110 : state_next = ({4{(sig_in == 4'b1100)}} & 4'b0011)
                                 | ({4{(sig_in == 4'b1010)}} & 4'b0110)
                                 | ({4{~|sig_in}} & 4'b1010)
                                 | ({4{(sig_in[3:2] == 2'b01)}} & 4'b1100);
        endcase
    end

    always_ff @(posedge clk or negedge rst_n)
      if (~rst_n)
        state_ff <= '0;
      else
        state_ff <= state_next;


endmodule
