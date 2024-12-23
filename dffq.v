`include "./param.v"


module dffq #(parameter WIDTH=`BIT_DATA) (CLK, D, Q);
input CLK;
input [WIDTH-1:0] D;
output reg [WIDTH-1:0] Q;
always @(posedge CLK) begin
    Q <= D;
end
endmodule

module DLY_HOLD #(parameter WIDTH=32) (A, Y);
input   [WIDTH-1:0]     A;
output  [WIDTH-1:0]     Y;
wire    [WIDTH-1:0]     B;

genvar i;
generate
for (i=0;i<WIDTH;i=i+1) begin: DLY_HOLD_loop
        DLY4_X0P5M_A9TR DLY_MODULE_1 ( .A(A[i]), .Y(B[i]) );
        DLY4_X0P5M_A9TR DLY_MODULE_2 ( .A(B[i]), .Y(Y[i]) );
end
endgenerate

endmodule

`ifndef RTL_SIM

    // INV *2
    module Inverter_chain_for_sim_2 #(parameter WIDTH=32) (A, Y);
    input   [WIDTH-1:0]     A;
    output  [WIDTH-1:0]     Y;
    wire    [WIDTH-1:0]     IM1; // intermediate wire

    genvar i;
    generate
    for (i=0;i<WIDTH;i=i+1) begin: Inverter_chain_2_loop
            assign IM1[i]    = ~A[i];
            assign Y[i]      = ~IM1[i];
    end
    endgenerate

    endmodule



    // INV *4
    module Inverter_chain_for_sim_4 #(parameter WIDTH=32) (A, Y);
    input   [WIDTH-1:0]     A;
    output  [WIDTH-1:0]     Y;
    wire    [WIDTH-1:0]     IM1; // intermediate wire

    Inverter_chain_for_sim_2 #( .WIDTH(WIDTH) ) Inverter_chain_4_loop_1 ( .A(A),     .Y(IM1) );
    Inverter_chain_for_sim_2 #( .WIDTH(WIDTH) ) Inverter_chain_4_loop_2 ( .A(IM1),   .Y(Y) );

    endmodule



    // INV *6
    module Inverter_chain_for_sim_6 #(parameter WIDTH=32) (A, Y);
    input   [WIDTH-1:0]     A;
    output  [WIDTH-1:0]     Y;
    wire    [WIDTH-1:0]     IM1, IM2; // intermediate wire

    Inverter_chain_for_sim_2 #( .WIDTH(WIDTH) ) Inverter_chain_6_loop_1 ( .A(A),     .Y(IM1) );
    Inverter_chain_for_sim_2 #( .WIDTH(WIDTH) ) Inverter_chain_6_loop_2 ( .A(IM1),   .Y(IM2) );
    Inverter_chain_for_sim_2 #( .WIDTH(WIDTH) ) Inverter_chain_6_loop_3 ( .A(IM2),   .Y(Y) );

    endmodule



    // INV *8
    module Inverter_chain_for_sim_8 #(parameter WIDTH=32) (A, Y);
    input   [WIDTH-1:0]     A;
    output  [WIDTH-1:0]     Y;
    wire    [WIDTH-1:0]     IM1, IM2, IM3; // intermediate wire

    Inverter_chain_for_sim_2 #( .WIDTH(WIDTH) ) Inverter_chain_8_loop_1 ( .A(A),     .Y(IM1) );
    Inverter_chain_for_sim_2 #( .WIDTH(WIDTH) ) Inverter_chain_8_loop_2 ( .A(IM1),   .Y(IM2) );
    Inverter_chain_for_sim_2 #( .WIDTH(WIDTH) ) Inverter_chain_8_loop_3 ( .A(IM2),   .Y(IM3) );
    Inverter_chain_for_sim_2 #( .WIDTH(WIDTH) ) Inverter_chain_8_loop_4 ( .A(IM3),   .Y(Y) );

    endmodule

    // INV *12
    module Inverter_chain_for_sim_12 #(parameter WIDTH=32) (A, Y);
    input   [WIDTH-1:0]     A;
    output  [WIDTH-1:0]     Y;
    wire    [WIDTH-1:0]     IM1, IM2, IM3, IM4, IM5; // intermediate wire

    Inverter_chain_for_sim_2 #( .WIDTH(WIDTH) ) Inverter_chain_12_loop_1 ( .A(A),     .Y(IM1) );
    Inverter_chain_for_sim_2 #( .WIDTH(WIDTH) ) Inverter_chain_12_loop_2 ( .A(IM1),   .Y(IM2) );
    Inverter_chain_for_sim_2 #( .WIDTH(WIDTH) ) Inverter_chain_12_loop_3 ( .A(IM2),   .Y(IM3) );
    Inverter_chain_for_sim_2 #( .WIDTH(WIDTH) ) Inverter_chain_12_loop_4 ( .A(IM3),   .Y(IM4) );
    Inverter_chain_for_sim_2 #( .WIDTH(WIDTH) ) Inverter_chain_12_loop_5 ( .A(IM4),   .Y(IM5) );
    Inverter_chain_for_sim_2 #( .WIDTH(WIDTH) ) Inverter_chain_12_loop_6 ( .A(IM5),   .Y(Y) );

    endmodule

    // INV *32
    module Inverter_chain_for_sim_32 #(parameter WIDTH=32) (A, Y);
    input   [WIDTH-1:0]     A;
    output  [WIDTH-1:0]     Y;
    wire    [WIDTH-1:0]     IM1, IM2, IM3, IM4, IM5, IM6, IM7, IM8, IM9, IM10, IM11, IM12, IM13, IM14, IM15; // intermediate wire

    Inverter_chain_for_sim_2 #( .WIDTH(WIDTH) ) Inverter_chain_32_loop_1 ( .A(A),     .Y(IM1) );
    Inverter_chain_for_sim_2 #( .WIDTH(WIDTH) ) Inverter_chain_32_loop_2 ( .A(IM1),   .Y(IM2) );
    Inverter_chain_for_sim_2 #( .WIDTH(WIDTH) ) Inverter_chain_32_loop_3 ( .A(IM2),   .Y(IM3) );
    Inverter_chain_for_sim_2 #( .WIDTH(WIDTH) ) Inverter_chain_32_loop_4 ( .A(IM3),   .Y(IM4) );
    Inverter_chain_for_sim_2 #( .WIDTH(WIDTH) ) Inverter_chain_32_loop_5 ( .A(IM4),   .Y(IM5) );
    Inverter_chain_for_sim_2 #( .WIDTH(WIDTH) ) Inverter_chain_32_loop_6 ( .A(IM5),   .Y(IM6) );
    Inverter_chain_for_sim_2 #( .WIDTH(WIDTH) ) Inverter_chain_32_loop_7 ( .A(IM6),   .Y(IM7) );
    Inverter_chain_for_sim_2 #( .WIDTH(WIDTH) ) Inverter_chain_32_loop_8 ( .A(IM7),   .Y(IM8) );
    Inverter_chain_for_sim_2 #( .WIDTH(WIDTH) ) Inverter_chain_32_loop_9 ( .A(IM8),   .Y(IM9) );
    Inverter_chain_for_sim_2 #( .WIDTH(WIDTH) ) Inverter_chain_32_loop_10 ( .A(IM9),   .Y(IM10) );
    Inverter_chain_for_sim_2 #( .WIDTH(WIDTH) ) Inverter_chain_32_loop_11 ( .A(IM10),   .Y(IM11) );
    Inverter_chain_for_sim_2 #( .WIDTH(WIDTH) ) Inverter_chain_32_loop_12 ( .A(IM11),   .Y(IM12) );
    Inverter_chain_for_sim_2 #( .WIDTH(WIDTH) ) Inverter_chain_32_loop_13 ( .A(IM12),   .Y(IM13) );
    Inverter_chain_for_sim_2 #( .WIDTH(WIDTH) ) Inverter_chain_32_loop_14 ( .A(IM13),   .Y(IM14) );
    Inverter_chain_for_sim_2 #( .WIDTH(WIDTH) ) Inverter_chain_32_loop_15 ( .A(IM14),   .Y(IM15) );
    Inverter_chain_for_sim_2 #( .WIDTH(WIDTH) ) Inverter_chain_32_loop_16 ( .A(IM15),   .Y(Y) );

    endmodule
`endif


