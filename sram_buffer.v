`timescale 1ns / 1ps
`include "param.v"

module sram_buffer #(parameter WIDTH=`BIT_DATA) (clka, ena, wea, douta, douta_buf);
input clka, ena, wea;
input [WIDTH-1:0] douta;
output [WIDTH-1:0] douta_buf;

reg [WIDTH-1:0] r_douta_buf;
// reg ena_buf;

assign douta_buf = r_douta_buf;

always @(posedge clka) begin
    // ena_buf <= ena & ~wea;
    if (ena & ~wea)
        r_douta_buf <= douta;
    else
        r_douta_buf <= 0;
end
endmodule