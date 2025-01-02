`timescale 1ns / 1ps
`include "param.v"

module systolic_signal_loader_p (
    CLK,
    i_Psram_Addr, 
    i_Psram_Addr_1buf,
    i_Psram_Valid_1buf, 
    i_Psram_En, 
    i_Psram_Wea,
    i_Valid_WB_Psum,
    o_Psram_Addr_To_Sram,
    o_Psram_Addr_To_Systolic,
    o_Psram_En_To_Sram,
    o_Psram_Wea_To_Sram,
    o_Psram_Valid_To_Systolic
     );
input CLK;
input [`BIT_ADDR-1:0] i_Psram_Addr, i_Psram_Addr_1buf; //need *PE_COL
input [`PE_COL-1:0]i_Psram_Valid_1buf; //psram_write
input [`PE_COL-1:0]i_Psram_En, i_Psram_Wea;
// input i_Valid_WB_Psum;

output [`BIT_ADDR*`PE_COL-1:0] o_Psram_Addr_To_Sram; //use psum_read
// output [`BIT_ADDR*`PE_COL-1:0] o_Psram_Addr_To_Systolic; //use psum_write_in_1buf
output [`PE_COL-1:0] o_Psram_En_To_Sram; //use psum_init & fsm_run(psum_read_en)
// output [`PE_COL-1:0] o_Psram_Wea_To_Sram; //use psum_init
output [`PE_COL-1:0] o_Psram_Valid_To_Systolic; //use psum_write


reg [`BIT_ADDR-1:0] Psram_Addr_To_Sram_1 [0:0];
reg [`BIT_ADDR-1:0] Psram_Addr_To_Sram_2 [1:0];
reg [`BIT_ADDR-1:0] Psram_Addr_To_Sram_3 [2:0];

reg [`BIT_ADDR-1:0] Psram_Addr_To_Systolic_1[0:0];
reg [`BIT_ADDR-1:0] Psram_Addr_To_Systolic_2[1:0];
reg [`BIT_ADDR-1:0] Psram_Addr_To_Systolic_3[2:0];

reg Psram_En_To_Sram_1[0:0];
reg Psram_En_To_Sram_2[1:0];
reg Psram_En_To_Sram_3[2:0];

// reg Psram_Wea_To_Sram_1[0:0];
// reg Psram_Wea_To_Sram_2[1:0];
// reg Psram_Wea_To_Sram_3[2:0];

reg Psram_Valid_To_Systolic_1[0:0];
reg Psram_Valid_To_Systolic_2[1:0];
reg Psram_Valid_To_Systolic_3[2:0];



assign o_Psram_Addr_To_Sram[0*`BIT_ADDR+:`BIT_ADDR] = i_Psram_Addr;
assign o_Psram_Addr_To_Sram[1*`BIT_ADDR+:`BIT_ADDR] = Addr_FIFO_1[0];
assign o_Psram_Addr_To_Sram[2*`BIT_ADDR+:`BIT_ADDR] = Addr_FIFO_2[0];
assign o_Psram_Addr_To_Sram[3*`BIT_ADDR+:`BIT_ADDR] = Addr_FIFO_3[0];

assign o_Psram_En_To_Sram[0] = i_Psram_En[0];
assign o_Psram_En_To_Sram[1] = Psram_En_To_Sram_1[0];
assign o_Psram_En_To_Sram[2] = Psram_En_To_Sram_2[0];
assign o_Psram_En_To_Sram[3] = Psram_En_To_Sram_3[0];

// assign o_Psram_Wea_To_Sram[0] = i_Psram_Wea[0];
// assign o_Psram_Wea_To_Sram[1] = Psram_Wea_To_Sram_1[0];
// assign o_Psram_Wea_To_Sram[2] = Psram_Wea_To_Sram_2[0];
// assign o_Psram_Wea_To_Sram[3] = Psram_Wea_To_Sram_3[0];

assign o_Psram_Valid_To_Systolic[0] = i_Psram_Valid_1buf[0];
assign o_Psram_Valid_To_Systolic[1] = Psram_Valid_To_Systolic_1[0];
assign o_Psram_Valid_To_Systolic[2] = Psram_Valid_To_Systolic_2[0];
assign o_Psram_Valid_To_Systolic[3] = Psram_Valid_To_Systolic_3[0];

/////// Psram_Addr_To_Sram //////////////
// Level 1
always @(posedge CLK) begin
    Addr_FIFO_1[0] <= i_Psram_Addr;
    Addr_FIFO_2[0] <= Addr_FIFO_2[1];
    Addr_FIFO_3[0] <= Addr_FIFO_3[1];
end

// Level 2
always @(posedge CLK) begin
    Addr_FIFO_2[1] <= i_Psram_Addr;
    Addr_FIFO_3[1] <= Addr_FIFO_3[2];
end

// Level 3
always @(posedge CLK) begin
    Addr_FIFO_3[2] <= i_Psram_Addr;
end

/////// Psram_En_To_Sram //////////////
// Level 1
always @(posedge CLK) begin
    Psram_En_To_Sram_1[0] <= i_Psram_En[1];
    Psram_En_To_Sram_2[0] <= Psram_En_To_Sram_2[1];
    Psram_En_To_Sram_3[0] <= Psram_En_To_Sram_3[1];
end

// Level 2
always @(posedge CLK) begin
    Psram_En_To_Sram_2[1] <= i_Psram_En[2];
    Psram_En_To_Sram_3[1] <= Psram_En_To_Sram_3[2];
end

// Level 3
always @(posedge CLK) begin
    Psram_En_To_Sram_3[2] <= i_Psram_En[3];
end

/////// Psram_Valid_To_Systolic //////////////
// Level 1
always @(posedge CLK) begin
    Psram_Valid_To_Systolic_1[0] <= i_Psram_Valid_1buf[1];
    Psram_Valid_To_Systolic_2[0] <= Psram_Valid_To_Systolic_2[1];
    Psram_Valid_To_Systolic_3[0] <= Psram_Valid_To_Systolic_3[1];
end

// Level 2
always @(posedge CLK) begin
    Psram_Valid_To_Systolic_2[1] <= i_Psram_Valid_1buf[2];
    Psram_Valid_To_Systolic_3[1] <= Psram_Valid_To_Systolic_3[2];
end

// Level 3
always @(posedge CLK) begin
    Psram_Valid_To_Systolic_3[2] <= i_Psram_Valid_1buf[3];
end

endmodule