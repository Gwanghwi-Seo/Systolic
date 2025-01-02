`timescale 1ns / 1ps
`include "./param.v"

module tb_top;

reg CLK, RSTb;
wire [`BIT_INSTR-1:0] i_Instr_In;
// wire o_Flag_Finish_Out;
// wire o_Valid_WB_Out;
// wire [`BIT_DATAWB-1:0] o_Data_WB_Out;
// wire o_Flag_Finish = o_Data_WB_Out[`BIT_DATAWB-1];
// wire o_Valid = o_Data_WB_Out[`BIT_DATAWB-2];
// wire [`BIT_PSUM-1:0] o_Data = o_Data_WB_Out[`BIT_PSUM-1:0];
wire o_Flag_Finish, o_Instr_Flag;
wire o_Valid;
wire [`BIT_PSUM-1:0] o_Data;

top top (
    .CLK(CLK),
    .RSTb(RSTb),
    .i_Instr_In(i_Instr_In),
    .o_Flag_Finish_Out(o_Flag_Finish),
    .o_Valid_WB_Out(o_Valid),
    .o_Data_WB_Out(o_Data),
    .o_Instr_Flag(o_Instr_Flag)
);

instr_buffer instr_buffer (
    .CLK(CLK),
    .RST(~RSTb),
    .i_Instr_Flag(o_Instr_Flag),
    .o_Instr(i_Instr_In)
);

always #20  CLK <= ~CLK;

initial begin
        CLK <= 1'b0;
        RSTb <= 1'b1;
        repeat(1)  @(negedge CLK);
        RSTb <= 1'b0;
        repeat(5)  @(negedge CLK);
        RSTb <= 1'b1;
        repeat(2048)  @(negedge CLK);   
        $finish;
end
endmodule

module instr_buffer (CLK, RST, i_Instr_Flag, o_Instr);
input CLK, RST;
input i_Instr_Flag;
output  reg [`BIT_INSTR-1:0] o_Instr;

reg [`BIT_INSTR-1:0] Instr[1023:0];
reg [10:0]   Count;

always @(negedge CLK, posedge RST) begin
    if (RST)
        Count    <= 1'b0;
    else begin
        Count    <= Count + 11'd1;
        if (Count[0]) begin
            o_Instr <= Instr[Count[10:1]];
        end
        else begin            
            o_Instr <= 0;
        end
    end
end

genvar i;
generate for (i=0;i<1024;i=i+1) begin: Loop_Init_MEM
    initial Instr[i] <= 0;
end
endgenerate

initial begin
// ISA (v1)
// OPVALID(1) / OPCODE(3) / SEL(4)+ADDR(16) or PARAM(20) / DATA(8): total(32)
Instr[0]  <= {`OPVALID, `OPCODE_PARAM, `PARAM_S, 8'd4};
Instr[1]  <= {`OPVALID, `OPCODE_PARAM, `PARAM_OC, 8'd5};
Instr[2]  <= {`OPVALID, `OPCODE_PARAM, `PARAM_IC, 8'd23};
// For writeback test
Instr[3]  <= {`OPVALID, `OPCODE_PARAM, `PARAM_SEL_ISRAM, 8'd0};
Instr[4]  <= {`OPVALID, `OPCODE_PARAM, `PARAM_SEL_WSRAM, 8'd0};
Instr[5]  <= {`OPVALID, `OPCODE_PARAM, `PARAM_SEL_PSRAM, 8'd0};
// LDSRAM_I

Instr[6] <= {`OPVALID, `OPCODE_PARAM, `PARAM_TRG, `TRG_ISRAM};
Instr[7] <= {`OPVALID, `OPCODE_LDSRAM, 6'd0, 14'd0, -8'd112};
Instr[8] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd0, -8'd117};
Instr[9] <= {`OPVALID, `OPCODE_LDSRAM, 6'd2, 14'd0, 8'd101};
Instr[10] <= {`OPVALID, `OPCODE_LDSRAM, 6'd3, 14'd0, 8'd124};
Instr[11] <= {`OPVALID, `OPCODE_LDSRAM, 6'd4, 14'd0, 8'd28};
Instr[12] <= {`OPVALID, `OPCODE_LDSRAM, 6'd5, 14'd0, 8'd53};
Instr[13] <= {`OPVALID, `OPCODE_LDSRAM, 6'd6, 14'd0, -8'd2};
Instr[14] <= {`OPVALID, `OPCODE_LDSRAM, 6'd7, 14'd0, 8'd62};
Instr[15] <= {`OPVALID, `OPCODE_LDSRAM, 6'd8, 14'd0, 8'd26};
Instr[16] <= {`OPVALID, `OPCODE_LDSRAM, 6'd9, 14'd0, 8'd124};
Instr[17] <= {`OPVALID, `OPCODE_LDSRAM, 6'd10, 14'd0, 8'd100};
Instr[18] <= {`OPVALID, `OPCODE_LDSRAM, 6'd11, 14'd0, 8'd110};
Instr[19] <= {`OPVALID, `OPCODE_LDSRAM, 6'd12, 14'd0, -8'd17};
Instr[20] <= {`OPVALID, `OPCODE_LDSRAM, 6'd13, 14'd0, 8'd37};
Instr[21] <= {`OPVALID, `OPCODE_LDSRAM, 6'd14, 14'd0, 8'd22};
Instr[22] <= {`OPVALID, `OPCODE_LDSRAM, 6'd15, 14'd0, -8'd13};
Instr[23] <= {`OPVALID, `OPCODE_LDSRAM, 6'd16, 14'd0, -8'd73};
Instr[24] <= {`OPVALID, `OPCODE_LDSRAM, 6'd17, 14'd0, 8'd3};
Instr[25] <= {`OPVALID, `OPCODE_LDSRAM, 6'd18, 14'd0, 8'd125};
Instr[26] <= {`OPVALID, `OPCODE_LDSRAM, 6'd19, 14'd0, 8'd84};
Instr[27] <= {`OPVALID, `OPCODE_LDSRAM, 6'd20, 14'd0, -8'd88};
Instr[28] <= {`OPVALID, `OPCODE_LDSRAM, 6'd21, 14'd0, 8'd81};
Instr[29] <= {`OPVALID, `OPCODE_LDSRAM, 6'd22, 14'd0, 8'd79};
Instr[30] <= {`OPVALID, `OPCODE_LDSRAM, 6'd0, 14'd1, 8'd105};
Instr[31] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd1, -8'd58};
Instr[32] <= {`OPVALID, `OPCODE_LDSRAM, 6'd2, 14'd1, -8'd120};
Instr[33] <= {`OPVALID, `OPCODE_LDSRAM, 6'd3, 14'd1, -8'd36};
Instr[34] <= {`OPVALID, `OPCODE_LDSRAM, 6'd4, 14'd1, 8'd5};
Instr[35] <= {`OPVALID, `OPCODE_LDSRAM, 6'd5, 14'd1, -8'd122};
Instr[36] <= {`OPVALID, `OPCODE_LDSRAM, 6'd6, 14'd1, 8'd108};
Instr[37] <= {`OPVALID, `OPCODE_LDSRAM, 6'd7, 14'd1, -8'd57};
Instr[38] <= {`OPVALID, `OPCODE_LDSRAM, 6'd8, 14'd1, 8'd97};
Instr[39] <= {`OPVALID, `OPCODE_LDSRAM, 6'd9, 14'd1, 8'd8};
Instr[40] <= {`OPVALID, `OPCODE_LDSRAM, 6'd10, 14'd1, -8'd6};
Instr[41] <= {`OPVALID, `OPCODE_LDSRAM, 6'd11, 14'd1, -8'd112};
Instr[42] <= {`OPVALID, `OPCODE_LDSRAM, 6'd12, 14'd1, 8'd84};
Instr[43] <= {`OPVALID, `OPCODE_LDSRAM, 6'd13, 14'd1, -8'd79};
Instr[44] <= {`OPVALID, `OPCODE_LDSRAM, 6'd14, 14'd1, 8'd16};
Instr[45] <= {`OPVALID, `OPCODE_LDSRAM, 6'd15, 14'd1, 8'd115};
Instr[46] <= {`OPVALID, `OPCODE_LDSRAM, 6'd16, 14'd1, 8'd82};
Instr[47] <= {`OPVALID, `OPCODE_LDSRAM, 6'd17, 14'd1, 8'd57};
Instr[48] <= {`OPVALID, `OPCODE_LDSRAM, 6'd18, 14'd1, -8'd27};
Instr[49] <= {`OPVALID, `OPCODE_LDSRAM, 6'd19, 14'd1, 8'd15};
Instr[50] <= {`OPVALID, `OPCODE_LDSRAM, 6'd20, 14'd1, 8'd4};
Instr[51] <= {`OPVALID, `OPCODE_LDSRAM, 6'd21, 14'd1, -8'd95};
Instr[52] <= {`OPVALID, `OPCODE_LDSRAM, 6'd22, 14'd1, 8'd46};
Instr[53] <= {`OPVALID, `OPCODE_LDSRAM, 6'd0, 14'd2, -8'd97};
Instr[54] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd2, -8'd57};
Instr[55] <= {`OPVALID, `OPCODE_LDSRAM, 6'd2, 14'd2, 8'd10};
Instr[56] <= {`OPVALID, `OPCODE_LDSRAM, 6'd3, 14'd2, -8'd40};
Instr[57] <= {`OPVALID, `OPCODE_LDSRAM, 6'd4, 14'd2, -8'd66};
Instr[58] <= {`OPVALID, `OPCODE_LDSRAM, 6'd5, 14'd2, 8'd65};
Instr[59] <= {`OPVALID, `OPCODE_LDSRAM, 6'd6, 14'd2, -8'd109};
Instr[60] <= {`OPVALID, `OPCODE_LDSRAM, 6'd7, 14'd2, -8'd55};
Instr[61] <= {`OPVALID, `OPCODE_LDSRAM, 6'd8, 14'd2, 8'd43};
Instr[62] <= {`OPVALID, `OPCODE_LDSRAM, 6'd9, 14'd2, 8'd61};
Instr[63] <= {`OPVALID, `OPCODE_LDSRAM, 6'd10, 14'd2, -8'd89};
Instr[64] <= {`OPVALID, `OPCODE_LDSRAM, 6'd11, 14'd2, -8'd66};
Instr[65] <= {`OPVALID, `OPCODE_LDSRAM, 6'd12, 14'd2, 8'd91};
Instr[66] <= {`OPVALID, `OPCODE_LDSRAM, 6'd13, 14'd2, -8'd109};
Instr[67] <= {`OPVALID, `OPCODE_LDSRAM, 6'd14, 14'd2, -8'd65};
Instr[68] <= {`OPVALID, `OPCODE_LDSRAM, 6'd15, 14'd2, -8'd65};
Instr[69] <= {`OPVALID, `OPCODE_LDSRAM, 6'd16, 14'd2, -8'd13};
Instr[70] <= {`OPVALID, `OPCODE_LDSRAM, 6'd17, 14'd2, 8'd118};
Instr[71] <= {`OPVALID, `OPCODE_LDSRAM, 6'd18, 14'd2, -8'd106};
Instr[72] <= {`OPVALID, `OPCODE_LDSRAM, 6'd19, 14'd2, 8'd86};
Instr[73] <= {`OPVALID, `OPCODE_LDSRAM, 6'd20, 14'd2, -8'd54};
Instr[74] <= {`OPVALID, `OPCODE_LDSRAM, 6'd21, 14'd2, -8'd65};
Instr[75] <= {`OPVALID, `OPCODE_LDSRAM, 6'd22, 14'd2, -8'd94};
Instr[76] <= {`OPVALID, `OPCODE_LDSRAM, 6'd0, 14'd3, -8'd23};
Instr[77] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd3, -8'd93};
Instr[78] <= {`OPVALID, `OPCODE_LDSRAM, 6'd2, 14'd3, -8'd67};
Instr[79] <= {`OPVALID, `OPCODE_LDSRAM, 6'd3, 14'd3, -8'd2};
Instr[80] <= {`OPVALID, `OPCODE_LDSRAM, 6'd4, 14'd3, 8'd84};
Instr[81] <= {`OPVALID, `OPCODE_LDSRAM, 6'd5, 14'd3, 8'd87};
Instr[82] <= {`OPVALID, `OPCODE_LDSRAM, 6'd6, 14'd3, -8'd78};
Instr[83] <= {`OPVALID, `OPCODE_LDSRAM, 6'd7, 14'd3, -8'd64};
Instr[84] <= {`OPVALID, `OPCODE_LDSRAM, 6'd8, 14'd3, 8'd84};
Instr[85] <= {`OPVALID, `OPCODE_LDSRAM, 6'd9, 14'd3, 8'd48};
Instr[86] <= {`OPVALID, `OPCODE_LDSRAM, 6'd10, 14'd3, 8'd122};
Instr[87] <= {`OPVALID, `OPCODE_LDSRAM, 6'd11, 14'd3, 8'd58};
Instr[88] <= {`OPVALID, `OPCODE_LDSRAM, 6'd12, 14'd3, -8'd78};
Instr[89] <= {`OPVALID, `OPCODE_LDSRAM, 6'd13, 14'd3, -8'd104};
Instr[90] <= {`OPVALID, `OPCODE_LDSRAM, 6'd14, 14'd3, 8'd50};
Instr[91] <= {`OPVALID, `OPCODE_LDSRAM, 6'd15, 14'd3, -8'd11};
Instr[92] <= {`OPVALID, `OPCODE_LDSRAM, 6'd16, 14'd3, 8'd126};
Instr[93] <= {`OPVALID, `OPCODE_LDSRAM, 6'd17, 14'd3, -8'd41};
Instr[94] <= {`OPVALID, `OPCODE_LDSRAM, 6'd18, 14'd3, -8'd113};
Instr[95] <= {`OPVALID, `OPCODE_LDSRAM, 6'd19, 14'd3, 8'd12};
Instr[96] <= {`OPVALID, `OPCODE_LDSRAM, 6'd20, 14'd3, 8'd63};
Instr[97] <= {`OPVALID, `OPCODE_LDSRAM, 6'd21, 14'd3, 8'd77};
Instr[98] <= {`OPVALID, `OPCODE_LDSRAM, 6'd22, 14'd3, 8'd37};


// ISA (v1)
// OPVALID(1) / OPCODE(3) / SEL(6)+ADDR(14) or PARAM(20) / DATA(8): total(32)
// LDSRAM_W
Instr[99] <= {`OPVALID, `OPCODE_PARAM, `PARAM_TRG, `TRG_WSRAM};
Instr[100] <= {`OPVALID, `OPCODE_LDSRAM, 6'd0, 14'd0, 8'd89};
Instr[101] <= {`OPVALID, `OPCODE_LDSRAM, 6'd0, 14'd1, -8'd33};
Instr[102] <= {`OPVALID, `OPCODE_LDSRAM, 6'd0, 14'd2, -8'd92};
Instr[103] <= {`OPVALID, `OPCODE_LDSRAM, 6'd0, 14'd3, -8'd17};
Instr[104] <= {`OPVALID, `OPCODE_LDSRAM, 6'd0, 14'd4, 8'd44};
Instr[105] <= {`OPVALID, `OPCODE_LDSRAM, 6'd0, 14'd5, 8'd25};
Instr[106] <= {`OPVALID, `OPCODE_LDSRAM, 6'd0, 14'd6, 8'd19};
Instr[107] <= {`OPVALID, `OPCODE_LDSRAM, 6'd0, 14'd7, -8'd60};
Instr[108] <= {`OPVALID, `OPCODE_LDSRAM, 6'd0, 14'd8, 8'd61};
Instr[109] <= {`OPVALID, `OPCODE_LDSRAM, 6'd0, 14'd9, 8'd105};
Instr[110] <= {`OPVALID, `OPCODE_LDSRAM, 6'd0, 14'd10, -8'd70};
Instr[111] <= {`OPVALID, `OPCODE_LDSRAM, 6'd0, 14'd11, -8'd9};
Instr[112] <= {`OPVALID, `OPCODE_LDSRAM, 6'd0, 14'd12, 8'd55};
Instr[113] <= {`OPVALID, `OPCODE_LDSRAM, 6'd0, 14'd13, 8'd18};
Instr[114] <= {`OPVALID, `OPCODE_LDSRAM, 6'd0, 14'd14, -8'd12};
Instr[115] <= {`OPVALID, `OPCODE_LDSRAM, 6'd0, 14'd15, 8'd37};
Instr[116] <= {`OPVALID, `OPCODE_LDSRAM, 6'd0, 14'd16, 8'd118};
Instr[117] <= {`OPVALID, `OPCODE_LDSRAM, 6'd0, 14'd17, 8'd109};
Instr[118] <= {`OPVALID, `OPCODE_LDSRAM, 6'd0, 14'd18, -8'd74};
Instr[119] <= {`OPVALID, `OPCODE_LDSRAM, 6'd0, 14'd19, -8'd5};
Instr[120] <= {`OPVALID, `OPCODE_LDSRAM, 6'd0, 14'd20, 8'd42};
Instr[121] <= {`OPVALID, `OPCODE_LDSRAM, 6'd0, 14'd21, 8'd110};
Instr[122] <= {`OPVALID, `OPCODE_LDSRAM, 6'd0, 14'd22, 8'd46};
Instr[123] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd0, -8'd107};
Instr[124] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd1, 8'd102};
Instr[125] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd2, -8'd103};
Instr[126] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd3, -8'd28};
Instr[127] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd4, 8'd39};
Instr[128] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd5, 8'd113};
Instr[129] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd6, 8'd102};
Instr[130] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd7, -8'd25};
Instr[131] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd8, 8'd29};
Instr[132] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd9, -8'd120};
Instr[133] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd10, -8'd68};
Instr[134] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd11, -8'd82};
Instr[135] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd12, -8'd124};
Instr[136] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd13, -8'd41};
Instr[137] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd14, -8'd43};
Instr[138] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd15, -8'd21};
Instr[139] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd16, -8'd127};
Instr[140] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd17, -8'd65};
Instr[141] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd18, 8'd52};
Instr[142] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd19, 8'd111};
Instr[143] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd20, 8'd10};
Instr[144] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd21, -8'd23};
Instr[145] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd22, -8'd82};
Instr[146] <= {`OPVALID, `OPCODE_LDSRAM, 6'd2, 14'd0, 8'd104};
Instr[147] <= {`OPVALID, `OPCODE_LDSRAM, 6'd2, 14'd1, -8'd17};
Instr[148] <= {`OPVALID, `OPCODE_LDSRAM, 6'd2, 14'd2, 8'd60};
Instr[149] <= {`OPVALID, `OPCODE_LDSRAM, 6'd2, 14'd3, 8'd106};
Instr[150] <= {`OPVALID, `OPCODE_LDSRAM, 6'd2, 14'd4, -8'd88};
Instr[151] <= {`OPVALID, `OPCODE_LDSRAM, 6'd2, 14'd5, 8'd82};
Instr[152] <= {`OPVALID, `OPCODE_LDSRAM, 6'd2, 14'd6, -8'd7};
Instr[153] <= {`OPVALID, `OPCODE_LDSRAM, 6'd2, 14'd7, 8'd88};
Instr[154] <= {`OPVALID, `OPCODE_LDSRAM, 6'd2, 14'd8, 8'd60};
Instr[155] <= {`OPVALID, `OPCODE_LDSRAM, 6'd2, 14'd9, 8'd55};
Instr[156] <= {`OPVALID, `OPCODE_LDSRAM, 6'd2, 14'd10, -8'd45};
Instr[157] <= {`OPVALID, `OPCODE_LDSRAM, 6'd2, 14'd11, -8'd7};
Instr[158] <= {`OPVALID, `OPCODE_LDSRAM, 6'd2, 14'd12, 8'd113};
Instr[159] <= {`OPVALID, `OPCODE_LDSRAM, 6'd2, 14'd13, 8'd74};
Instr[160] <= {`OPVALID, `OPCODE_LDSRAM, 6'd2, 14'd14, -8'd46};
Instr[161] <= {`OPVALID, `OPCODE_LDSRAM, 6'd2, 14'd15, -8'd88};
Instr[162] <= {`OPVALID, `OPCODE_LDSRAM, 6'd2, 14'd16, 8'd31};
Instr[163] <= {`OPVALID, `OPCODE_LDSRAM, 6'd2, 14'd17, 8'd17};
Instr[164] <= {`OPVALID, `OPCODE_LDSRAM, 6'd2, 14'd18, 8'd29};
Instr[165] <= {`OPVALID, `OPCODE_LDSRAM, 6'd2, 14'd19, 8'd126};
Instr[166] <= {`OPVALID, `OPCODE_LDSRAM, 6'd2, 14'd20, -8'd97};
Instr[167] <= {`OPVALID, `OPCODE_LDSRAM, 6'd2, 14'd21, 8'd99};
Instr[168] <= {`OPVALID, `OPCODE_LDSRAM, 6'd2, 14'd22, 8'd27};
Instr[169] <= {`OPVALID, `OPCODE_LDSRAM, 6'd3, 14'd0, -8'd103};
Instr[170] <= {`OPVALID, `OPCODE_LDSRAM, 6'd3, 14'd1, 8'd69};
Instr[171] <= {`OPVALID, `OPCODE_LDSRAM, 6'd3, 14'd2, 8'd110};
Instr[172] <= {`OPVALID, `OPCODE_LDSRAM, 6'd3, 14'd3, -8'd79};
Instr[173] <= {`OPVALID, `OPCODE_LDSRAM, 6'd3, 14'd4, -8'd35};
Instr[174] <= {`OPVALID, `OPCODE_LDSRAM, 6'd3, 14'd5, -8'd113};
Instr[175] <= {`OPVALID, `OPCODE_LDSRAM, 6'd3, 14'd6, 8'd3};
Instr[176] <= {`OPVALID, `OPCODE_LDSRAM, 6'd3, 14'd7, 8'd85};
Instr[177] <= {`OPVALID, `OPCODE_LDSRAM, 6'd3, 14'd8, -8'd35};
Instr[178] <= {`OPVALID, `OPCODE_LDSRAM, 6'd3, 14'd9, -8'd16};
Instr[179] <= {`OPVALID, `OPCODE_LDSRAM, 6'd3, 14'd10, 8'd79};
Instr[180] <= {`OPVALID, `OPCODE_LDSRAM, 6'd3, 14'd11, 8'd24};
Instr[181] <= {`OPVALID, `OPCODE_LDSRAM, 6'd3, 14'd12, -8'd102};
Instr[182] <= {`OPVALID, `OPCODE_LDSRAM, 6'd3, 14'd13, -8'd88};
Instr[183] <= {`OPVALID, `OPCODE_LDSRAM, 6'd3, 14'd14, 8'd112};
Instr[184] <= {`OPVALID, `OPCODE_LDSRAM, 6'd3, 14'd15, -8'd65};
Instr[185] <= {`OPVALID, `OPCODE_LDSRAM, 6'd3, 14'd16, -8'd31};
Instr[186] <= {`OPVALID, `OPCODE_LDSRAM, 6'd3, 14'd17, 8'd104};
Instr[187] <= {`OPVALID, `OPCODE_LDSRAM, 6'd3, 14'd18, 8'd42};
Instr[188] <= {`OPVALID, `OPCODE_LDSRAM, 6'd3, 14'd19, 8'd87};
Instr[189] <= {`OPVALID, `OPCODE_LDSRAM, 6'd3, 14'd20, -8'd34};
Instr[190] <= {`OPVALID, `OPCODE_LDSRAM, 6'd3, 14'd21, 8'd69};
Instr[191] <= {`OPVALID, `OPCODE_LDSRAM, 6'd3, 14'd22, 8'd70};

Instr[192] <= {`OPVALID, `OPCODE_LDSRAM, 6'd4, 14'd0, 8'd25};
Instr[193] <= {`OPVALID, `OPCODE_LDSRAM, 6'd4, 14'd1, -8'd97};
Instr[194] <= {`OPVALID, `OPCODE_LDSRAM, 6'd4, 14'd2, -8'd70};
Instr[195] <= {`OPVALID, `OPCODE_LDSRAM, 6'd4, 14'd3, 8'd124};
Instr[196] <= {`OPVALID, `OPCODE_LDSRAM, 6'd4, 14'd4, 8'd27};
Instr[197] <= {`OPVALID, `OPCODE_LDSRAM, 6'd4, 14'd5, 8'd27};
Instr[198] <= {`OPVALID, `OPCODE_LDSRAM, 6'd4, 14'd6, -8'd68};
Instr[199] <= {`OPVALID, `OPCODE_LDSRAM, 6'd4, 14'd7, 8'd109};
Instr[200] <= {`OPVALID, `OPCODE_LDSRAM, 6'd4, 14'd8, 8'd3};
Instr[201] <= {`OPVALID, `OPCODE_LDSRAM, 6'd4, 14'd9, -8'd61};
Instr[202] <= {`OPVALID, `OPCODE_LDSRAM, 6'd4, 14'd10, -8'd90};
Instr[203] <= {`OPVALID, `OPCODE_LDSRAM, 6'd4, 14'd11, 8'd29};
Instr[204] <= {`OPVALID, `OPCODE_LDSRAM, 6'd4, 14'd12, -8'd35};
Instr[205] <= {`OPVALID, `OPCODE_LDSRAM, 6'd4, 14'd13, -8'd96};
Instr[206] <= {`OPVALID, `OPCODE_LDSRAM, 6'd4, 14'd14, 8'd99};
Instr[207] <= {`OPVALID, `OPCODE_LDSRAM, 6'd4, 14'd15, -8'd87};
Instr[208] <= {`OPVALID, `OPCODE_LDSRAM, 6'd4, 14'd16, 8'd46};
Instr[209] <= {`OPVALID, `OPCODE_LDSRAM, 6'd4, 14'd17, -8'd81};
Instr[210] <= {`OPVALID, `OPCODE_LDSRAM, 6'd4, 14'd18, -8'd31};
Instr[211] <= {`OPVALID, `OPCODE_LDSRAM, 6'd4, 14'd19, 8'd1};
Instr[212] <= {`OPVALID, `OPCODE_LDSRAM, 6'd4, 14'd20, -8'd92};
Instr[213] <= {`OPVALID, `OPCODE_LDSRAM, 6'd4, 14'd21, -8'd56};
Instr[214] <= {`OPVALID, `OPCODE_LDSRAM, 6'd4, 14'd22, -8'd87};

Instr[215] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd23, 8'd0};
Instr[216] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd24, 8'd0};
Instr[217] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd25, 8'd0};
Instr[218] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd26, 8'd0};
Instr[219] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd27, 8'd0};
Instr[220] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd28, 8'd0};
Instr[221] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd29, 8'd0};
Instr[222] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd30, 8'd0};
Instr[223] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd31, 8'd0};
Instr[224] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd32, 8'd0};
Instr[225] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd33, 8'd0};
Instr[226] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd34, 8'd0};
Instr[227] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd35, 8'd0};
Instr[228] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd36, 8'd0};
Instr[229] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd37, 8'd0};
Instr[230] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd38, 8'd0};
Instr[231] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd39, 8'd0};
Instr[232] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd40, 8'd0};
Instr[233] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd41, 8'd0};
Instr[234] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd42, 8'd0};
Instr[235] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd43, 8'd0};
Instr[236] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd44, 8'd0};
Instr[237] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd45, 8'd0};

// Execute
Instr[238] <= {`OPVALID, `OPCODE_PARAM, `PARAM_BASE_WSRAM, 8'd0};
Instr[239] <= {`OPVALID, `OPCODE_INITPSUM, 20'd0, 8'd0};
Instr[340] <= {`OPVALID, `OPCODE_EX, 20'd0, 8'd0};
Instr[341] <= {`OPVALID, `OPCODE_NOP, 20'd0, 8'd0};

// // Writeback
Instr[440] <= {`OPVALID, `OPCODE_WBPSRAM, 6'd0, 14'd0, 8'd0};
Instr[441] <= {`OPVALID, `OPCODE_WBPSRAM, 6'd0, 14'd1, 8'd0};
Instr[442] <= {`OPVALID, `OPCODE_WBPSRAM, 6'd0, 14'd2, 8'd0};
Instr[443] <= {`OPVALID, `OPCODE_WBPSRAM, 6'd0, 14'd3, 8'd0};
Instr[444] <= {`OPVALID, `OPCODE_WBPSRAM, 6'd1, 14'd0, 8'd0};
Instr[445] <= {`OPVALID, `OPCODE_WBPSRAM, 6'd1, 14'd1, 8'd0};
Instr[446] <= {`OPVALID, `OPCODE_WBPSRAM, 6'd1, 14'd2, 8'd0};
Instr[447] <= {`OPVALID, `OPCODE_WBPSRAM, 6'd1, 14'd3, 8'd0};
Instr[448] <= {`OPVALID, `OPCODE_WBPSRAM, 6'd2, 14'd0, 8'd0};
Instr[449] <= {`OPVALID, `OPCODE_WBPSRAM, 6'd2, 14'd1, 8'd0};
Instr[450] <= {`OPVALID, `OPCODE_WBPSRAM, 6'd2, 14'd2, 8'd0};
Instr[451] <= {`OPVALID, `OPCODE_WBPSRAM, 6'd2, 14'd3, 8'd0};
Instr[452] <= {`OPVALID, `OPCODE_WBPSRAM, 6'd3, 14'd0, 8'd0};
Instr[453] <= {`OPVALID, `OPCODE_WBPSRAM, 6'd3, 14'd1, 8'd0};
Instr[454] <= {`OPVALID, `OPCODE_WBPSRAM, 6'd3, 14'd2, 8'd0};
Instr[455] <= {`OPVALID, `OPCODE_WBPSRAM, 6'd3, 14'd3, 8'd0};
Instr[456] <= {`OPVALID, `OPCODE_WBPSRAM, 6'd4, 14'd0, 8'd0};
Instr[457] <= {`OPVALID, `OPCODE_WBPSRAM, 6'd4, 14'd1, 8'd0};
Instr[458] <= {`OPVALID, `OPCODE_WBPSRAM, 6'd4, 14'd2, 8'd0};
Instr[459] <= {`OPVALID, `OPCODE_WBPSRAM, 6'd4, 14'd3, 8'd0};

Instr[460] <= {`OPVALID, `OPCODE_NOP, 20'd0, 8'd0};




//psramwb(just test)
Instr[461]  <= {`OPVALID, `OPCODE_WBPARAM, `PARAM_S, 8'd0};
Instr[462]  <= {`OPVALID, `OPCODE_WBPARAM, `PARAM_OC, 8'd0};
Instr[463]  <= {`OPVALID, `OPCODE_WBPARAM, `PARAM_IC, 8'd0};
Instr[464] <= {`OPVALID, `OPCODE_NOP, 20'd0, 8'd0};

//new param set
Instr[475]  <= {`OPVALID, `OPCODE_PARAM, `PARAM_S, 8'd4};
Instr[476]  <= {`OPVALID, `OPCODE_PARAM, `PARAM_OC, 8'd5};
Instr[477]  <= {`OPVALID, `OPCODE_PARAM, `PARAM_IC, 8'd23};
// Set Num_Sram
Instr[477]  <= {`OPVALID, `OPCODE_PARAM, `PARAM_SEL_ISRAM, 8'd1};
Instr[478]  <= {`OPVALID, `OPCODE_PARAM, `PARAM_SEL_WSRAM, 8'd1};
Instr[479]  <= {`OPVALID, `OPCODE_PARAM, `PARAM_SEL_PSRAM, 8'd1};
Instr[480]  <= {`OPVALID, `OPCODE_PARAM, `PARAM_LAYER_END, 8'd1};
Instr[465] <= {`OPVALID, `OPCODE_INITPSUM, 20'd0, 8'd0};


// LDSRAM_I
Instr[481] <= {`OPVALID, `OPCODE_PARAM, `PARAM_TRG, `TRG_ISRAM};
Instr[482] <= {`OPVALID, `OPCODE_LDSRAM, 6'd0, 14'd0, -8'd112};
Instr[483] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd0, -8'd117};
Instr[484] <= {`OPVALID, `OPCODE_LDSRAM, 6'd2, 14'd0, 8'd101};
Instr[485] <= {`OPVALID, `OPCODE_LDSRAM, 6'd3, 14'd0, 8'd124};
Instr[486] <= {`OPVALID, `OPCODE_LDSRAM, 6'd4, 14'd0, 8'd28};
Instr[487] <= {`OPVALID, `OPCODE_LDSRAM, 6'd5, 14'd0, 8'd53};
Instr[488] <= {`OPVALID, `OPCODE_LDSRAM, 6'd6, 14'd0, -8'd2};
Instr[489] <= {`OPVALID, `OPCODE_LDSRAM, 6'd7, 14'd0, 8'd62};
Instr[490] <= {`OPVALID, `OPCODE_LDSRAM, 6'd8, 14'd0, 8'd26};
Instr[491] <= {`OPVALID, `OPCODE_LDSRAM, 6'd9, 14'd0, 8'd124};
Instr[492] <= {`OPVALID, `OPCODE_LDSRAM, 6'd10, 14'd0, 8'd100};
Instr[493] <= {`OPVALID, `OPCODE_LDSRAM, 6'd11, 14'd0, 8'd110};
Instr[494] <= {`OPVALID, `OPCODE_LDSRAM, 6'd12, 14'd0, -8'd17};
Instr[495] <= {`OPVALID, `OPCODE_LDSRAM, 6'd13, 14'd0, 8'd37};
Instr[496] <= {`OPVALID, `OPCODE_LDSRAM, 6'd14, 14'd0, 8'd22};
Instr[497] <= {`OPVALID, `OPCODE_LDSRAM, 6'd15, 14'd0, -8'd13};
Instr[498] <= {`OPVALID, `OPCODE_LDSRAM, 6'd16, 14'd0, -8'd73};
Instr[499] <= {`OPVALID, `OPCODE_LDSRAM, 6'd17, 14'd0, 8'd3};
Instr[500] <= {`OPVALID, `OPCODE_LDSRAM, 6'd18, 14'd0, 8'd125};
Instr[501] <= {`OPVALID, `OPCODE_LDSRAM, 6'd19, 14'd0, 8'd84};
Instr[502] <= {`OPVALID, `OPCODE_LDSRAM, 6'd20, 14'd0, -8'd88};
Instr[503] <= {`OPVALID, `OPCODE_LDSRAM, 6'd21, 14'd0, 8'd81};
Instr[504] <= {`OPVALID, `OPCODE_LDSRAM, 6'd22, 14'd0, 8'd79};
Instr[505] <= {`OPVALID, `OPCODE_LDSRAM, 6'd0, 14'd1, 8'd105};
Instr[506] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd1, -8'd58};
Instr[507] <= {`OPVALID, `OPCODE_LDSRAM, 6'd2, 14'd1, -8'd120};
Instr[508] <= {`OPVALID, `OPCODE_LDSRAM, 6'd3, 14'd1, -8'd36};
Instr[509] <= {`OPVALID, `OPCODE_LDSRAM, 6'd4, 14'd1, 8'd5};
Instr[510] <= {`OPVALID, `OPCODE_LDSRAM, 6'd5, 14'd1, -8'd122};
Instr[511] <= {`OPVALID, `OPCODE_LDSRAM, 6'd6, 14'd1, 8'd108};
Instr[512] <= {`OPVALID, `OPCODE_LDSRAM, 6'd7, 14'd1, -8'd57};
Instr[513] <= {`OPVALID, `OPCODE_LDSRAM, 6'd8, 14'd1, 8'd97};
Instr[514] <= {`OPVALID, `OPCODE_LDSRAM, 6'd9, 14'd1, 8'd8};
Instr[515] <= {`OPVALID, `OPCODE_LDSRAM, 6'd10, 14'd1, -8'd6};
Instr[516] <= {`OPVALID, `OPCODE_LDSRAM, 6'd11, 14'd1, -8'd112};
Instr[517] <= {`OPVALID, `OPCODE_LDSRAM, 6'd12, 14'd1, 8'd84};
Instr[518] <= {`OPVALID, `OPCODE_LDSRAM, 6'd13, 14'd1, -8'd79};
Instr[519] <= {`OPVALID, `OPCODE_LDSRAM, 6'd14, 14'd1, 8'd16};
Instr[520] <= {`OPVALID, `OPCODE_LDSRAM, 6'd15, 14'd1, 8'd115};
Instr[521] <= {`OPVALID, `OPCODE_LDSRAM, 6'd16, 14'd1, 8'd82};
Instr[522] <= {`OPVALID, `OPCODE_LDSRAM, 6'd17, 14'd1, 8'd57};
Instr[523] <= {`OPVALID, `OPCODE_LDSRAM, 6'd18, 14'd1, -8'd27};
Instr[524] <= {`OPVALID, `OPCODE_LDSRAM, 6'd19, 14'd1, 8'd15};
Instr[525] <= {`OPVALID, `OPCODE_LDSRAM, 6'd20, 14'd1, 8'd4};
Instr[526] <= {`OPVALID, `OPCODE_LDSRAM, 6'd21, 14'd1, -8'd95};
Instr[527] <= {`OPVALID, `OPCODE_LDSRAM, 6'd22, 14'd1, 8'd46};
Instr[528] <= {`OPVALID, `OPCODE_LDSRAM, 6'd0, 14'd2, -8'd97};
Instr[529] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd2, -8'd57};
Instr[530] <= {`OPVALID, `OPCODE_LDSRAM, 6'd2, 14'd2, 8'd10};
Instr[531] <= {`OPVALID, `OPCODE_LDSRAM, 6'd3, 14'd2, -8'd40};
Instr[532] <= {`OPVALID, `OPCODE_LDSRAM, 6'd4, 14'd2, -8'd66};
Instr[533] <= {`OPVALID, `OPCODE_LDSRAM, 6'd5, 14'd2, 8'd65};
Instr[534] <= {`OPVALID, `OPCODE_LDSRAM, 6'd6, 14'd2, -8'd109};
Instr[535] <= {`OPVALID, `OPCODE_LDSRAM, 6'd7, 14'd2, -8'd55};
Instr[536] <= {`OPVALID, `OPCODE_LDSRAM, 6'd8, 14'd2, 8'd43};
Instr[537] <= {`OPVALID, `OPCODE_LDSRAM, 6'd9, 14'd2, 8'd61};
Instr[538] <= {`OPVALID, `OPCODE_LDSRAM, 6'd10, 14'd2, -8'd89};
Instr[539] <= {`OPVALID, `OPCODE_LDSRAM, 6'd11, 14'd2, -8'd66};
Instr[540] <= {`OPVALID, `OPCODE_LDSRAM, 6'd12, 14'd2, 8'd91};
Instr[541] <= {`OPVALID, `OPCODE_LDSRAM, 6'd13, 14'd2, -8'd109};
Instr[542] <= {`OPVALID, `OPCODE_LDSRAM, 6'd14, 14'd2, -8'd65};
Instr[543] <= {`OPVALID, `OPCODE_LDSRAM, 6'd15, 14'd2, -8'd65};
Instr[544] <= {`OPVALID, `OPCODE_LDSRAM, 6'd16, 14'd2, -8'd13};
Instr[545] <= {`OPVALID, `OPCODE_LDSRAM, 6'd17, 14'd2, 8'd118};
Instr[546] <= {`OPVALID, `OPCODE_LDSRAM, 6'd18, 14'd2, -8'd106};
Instr[547] <= {`OPVALID, `OPCODE_LDSRAM, 6'd19, 14'd2, 8'd86};
Instr[548] <= {`OPVALID, `OPCODE_LDSRAM, 6'd20, 14'd2, -8'd54};
Instr[549] <= {`OPVALID, `OPCODE_LDSRAM, 6'd21, 14'd2, -8'd65};
Instr[550] <= {`OPVALID, `OPCODE_LDSRAM, 6'd22, 14'd2, -8'd94};
Instr[551] <= {`OPVALID, `OPCODE_LDSRAM, 6'd0, 14'd3, -8'd23};
Instr[552] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd3, -8'd93};
Instr[553] <= {`OPVALID, `OPCODE_LDSRAM, 6'd2, 14'd3, -8'd67};
Instr[554] <= {`OPVALID, `OPCODE_LDSRAM, 6'd3, 14'd3, -8'd2};
Instr[555] <= {`OPVALID, `OPCODE_LDSRAM, 6'd4, 14'd3, 8'd84};
Instr[556] <= {`OPVALID, `OPCODE_LDSRAM, 6'd5, 14'd3, 8'd87};
Instr[557] <= {`OPVALID, `OPCODE_LDSRAM, 6'd6, 14'd3, -8'd78};
Instr[558] <= {`OPVALID, `OPCODE_LDSRAM, 6'd7, 14'd3, -8'd64};
Instr[559] <= {`OPVALID, `OPCODE_LDSRAM, 6'd8, 14'd3, 8'd84};
Instr[560] <= {`OPVALID, `OPCODE_LDSRAM, 6'd9, 14'd3, 8'd48};
Instr[561] <= {`OPVALID, `OPCODE_LDSRAM, 6'd10, 14'd3, 8'd122};
Instr[562] <= {`OPVALID, `OPCODE_LDSRAM, 6'd11, 14'd3, 8'd58};
Instr[563] <= {`OPVALID, `OPCODE_LDSRAM, 6'd12, 14'd3, -8'd78};
Instr[564] <= {`OPVALID, `OPCODE_LDSRAM, 6'd13, 14'd3, -8'd104};
Instr[565] <= {`OPVALID, `OPCODE_LDSRAM, 6'd14, 14'd3, 8'd50};
Instr[566] <= {`OPVALID, `OPCODE_LDSRAM, 6'd15, 14'd3, -8'd11};
Instr[567] <= {`OPVALID, `OPCODE_LDSRAM, 6'd16, 14'd3, 8'd126};
Instr[568] <= {`OPVALID, `OPCODE_LDSRAM, 6'd17, 14'd3, -8'd41};
Instr[569] <= {`OPVALID, `OPCODE_LDSRAM, 6'd18, 14'd3, -8'd113};
Instr[570] <= {`OPVALID, `OPCODE_LDSRAM, 6'd19, 14'd3, 8'd12};
Instr[571] <= {`OPVALID, `OPCODE_LDSRAM, 6'd20, 14'd3, 8'd63};
Instr[572] <= {`OPVALID, `OPCODE_LDSRAM, 6'd21, 14'd3, 8'd77};
Instr[573] <= {`OPVALID, `OPCODE_LDSRAM, 6'd22, 14'd3, 8'd37};

// ISA (v1)
// OPVALID(1) / OPCODE(3) / SEL(4)+ADDR(16) or PARAM(20) / DATA(8): total(32)
// LDSRAM_W
Instr[574] <= {`OPVALID, `OPCODE_PARAM, `PARAM_TRG, `TRG_WSRAM};
Instr[575] <= {`OPVALID, `OPCODE_LDSRAM, 6'd0, 14'd0, 8'd89};
Instr[576] <= {`OPVALID, `OPCODE_LDSRAM, 6'd0, 14'd1, -8'd33};
Instr[577] <= {`OPVALID, `OPCODE_LDSRAM, 6'd0, 14'd2, -8'd92};
Instr[578] <= {`OPVALID, `OPCODE_LDSRAM, 6'd0, 14'd3, -8'd17};
Instr[579] <= {`OPVALID, `OPCODE_LDSRAM, 6'd0, 14'd4, 8'd44};
Instr[580] <= {`OPVALID, `OPCODE_LDSRAM, 6'd0, 14'd5, 8'd25};
Instr[581] <= {`OPVALID, `OPCODE_LDSRAM, 6'd0, 14'd6, 8'd19};
Instr[582] <= {`OPVALID, `OPCODE_LDSRAM, 6'd0, 14'd7, -8'd60};
Instr[583] <= {`OPVALID, `OPCODE_LDSRAM, 6'd0, 14'd8, 8'd61};
Instr[584] <= {`OPVALID, `OPCODE_LDSRAM, 6'd0, 14'd9, 8'd105};
Instr[585] <= {`OPVALID, `OPCODE_LDSRAM, 6'd0, 14'd10, -8'd70};
Instr[586] <= {`OPVALID, `OPCODE_LDSRAM, 6'd0, 14'd11, -8'd9};
Instr[587] <= {`OPVALID, `OPCODE_LDSRAM, 6'd0, 14'd12, 8'd55};
Instr[588] <= {`OPVALID, `OPCODE_LDSRAM, 6'd0, 14'd13, 8'd18};
Instr[589] <= {`OPVALID, `OPCODE_LDSRAM, 6'd0, 14'd14, -8'd12};
Instr[590] <= {`OPVALID, `OPCODE_LDSRAM, 6'd0, 14'd15, 8'd37};
Instr[591] <= {`OPVALID, `OPCODE_LDSRAM, 6'd0, 14'd16, 8'd118};
Instr[592] <= {`OPVALID, `OPCODE_LDSRAM, 6'd0, 14'd17, 8'd109};
Instr[593] <= {`OPVALID, `OPCODE_LDSRAM, 6'd0, 14'd18, -8'd74};
Instr[594] <= {`OPVALID, `OPCODE_LDSRAM, 6'd0, 14'd19, -8'd5};
Instr[595] <= {`OPVALID, `OPCODE_LDSRAM, 6'd0, 14'd20, 8'd42};
Instr[596] <= {`OPVALID, `OPCODE_LDSRAM, 6'd0, 14'd21, 8'd110};
Instr[597] <= {`OPVALID, `OPCODE_LDSRAM, 6'd0, 14'd22, 8'd46};
Instr[598] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd0, -8'd107};
Instr[599] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd1, 8'd102};
Instr[600] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd2, -8'd103};
Instr[601] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd3, -8'd28};
Instr[602] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd4, 8'd39};
Instr[603] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd5, 8'd113};
Instr[604] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd6, 8'd102};
Instr[605] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd7, -8'd25};
Instr[606] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd8, 8'd29};
Instr[607] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd9, -8'd120};
Instr[608] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd10, -8'd68};
Instr[609] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd11, -8'd82};
Instr[610] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd12, -8'd124};
Instr[611] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd13, -8'd41};
Instr[612] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd14, -8'd43};
Instr[613] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd15, -8'd21};
Instr[614] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd16, -8'd127};
Instr[615] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd17, -8'd65};
Instr[616] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd18, 8'd52};
Instr[617] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd19, 8'd111};
Instr[618] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd20, 8'd10};
Instr[619] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd21, -8'd23};
Instr[620] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd22, -8'd82};
Instr[621] <= {`OPVALID, `OPCODE_LDSRAM, 6'd2, 14'd0, 8'd104};
Instr[622] <= {`OPVALID, `OPCODE_LDSRAM, 6'd2, 14'd1, -8'd17};
Instr[623] <= {`OPVALID, `OPCODE_LDSRAM, 6'd2, 14'd2, 8'd60};
Instr[624] <= {`OPVALID, `OPCODE_LDSRAM, 6'd2, 14'd3, 8'd106};
Instr[625] <= {`OPVALID, `OPCODE_LDSRAM, 6'd2, 14'd4, -8'd88};
Instr[626] <= {`OPVALID, `OPCODE_LDSRAM, 6'd2, 14'd5, 8'd82};
Instr[627] <= {`OPVALID, `OPCODE_LDSRAM, 6'd2, 14'd6, -8'd7};
Instr[628] <= {`OPVALID, `OPCODE_LDSRAM, 6'd2, 14'd7, 8'd88};
Instr[629] <= {`OPVALID, `OPCODE_LDSRAM, 6'd2, 14'd8, 8'd60};
Instr[630] <= {`OPVALID, `OPCODE_LDSRAM, 6'd2, 14'd9, 8'd55};
Instr[631] <= {`OPVALID, `OPCODE_LDSRAM, 6'd2, 14'd10, -8'd45};
Instr[632] <= {`OPVALID, `OPCODE_LDSRAM, 6'd2, 14'd11, -8'd7};
Instr[633] <= {`OPVALID, `OPCODE_LDSRAM, 6'd2, 14'd12, 8'd113};
Instr[634] <= {`OPVALID, `OPCODE_LDSRAM, 6'd2, 14'd13, 8'd74};
Instr[635] <= {`OPVALID, `OPCODE_LDSRAM, 6'd2, 14'd14, -8'd46};
Instr[636] <= {`OPVALID, `OPCODE_LDSRAM, 6'd2, 14'd15, -8'd88};
Instr[637] <= {`OPVALID, `OPCODE_LDSRAM, 6'd2, 14'd16, 8'd31};
Instr[638] <= {`OPVALID, `OPCODE_LDSRAM, 6'd2, 14'd17, 8'd17};
Instr[639] <= {`OPVALID, `OPCODE_LDSRAM, 6'd2, 14'd18, 8'd29};
Instr[640] <= {`OPVALID, `OPCODE_LDSRAM, 6'd2, 14'd19, 8'd126};
Instr[641] <= {`OPVALID, `OPCODE_LDSRAM, 6'd2, 14'd20, -8'd97};
Instr[642] <= {`OPVALID, `OPCODE_LDSRAM, 6'd2, 14'd21, 8'd99};
Instr[643] <= {`OPVALID, `OPCODE_LDSRAM, 6'd2, 14'd22, 8'd27};
Instr[644] <= {`OPVALID, `OPCODE_LDSRAM, 6'd3, 14'd0, -8'd103};
Instr[645] <= {`OPVALID, `OPCODE_LDSRAM, 6'd3, 14'd1, 8'd69};
Instr[646] <= {`OPVALID, `OPCODE_LDSRAM, 6'd3, 14'd2, 8'd110};
Instr[647] <= {`OPVALID, `OPCODE_LDSRAM, 6'd3, 14'd3, -8'd79};
Instr[648] <= {`OPVALID, `OPCODE_LDSRAM, 6'd3, 14'd4, -8'd35};
Instr[649] <= {`OPVALID, `OPCODE_LDSRAM, 6'd3, 14'd5, -8'd113};
Instr[650] <= {`OPVALID, `OPCODE_LDSRAM, 6'd3, 14'd6, 8'd3};
Instr[651] <= {`OPVALID, `OPCODE_LDSRAM, 6'd3, 14'd7, 8'd85};
Instr[652] <= {`OPVALID, `OPCODE_LDSRAM, 6'd3, 14'd8, -8'd35};
Instr[653] <= {`OPVALID, `OPCODE_LDSRAM, 6'd3, 14'd9, -8'd16};
Instr[654] <= {`OPVALID, `OPCODE_LDSRAM, 6'd3, 14'd10, 8'd79};
Instr[655] <= {`OPVALID, `OPCODE_LDSRAM, 6'd3, 14'd11, 8'd24};
Instr[656] <= {`OPVALID, `OPCODE_LDSRAM, 6'd3, 14'd12, -8'd102};
Instr[657] <= {`OPVALID, `OPCODE_LDSRAM, 6'd3, 14'd13, -8'd88};
Instr[658] <= {`OPVALID, `OPCODE_LDSRAM, 6'd3, 14'd14, 8'd112};
Instr[659] <= {`OPVALID, `OPCODE_LDSRAM, 6'd3, 14'd15, -8'd65};
Instr[660] <= {`OPVALID, `OPCODE_LDSRAM, 6'd3, 14'd16, -8'd31};
Instr[661] <= {`OPVALID, `OPCODE_LDSRAM, 6'd3, 14'd17, 8'd104};
Instr[662] <= {`OPVALID, `OPCODE_LDSRAM, 6'd3, 14'd18, 8'd42};
Instr[663] <= {`OPVALID, `OPCODE_LDSRAM, 6'd3, 14'd19, 8'd87};
Instr[664] <= {`OPVALID, `OPCODE_LDSRAM, 6'd3, 14'd20, -8'd34};
Instr[665] <= {`OPVALID, `OPCODE_LDSRAM, 6'd3, 14'd21, 8'd69};
Instr[666] <= {`OPVALID, `OPCODE_LDSRAM, 6'd3, 14'd22, 8'd70};
Instr[667] <= {`OPVALID, `OPCODE_LDSRAM, 6'd4, 14'd0, 8'd25};
Instr[668] <= {`OPVALID, `OPCODE_LDSRAM, 6'd4, 14'd1, -8'd97};
Instr[669] <= {`OPVALID, `OPCODE_LDSRAM, 6'd4, 14'd2, -8'd70};
Instr[670] <= {`OPVALID, `OPCODE_LDSRAM, 6'd4, 14'd3, 8'd124};
Instr[671] <= {`OPVALID, `OPCODE_LDSRAM, 6'd4, 14'd4, 8'd27};
Instr[672] <= {`OPVALID, `OPCODE_LDSRAM, 6'd4, 14'd5, 8'd27};
Instr[673] <= {`OPVALID, `OPCODE_LDSRAM, 6'd4, 14'd6, -8'd68};
Instr[674] <= {`OPVALID, `OPCODE_LDSRAM, 6'd4, 14'd7, 8'd109};
Instr[675] <= {`OPVALID, `OPCODE_LDSRAM, 6'd4, 14'd8, 8'd3};
Instr[676] <= {`OPVALID, `OPCODE_LDSRAM, 6'd4, 14'd9, -8'd61};
Instr[677] <= {`OPVALID, `OPCODE_LDSRAM, 6'd4, 14'd10, -8'd90};
Instr[678] <= {`OPVALID, `OPCODE_LDSRAM, 6'd4, 14'd11, 8'd29};
Instr[679] <= {`OPVALID, `OPCODE_LDSRAM, 6'd4, 14'd12, -8'd35};
Instr[680] <= {`OPVALID, `OPCODE_LDSRAM, 6'd4, 14'd13, -8'd96};
Instr[681] <= {`OPVALID, `OPCODE_LDSRAM, 6'd4, 14'd14, 8'd99};
Instr[682] <= {`OPVALID, `OPCODE_LDSRAM, 6'd4, 14'd15, -8'd87};
Instr[683] <= {`OPVALID, `OPCODE_LDSRAM, 6'd4, 14'd16, 8'd46};
Instr[684] <= {`OPVALID, `OPCODE_LDSRAM, 6'd4, 14'd17, -8'd81};
Instr[685] <= {`OPVALID, `OPCODE_LDSRAM, 6'd4, 14'd18, -8'd31};
Instr[686] <= {`OPVALID, `OPCODE_LDSRAM, 6'd4, 14'd19, 8'd1};
Instr[687] <= {`OPVALID, `OPCODE_LDSRAM, 6'd4, 14'd20, -8'd92};
Instr[688] <= {`OPVALID, `OPCODE_LDSRAM, 6'd4, 14'd21, -8'd56};
Instr[689] <= {`OPVALID, `OPCODE_LDSRAM, 6'd4, 14'd22, -8'd87};
Instr[690] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd23, 8'd0};
Instr[691] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd24, 8'd0};
Instr[692] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd25, 8'd0};
Instr[693] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd26, 8'd0};
Instr[694] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd27, 8'd0};
Instr[695] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd28, 8'd0};
Instr[696] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd29, 8'd0};
Instr[697] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd30, 8'd0};
Instr[698] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd31, 8'd0};
Instr[699] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd32, 8'd0};
Instr[700] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd33, 8'd0};
Instr[701] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd34, 8'd0};
Instr[702] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd35, 8'd0};
Instr[703] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd36, 8'd0};
Instr[704] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd37, 8'd0};
Instr[705] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd38, 8'd0};
Instr[706] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd39, 8'd0};
Instr[707] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd40, 8'd0};
Instr[708] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd41, 8'd0};
Instr[709] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd42, 8'd0};
Instr[710] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd43, 8'd0};
Instr[711] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd44, 8'd0};
Instr[712] <= {`OPVALID, `OPCODE_LDSRAM, 6'd1, 14'd45, 8'd0};

// Execute
Instr[713] <= {`OPVALID, `OPCODE_PARAM, `PARAM_BASE_WSRAM, 8'd0};
Instr[714] <= {`OPVALID, `OPCODE_EX, 20'd0, 8'd0};
Instr[715] <= {`OPVALID, `OPCODE_NOP, 20'd0, 8'd0};


Instr[860] <= {`OPVALID, `OPCODE_WBPSRAM, 6'd0, 14'd0, 8'd0};
Instr[861] <= {`OPVALID, `OPCODE_WBPSRAM, 6'd0, 14'd1, 8'd0};
Instr[862] <= {`OPVALID, `OPCODE_WBPSRAM, 6'd0, 14'd2, 8'd0};
Instr[863] <= {`OPVALID, `OPCODE_WBPSRAM, 6'd0, 14'd3, 8'd0};
Instr[864] <= {`OPVALID, `OPCODE_WBPSRAM, 6'd1, 14'd0, 8'd0};
Instr[865] <= {`OPVALID, `OPCODE_WBPSRAM, 6'd1, 14'd1, 8'd0};
Instr[866] <= {`OPVALID, `OPCODE_WBPSRAM, 6'd1, 14'd2, 8'd0};
Instr[867] <= {`OPVALID, `OPCODE_WBPSRAM, 6'd1, 14'd3, 8'd0};
Instr[868] <= {`OPVALID, `OPCODE_WBPSRAM, 6'd2, 14'd0, 8'd0};
Instr[869] <= {`OPVALID, `OPCODE_WBPSRAM, 6'd2, 14'd1, 8'd0};
Instr[870] <= {`OPVALID, `OPCODE_WBPSRAM, 6'd2, 14'd2, 8'd0};
Instr[871] <= {`OPVALID, `OPCODE_WBPSRAM, 6'd2, 14'd3, 8'd0};
Instr[872] <= {`OPVALID, `OPCODE_WBPSRAM, 6'd3, 14'd0, 8'd0};
Instr[873] <= {`OPVALID, `OPCODE_WBPSRAM, 6'd3, 14'd1, 8'd0};
Instr[874] <= {`OPVALID, `OPCODE_WBPSRAM, 6'd3, 14'd2, 8'd0};
Instr[875] <= {`OPVALID, `OPCODE_WBPSRAM, 6'd3, 14'd3, 8'd0};
Instr[876] <= {`OPVALID, `OPCODE_WBPSRAM, 6'd4, 14'd0, 8'd0};
Instr[877] <= {`OPVALID, `OPCODE_WBPSRAM, 6'd4, 14'd1, 8'd0};
Instr[878] <= {`OPVALID, `OPCODE_WBPSRAM, 6'd4, 14'd2, 8'd0};
Instr[879] <= {`OPVALID, `OPCODE_WBPSRAM, 6'd4, 14'd3, 8'd0};

Instr[880] <= {`OPVALID, `OPCODE_NOP, 20'd0, 8'd0};

end
        





endmodule