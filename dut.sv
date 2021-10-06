`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Bogdana Tishchuk
// 
// Create Date: 02.10.2021 16:32:04
// Design Name: testable RAM
// Module Name: dut
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


module dut #(
    parameter DEPTH = 4,
    parameter WIDTH = 2,
    parameter AWIDTH = $clog2(DEPTH)
)(  
    input logic                wr,
    input logic [WIDTH   -1:0] din,
    input logic [WIDTH   -1:0] dout,
    input logic [AWIDTH -1: 0] addr
    );
    
    logic [WIDTH -1:0] ram_cell_ff [DEPTH -1:0];
    
    always_ff @(posedge wr)
        ram_cell_ff[addr] <= din;
        
    assign dout = ram_cell_ff[addr];
    
endmodule
