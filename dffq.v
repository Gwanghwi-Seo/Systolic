`include "./param.v"


module dffq #(parameter WIDTH=`BIT_DATA) (CLK, D, Q);
input CLK;
input [WIDTH-1:0] D;
output reg [WIDTH-1:0] Q;
always @(posedge CLK) begin
    Q <= D;
end
endmodule