module param_wb(
    CLK, 
    i_Param_WB, i_Valid_WB_Param,
    o_Data_WB_Out
);

input CLK;
input [`BIT_DATA-1:0] i_Param_WB;
input i_Valid_WB_Param;

output reg [`BIT_PSUM-1:0] o_Data_WB_Out;

always@(posedge CLK) begin

    if(i_Valid_WB_Param) begin
        o_Data_WB_Out <= {{16{1'b0}} , i_Param_WB};
    end
    else begin
        o_Data_WB_Out <= 0;
    end
end


endmodule