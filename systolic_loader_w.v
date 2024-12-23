`include "./param.v"

module systolic_loader_w(
    CLK, RST,
    i_Systolic_En_ID, i_Systolic_En_W, 
    o_Systolic_En_ID, o_Systolic_En_W);
output reg[`PE_COL-1:0] o_Systolic_En_W;
output reg[`BIT_ROW_ID-1:0] o_Systolic_En_ID;

reg [`PE_COL-1:0] En_Id_1buf;
reg [`BIT_ROW_ID-1:0] En_W_1buf;

input CLK,RST;
input [`PE_COL-1:0] i_Systolic_En_W;
input [`BIT_ROW_ID-1:0] i_Systolic_En_ID;

always@(posedge CLK,posedge RST)
begin  
    if(RST) begin
        o_Systolic_En_ID <= 0;
        o_Systolic_En_W <= 0;
        En_Id_1buf <= 0;
        En_W_1buf <= 0;
    end
    else begin
        o_Systolic_En_ID <= i_Systolic_En_ID;
        o_Systolic_En_W <= i_Systolic_En_W;

        // En_Id_1buf <= i_Systolic_En_ID;
        // o_Systolic_En_ID <= En_Id_1buf;
        // En_W_1buf <= i_Systolic_En_W;
        // o_Systolic_En_W <= En_W_1buf;
    end
end

endmodule

