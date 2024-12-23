`include "./param.v"
module SA(
    CLK,
    RSTb,
    i_Instr_In,
    o_Flag_Finish_Out,
    o_Valid_WB_Out,
    o_Data_WB_Out,
    o_Instr_Flag
);
input CLK, RSTb;
input [`BIT_INSTR-1:0] i_Instr_In;
output o_Flag_Finish_Out;
output o_Valid_WB_Out;
output [`BIT_PSUM-1:0] o_Data_WB_Out;
output o_Instr_Flag;

SA_core systolic_core(
    .CLK(CLK),
    .RSTb(RSTb),
    .i_Instr_In(i_Instr_In),
    .o_Flag_Finish_Out(o_Flag_Finish_Out),
    .o_Valid_WB_Out(o_Valid_WB_Out),
    .o_Data_WB_Out(o_Data_WB_Out),
    .o_Instr_Flag(o_Instr_Flag)
);
endmodule

