`timescale 1ns / 1ps
`include "./param.v"

module tb_generated;

reg CLK, RSTb;
wire [`BIT_INSTR-1:0] i_Instr_In;
wire [`BIT_PSUM-1:0] o_Data;
wire o_Flag_Finish, o_Valid;

top top (
    .CLK(CLK), .RSTb(RSTb),
    .i_Instr_In(i_Instr_In),
    .o_Flag_Finish_Out(o_Flag_Finish),
    .o_Valid_WB_Out(o_Valid),
    .o_Data_WB_Out(o_Data)
);

always #20 CLK = ~CLK;

initial begin
    CLK = 0; RSTb = 1;
    repeat(1) @(negedge CLK); RSTb = 0;
    repeat(5) @(negedge CLK); RSTb = 1;
    repeat(1000) @(negedge CLK);
    $finish;
end

// Instruction Buffer Initialization
initial begin
    Instr[0] <= {`OPVALID, `OPCODE_LDSRAM, 0, 24};
    Instr[1] <= {`OPVALID, `OPCODE_LDSRAM, 1, 107};
    Instr[2] <= {`OPVALID, `OPCODE_LDSRAM, 2, 22};
    Instr[3] <= {`OPVALID, `OPCODE_LDSRAM, 3, 11};
    Instr[4] <= {`OPVALID, `OPCODE_LDSRAM, 4, 84};
    Instr[5] <= {`OPVALID, `OPCODE_LDSRAM, 5, -97};
    Instr[6] <= {`OPVALID, `OPCODE_LDSRAM, 6, 65};
    Instr[7] <= {`OPVALID, `OPCODE_LDSRAM, 7, -124};
    Instr[8] <= {`OPVALID, `OPCODE_LDSRAM, 8, 106};
    Instr[9] <= {`OPVALID, `OPCODE_LDSRAM, 9, 101};
    Instr[10] <= {`OPVALID, `OPCODE_LDSRAM, 10, 5};
    Instr[11] <= {`OPVALID, `OPCODE_LDSRAM, 11, 5};
    Instr[12] <= {`OPVALID, `OPCODE_LDSRAM, 12, 16};
    Instr[13] <= {`OPVALID, `OPCODE_LDSRAM, 13, -116};
    Instr[14] <= {`OPVALID, `OPCODE_LDSRAM, 14, 124};
    Instr[15] <= {`OPVALID, `OPCODE_LDSRAM, 15, -22};
    Instr[16] <= {`OPVALID, `OPCODE_LDSRAM, 16, -20};
    Instr[17] <= {`OPVALID, `OPCODE_LDSRAM, 17, -28};
    Instr[18] <= {`OPVALID, `OPCODE_LDSRAM, 18, 19};
    Instr[19] <= {`OPVALID, `OPCODE_LDSRAM, 19, 121};
    Instr[20] <= {`OPVALID, `OPCODE_LDSRAM, 20, -45};
    Instr[21] <= {`OPVALID, `OPCODE_LDSRAM, 21, 49};
    Instr[22] <= {`OPVALID, `OPCODE_LDSRAM, 22, 85};
    Instr[23] <= {`OPVALID, `OPCODE_LDSRAM, 23, 65};
    Instr[24] <= {`OPVALID, `OPCODE_LDSRAM, 24, 27};
    Instr[25] <= {`OPVALID, `OPCODE_LDSRAM, 25, 88};
    Instr[26] <= {`OPVALID, `OPCODE_LDSRAM, 26, 76};
    Instr[27] <= {`OPVALID, `OPCODE_LDSRAM, 27, -96};
    Instr[28] <= {`OPVALID, `OPCODE_LDSRAM, 28, -98};
    Instr[29] <= {`OPVALID, `OPCODE_LDSRAM, 29, 109};
    Instr[30] <= {`OPVALID, `OPCODE_LDSRAM, 30, 57};
    Instr[31] <= {`OPVALID, `OPCODE_LDSRAM, 31, -126};
    Instr[32] <= {`OPVALID, `OPCODE_LDSRAM, 32, 92};
    Instr[33] <= {`OPVALID, `OPCODE_LDSRAM, 33, -103};
    Instr[34] <= {`OPVALID, `OPCODE_LDSRAM, 34, -52};
    Instr[35] <= {`OPVALID, `OPCODE_LDSRAM, 35, 75};
    Instr[36] <= {`OPVALID, `OPCODE_LDSRAM, 36, 95};
    Instr[37] <= {`OPVALID, `OPCODE_LDSRAM, 37, -117};
    Instr[38] <= {`OPVALID, `OPCODE_LDSRAM, 38, 104};
    Instr[39] <= {`OPVALID, `OPCODE_LDSRAM, 39, -96};
    Instr[40] <= {`OPVALID, `OPCODE_LDSRAM, 40, -31};
    Instr[41] <= {`OPVALID, `OPCODE_LDSRAM, 41, 39};
    Instr[42] <= {`OPVALID, `OPCODE_LDSRAM, 42, 49};
    Instr[43] <= {`OPVALID, `OPCODE_LDSRAM, 43, -127};
    Instr[44] <= {`OPVALID, `OPCODE_LDSRAM, 44, -58};
    Instr[45] <= {`OPVALID, `OPCODE_LDSRAM, 45, -108};
    Instr[46] <= {`OPVALID, `OPCODE_LDSRAM, 46, 63};
    Instr[47] <= {`OPVALID, `OPCODE_LDSRAM, 47, -128};
    Instr[48] <= {`OPVALID, `OPCODE_LDSRAM, 48, 98};
    Instr[49] <= {`OPVALID, `OPCODE_LDSRAM, 49, 66};
    Instr[50] <= {`OPVALID, `OPCODE_LDSRAM, 50, -63};
    Instr[51] <= {`OPVALID, `OPCODE_LDSRAM, 51, 73};
    Instr[52] <= {`OPVALID, `OPCODE_LDSRAM, 52, -97};
    Instr[53] <= {`OPVALID, `OPCODE_LDSRAM, 53, -32};
    Instr[54] <= {`OPVALID, `OPCODE_LDSRAM, 54, 87};
    Instr[55] <= {`OPVALID, `OPCODE_LDSRAM, 55, 42};
    Instr[56] <= {`OPVALID, `OPCODE_LDSRAM, 56, -5};
    Instr[57] <= {`OPVALID, `OPCODE_LDSRAM, 57, 7};
    Instr[58] <= {`OPVALID, `OPCODE_LDSRAM, 58, 39};
    Instr[59] <= {`OPVALID, `OPCODE_LDSRAM, 59, 89};
    Instr[60] <= {`OPVALID, `OPCODE_LDSRAM, 60, -50};
    Instr[61] <= {`OPVALID, `OPCODE_LDSRAM, 61, -110};
    Instr[62] <= {`OPVALID, `OPCODE_LDSRAM, 62, 0};
    Instr[63] <= {`OPVALID, `OPCODE_LDSRAM, 63, 64};
    Instr[64] <= {`OPVALID, `OPCODE_LDSRAM, 64, 29};
    Instr[65] <= {`OPVALID, `OPCODE_LDSRAM, 65, 10};
    Instr[66] <= {`OPVALID, `OPCODE_LDSRAM, 66, -109};
    Instr[67] <= {`OPVALID, `OPCODE_LDSRAM, 67, 61};
    Instr[68] <= {`OPVALID, `OPCODE_LDSRAM, 68, 51};
    Instr[69] <= {`OPVALID, `OPCODE_LDSRAM, 69, 68};
    Instr[70] <= {`OPVALID, `OPCODE_LDSRAM, 70, 68};
    Instr[71] <= {`OPVALID, `OPCODE_LDSRAM, 71, -126};
    Instr[72] <= {`OPVALID, `OPCODE_LDSRAM, 72, -62};
    Instr[73] <= {`OPVALID, `OPCODE_LDSRAM, 73, -57};
    Instr[74] <= {`OPVALID, `OPCODE_LDSRAM, 74, 93};
    Instr[75] <= {`OPVALID, `OPCODE_LDSRAM, 75, -108};
    Instr[76] <= {`OPVALID, `OPCODE_LDSRAM, 76, 65};
    Instr[77] <= {`OPVALID, `OPCODE_LDSRAM, 77, -105};
    Instr[78] <= {`OPVALID, `OPCODE_LDSRAM, 78, -92};
    Instr[79] <= {`OPVALID, `OPCODE_LDSRAM, 79, -113};
    Instr[80] <= {`OPVALID, `OPCODE_LDSRAM, 80, 85};
    Instr[81] <= {`OPVALID, `OPCODE_LDSRAM, 81, -106};
    Instr[82] <= {`OPVALID, `OPCODE_LDSRAM, 82, 76};
    Instr[83] <= {`OPVALID, `OPCODE_LDSRAM, 83, 123};
    Instr[84] <= {`OPVALID, `OPCODE_LDSRAM, 84, 59};
    Instr[85] <= {`OPVALID, `OPCODE_LDSRAM, 85, 40};
    Instr[86] <= {`OPVALID, `OPCODE_LDSRAM, 86, -8};
    Instr[87] <= {`OPVALID, `OPCODE_LDSRAM, 87, -28};
    Instr[88] <= {`OPVALID, `OPCODE_LDSRAM, 88, -16};
    Instr[89] <= {`OPVALID, `OPCODE_LDSRAM, 89, 112};
    Instr[90] <= {`OPVALID, `OPCODE_LDSRAM, 0, -73};
    Instr[91] <= {`OPVALID, `OPCODE_LDSRAM, 1, 21};
    Instr[92] <= {`OPVALID, `OPCODE_LDSRAM, 2, 121};
    Instr[93] <= {`OPVALID, `OPCODE_LDSRAM, 3, 27};
    Instr[94] <= {`OPVALID, `OPCODE_LDSRAM, 4, 27};
    Instr[95] <= {`OPVALID, `OPCODE_LDSRAM, 5, 102};
    Instr[96] <= {`OPVALID, `OPCODE_LDSRAM, 6, 62};
    Instr[97] <= {`OPVALID, `OPCODE_LDSRAM, 7, -98};
    Instr[98] <= {`OPVALID, `OPCODE_LDSRAM, 8, 63};
    Instr[99] <= {`OPVALID, `OPCODE_LDSRAM, 9, 121};
    Instr[100] <= {`OPVALID, `OPCODE_LDSRAM, 10, -60};
    Instr[101] <= {`OPVALID, `OPCODE_LDSRAM, 11, 68};
    Instr[102] <= {`OPVALID, `OPCODE_LDSRAM, 12, 126};
    Instr[103] <= {`OPVALID, `OPCODE_LDSRAM, 13, -83};
    Instr[104] <= {`OPVALID, `OPCODE_LDSRAM, 14, -111};
    Instr[105] <= {`OPVALID, `OPCODE_LDSRAM, 15, 39};
    Instr[106] <= {`OPVALID, `OPCODE_LDSRAM, 16, 80};
    Instr[107] <= {`OPVALID, `OPCODE_LDSRAM, 17, -67};
    Instr[108] <= {`OPVALID, `OPCODE_LDSRAM, 18, -31};
    Instr[109] <= {`OPVALID, `OPCODE_LDSRAM, 19, -122};
    Instr[110] <= {`OPVALID, `OPCODE_LDSRAM, 20, 52};
    Instr[111] <= {`OPVALID, `OPCODE_LDSRAM, 21, -16};
    Instr[112] <= {`OPVALID, `OPCODE_LDSRAM, 22, -56};
    Instr[113] <= {`OPVALID, `OPCODE_LDSRAM, 23, -33};
    Instr[114] <= {`OPVALID, `OPCODE_LDSRAM, 24, 109};
    Instr[115] <= {`OPVALID, `OPCODE_LDSRAM, 25, 117};
    Instr[116] <= {`OPVALID, `OPCODE_LDSRAM, 26, 21};
    Instr[117] <= {`OPVALID, `OPCODE_LDSRAM, 27, 16};
    Instr[118] <= {`OPVALID, `OPCODE_LDSRAM, 28, -22};
    Instr[119] <= {`OPVALID, `OPCODE_LDSRAM, 29, -125};
    Instr[120] <= {`OPVALID, `OPCODE_EX, 20'd0, 8'd0};
    Instr[121] <= {`OPVALID, `OPCODE_WBPSRAM, 6'd0, 14'd0, 8'd0};
end
endmodule
