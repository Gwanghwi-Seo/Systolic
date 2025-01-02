`timescale 1ns / 1ps
`include "param.v"

module pe( CLK, Row_ID, Data_I_In, Data_I_Out, Data_W_In, Data_W_Out, EN_W_In, EN_W_Out, EN_ID_In, EN_ID_Out, Psum_In, Psum_Out,
Addr_P_In,
Valid_P_In,
Addr_P_Out,
Valid_P_Out );

input CLK;
input [`BIT_ROW_ID-1:0] Row_ID;
input signed [`BIT_DATA-1:0] Data_I_In, Data_W_In;
output reg signed [`BIT_DATA-1:0] Data_I_Out, Data_W_Out;
input EN_W_In;
output reg EN_W_Out;
input [`BIT_ROW_ID-1:0] EN_ID_In;
output reg [`BIT_ROW_ID-1:0] EN_ID_Out;
input signed [`BIT_PSUM-1:0] Psum_In;
output reg signed [`BIT_PSUM-1:0] Psum_Out;

input [`BIT_ADDR-1:0]   Addr_P_In;
input [`BIT_VALID-1:0]  Valid_P_In;
output reg [`BIT_ADDR-1:0] Addr_P_Out;
output reg [`BIT_VALID-1:0] Valid_P_Out;

reg signed [`BIT_DATA-1:0] Data_W_Buf;

always @(posedge CLK) begin
    Data_I_Out <= Data_I_In;
    Data_W_Out <= Data_W_In;
    EN_W_Out <= EN_W_In;
    EN_ID_Out <= EN_ID_In;
    Addr_P_Out <= Addr_P_In;
    Valid_P_Out <= Valid_P_In;
    
    if (EN_W_In & (EN_ID_In == Row_ID)) begin
        Data_W_Buf <= Data_W_In;
    end
    else if (!EN_W_In & (EN_ID_In == Row_ID)) begin
        Data_W_Buf <= 0;
    end
    
    Psum_Out <= Data_I_In * Data_W_Buf + Psum_In;
end

endmodule
