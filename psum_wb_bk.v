module psum_wb(
    CLK, 
    i_Psum_Bank0, i_Psum_Bank1, i_Psum_Bank2, i_Psum_Bank3,
    i_Psum_Bank4, i_Psum_Bank5, i_Psum_Bank6, i_Psum_Bank7,
    i_Psum_Bank8, i_Psum_Bank9, i_Psum_Bank10, i_Psum_Bank11,
    i_Psum_Bank12, i_Psum_Bank13, i_Psum_Bank14, i_Psum_Bank15,
    i_Psum_Bank16, i_Psum_Bank17, i_Psum_Bank18, i_Psum_Bank19,
    i_Psum_Bank20, i_Psum_Bank21, i_Psum_Bank22, i_Psum_Bank23,
    i_Psum_Bank24, i_Psum_Bank25, i_Psum_Bank26, i_Psum_Bank27,
    i_Psum_Bank28, i_Psum_Bank29, i_Psum_Bank30, i_Psum_Bank31,
    i_Psram_En, i_Valid_WB_Psum,
    o_Data_WB_Out, o_Valid_WB_Psum
);

input CLK;
input [`BIT_PSUM-1:0] i_Psum_Bank0, i_Psum_Bank1, i_Psum_Bank2, i_Psum_Bank3;
input [`BIT_PSUM-1:0] i_Psum_Bank4, i_Psum_Bank5, i_Psum_Bank6, i_Psum_Bank7;
input [`BIT_PSUM-1:0] i_Psum_Bank8, i_Psum_Bank9, i_Psum_Bank10, i_Psum_Bank11;
input [`BIT_PSUM-1:0] i_Psum_Bank12, i_Psum_Bank13, i_Psum_Bank14, i_Psum_Bank15;
input [`BIT_PSUM-1:0] i_Psum_Bank16, i_Psum_Bank17, i_Psum_Bank18, i_Psum_Bank19;
input [`BIT_PSUM-1:0] i_Psum_Bank20, i_Psum_Bank21, i_Psum_Bank22, i_Psum_Bank23;
input [`BIT_PSUM-1:0] i_Psum_Bank24, i_Psum_Bank25, i_Psum_Bank26, i_Psum_Bank27;
input [`BIT_PSUM-1:0] i_Psum_Bank28, i_Psum_Bank29, i_Psum_Bank30, i_Psum_Bank31;
input [`PE_COL-1:0] i_Psram_En;
input i_Valid_WB_Psum;

output reg [`BIT_PSUM-1:0] o_Data_WB_Out;
output reg o_Valid_WB_Psum;

reg [`PE_COL-1:0] Psram_En_1buf, Psram_En_2buf;
reg Valid_WB_Psum_1buf, Valid_WB_Psum_2buf;


always@(posedge CLK) begin
    Valid_WB_Psum_1buf <= i_Valid_WB_Psum;
    Valid_WB_Psum_2buf <= Valid_WB_Psum_1buf;

    Psram_En_1buf <= i_Psram_En;
    Psram_En_2buf <= Psram_En_1buf;

    if(Valid_WB_Psum_2buf) begin
        case(Psram_En_2buf)
        `PE_COL'b0000_0000_0000_0000_0000_0000_0000_0001:
            o_Data_WB_Out <= i_Psum_Bank0;
        `PE_COL'b0000_0000_0000_0000_0000_0000_0000_0010:
            o_Data_WB_Out <= i_Psum_Bank1;
        `PE_COL'b0000_0000_0000_0000_0000_0000_0000_0100:
            o_Data_WB_Out <= i_Psum_Bank2;
        `PE_COL'b0000_0000_0000_0000_0000_0000_0000_1000:
            o_Data_WB_Out <= i_Psum_Bank3;
        `PE_COL'b0000_0000_0000_0000_0000_0000_0001_0000:
            o_Data_WB_Out <= i_Psum_Bank4;
        `PE_COL'b0000_0000_0000_0000_0000_0000_0010_0000:
            o_Data_WB_Out <= i_Psum_Bank5;
        `PE_COL'b0000_0000_0000_0000_0000_0000_0100_0000:
            o_Data_WB_Out <= i_Psum_Bank6;
        `PE_COL'b0000_0000_0000_0000_0000_0000_1000_0000:
            o_Data_WB_Out <= i_Psum_Bank7;
        `PE_COL'b0000_0000_0000_0000_0000_0001_0000_0000:
            o_Data_WB_Out <= i_Psum_Bank8;
        `PE_COL'b0000_0000_0000_0000_0000_0010_0000_0000:
            o_Data_WB_Out <= i_Psum_Bank9;
        `PE_COL'b0000_0000_0000_0000_0000_0100_0000_0000:
            o_Data_WB_Out <= i_Psum_Bank10;
        `PE_COL'b0000_0000_0000_0000_0000_1000_0000_0000:
            o_Data_WB_Out <= i_Psum_Bank11;
        `PE_COL'b0000_0000_0000_0000_0001_0000_0000_0000:
            o_Data_WB_Out <= i_Psum_Bank12;
        `PE_COL'b0000_0000_0000_0000_0010_0000_0000_0000:
            o_Data_WB_Out <= i_Psum_Bank13;
        `PE_COL'b0000_0000_0000_0000_0100_0000_0000_0000:
            o_Data_WB_Out <= i_Psum_Bank14;
        `PE_COL'b0000_0000_0000_0000_1000_0000_0000_0000:
            o_Data_WB_Out <= i_Psum_Bank15;
        `PE_COL'b0000_0000_0000_0001_0000_0000_0000_0000:
            o_Data_WB_Out <= i_Psum_Bank16;
        `PE_COL'b0000_0000_0000_0010_0000_0000_0000_0000:
            o_Data_WB_Out <= i_Psum_Bank17;
        `PE_COL'b0000_0000_0000_0100_0000_0000_0000_0000:
            o_Data_WB_Out <= i_Psum_Bank18;
        `PE_COL'b0000_0000_0000_1000_0000_0000_0000_0000:
            o_Data_WB_Out <= i_Psum_Bank19;
        `PE_COL'b0000_0000_0001_0000_0000_0000_0000_0000:
            o_Data_WB_Out <= i_Psum_Bank20;
        `PE_COL'b0000_0000_0010_0000_0000_0000_0000_0000:
            o_Data_WB_Out <= i_Psum_Bank21;
        `PE_COL'b0000_0000_0100_0000_0000_0000_0000_0000:
            o_Data_WB_Out <= i_Psum_Bank22;
        `PE_COL'b0000_0000_1000_0000_0000_0000_0000_0000:
            o_Data_WB_Out <= i_Psum_Bank23;
        `PE_COL'b0000_0001_0000_0000_0000_0000_0000_0000:
            o_Data_WB_Out <= i_Psum_Bank24;
        `PE_COL'b0000_0010_0000_0000_0000_0000_0000_0000:
            o_Data_WB_Out <= i_Psum_Bank25;
        `PE_COL'b0000_0100_0000_0000_0000_0000_0000_0000:
            o_Data_WB_Out <= i_Psum_Bank26;
        `PE_COL'b0000_1000_0000_0000_0000_0000_0000_0000:
            o_Data_WB_Out <= i_Psum_Bank27;
        `PE_COL'b0001_0000_0000_0000_0000_0000_0000_0000:
            o_Data_WB_Out <= i_Psum_Bank28;
        `PE_COL'b0010_0000_0000_0000_0000_0000_0000_0000:
            o_Data_WB_Out <= i_Psum_Bank29;
        `PE_COL'b0100_0000_0000_0000_0000_0000_0000_0000:
            o_Data_WB_Out <= i_Psum_Bank30;
        `PE_COL'b1000_0000_0000_0000_0000_0000_0000_0000:
            o_Data_WB_Out <= i_Psum_Bank31; 
        default: 
            o_Data_WB_Out <= 0;
        endcase
            o_Valid_WB_Psum <= 1'b1;
    end
    else begin
        o_Data_WB_Out <= 0;
        o_Valid_WB_Psum <= 0;

    end
end
endmodule