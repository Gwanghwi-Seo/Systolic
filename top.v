`include "./param.v"

module top (CLK, RSTb, i_Instr_In, o_Flag_Finish_Out, o_Valid_WB_Out, o_Data_WB_Out,o_Instr_Flag);

input CLK, RSTb;
wire RST = ~RSTb;
input [`BIT_INSTR-1:0] i_Instr_In;
output o_Flag_Finish_Out;
output o_Valid_WB_Out;
output [`BIT_PSUM-1:0] o_Data_WB_Out;
output o_Instr_Flag;
// output [`BIT_PARAM-1:0] o_WB_Param_Out;

wire [`BIT_DATA-1:0] Instr_Data;
wire [`PE_ROW-1:0] Isram_En_One, Isram_En_Two;
wire [`PE_ROW-1:0] Isram_Wea_One, Isram_Wea_Two;
wire [`BIT_ADDR-1:0] Isram_Addr_One, Isram_Addr_Two;
wire [`PE_COL-1:0] Wsram_En_One, Wsram_En_Two;
wire [`PE_COL-1:0] Wsram_Wea_One, Wsram_Wea_Two;
wire [`BIT_ADDR-1:0] Wsram_Addr_One, Wsram_Addr_Two;
wire [`PE_COL-1:0] Psram_En_One, Psram_En_Two;
wire [`PE_COL-1:0] Psram_En;
wire [`PE_COL-1:0] Psram_En_WB_One, Psram_En_WB_Two;
wire [`BIT_ADDR-1:0] Psram_Addr_WB_One, Psram_Addr_WB_Two;
// wire [`PE_COL-1:0] Psram_Wea_One, Psram_Wea_Two;
wire [`PE_COL-1:0] Psram_Valid_One;
wire [`PE_COL-1:0] Psram_Valid_Two;
wire [`PE_COL-1:0] Psram_Valid, Psram_Valid_1buf;
wire [`BIT_ADDR-1:0] Psram_Addr;
wire [`BIT_ADDR*`PE_COL-1:0] Loader_Psram_Addr, Loader_Psram_Addr_Buf;
wire [`PE_COL-1:0] Loader_Psram_En, Loader_Psram_Valid_Buf;
wire [`BIT_ADDR-1:0] Init_Psram_Addr_One, Init_Psram_Addr_Two;
wire [`BIT_ADDR-1:0] Psram_Addr_One, Psram_Addr_Two;
wire Init_Psram_En_One, Init_Psram_En_Two;
wire Init_Psram_Wea_One, Init_Psram_Wea_Two;
wire[`BIT_ADDR*`PE_COL-1:0] Loader_Psram_Addr_One, Loader_Psram_Addr_Two;
wire[`PE_COL-1:0] Loader_Psram_En_One, Loader_Psram_En_Two;


wire [`BIT_ROW_ID-1:0] Systolic_En_ID;
wire [`PE_COL-1:0] Systolic_En_W;

wire [`PE_COL*`BIT_DATA-1:0] Wsram_Data_Buf;
wire [`PE_COL*`BIT_DATA-1:0] Wsram_Data_One, Wsram_Data_Two;
wire [`PE_COL*`BIT_DATA-1:0] Wsram_Data_Buf_One, Wsram_Data_Buf_Two;
wire [`BIT_ROW_ID-1:0] Systolic_En_ID_1buf;
wire [`PE_COL-1:0] Systolic_En_W_1buf;

// wire[`PE_ROW*`BIT_DATA-1:0] Isram_Data, Isram_Data_Buf;
wire[`PE_ROW*`BIT_DATA-1:0] Isram_Data_One, Isram_Data_Two;
wire[`PE_ROW*`BIT_DATA-1:0] Isram_Data_Buf_One, Isram_Data_Buf_Two;
wire[`PE_ROW*`BIT_DATA-1:0] Isram_Data_Buf;
wire[`PE_ROW*`BIT_DATA-1:0] Load_Isram_Data;
wire Valid_WB_Psum, Valid_WB_Param;
wire[`BIT_DATA-1:0] WB_Param_Out;
wire[`BIT_PSUM-1:0] Data_WB_Out_Psum, Data_WB_Out_Param;

wire [`BIT_PSUM*`PE_COL-1:0] Psram_Data_Out_Buf;
wire [`BIT_PSUM*`PE_COL-1:0] Psram_Data_Out_One, Psram_Data_Out_Two;
wire [`BIT_PSUM*`PE_COL-1:0] Psram_Data_Out_One_Buf, Psram_Data_Out_Two_Buf;
wire [`BIT_PSUM*`PE_COL-1:0] Psram_Data_Out_WB;
wire [`BIT_PSUM*`PE_COL-1:0] Psram_Data_In;
wire [`BIT_ADDR*`PE_COL-1:0] Systolic_Psram_Addr;
wire [`PE_COL-1:0] Systolic_Psram_Valid;
wire [`PE_COL-1:0] Systolic_Psram_Valid_One, Systolic_Psram_Valid_Two;
wire [`BIT_INSTR-1:0] Instr_In;
wire Execute_Isram, Execute_Wsram, Execute_Psram;   
wire Num_Psum;
wire Instr_Flag;

dffq #(`BIT_INSTR) dffq_instr (
    .CLK(CLK),
    .D(i_Instr_In),
    .Q(Instr_In)
);

assign o_Instr_Flag = Instr_Flag;

// assign o_Data_WB_Out = (Valid_WB_Psum)? Psram_Data_Out : 0;
// assign o_Valid_WB_Out = Valid_WB_Psum;
psum_wb psum_wb(
    .CLK(CLK), 
    //bank 0~31
    .i_Psum_Bank0(Psram_Data_Out_WB[0*`BIT_PSUM+:`BIT_PSUM]),
    .i_Psum_Bank1(Psram_Data_Out_WB[1*`BIT_PSUM+:`BIT_PSUM]),
    .i_Psum_Bank2(Psram_Data_Out_WB[2*`BIT_PSUM+:`BIT_PSUM]),
    .i_Psum_Bank3(Psram_Data_Out_WB[3*`BIT_PSUM+:`BIT_PSUM]),
    .i_Psum_Bank4(Psram_Data_Out_WB[4*`BIT_PSUM+:`BIT_PSUM]),
    .i_Psum_Bank5(Psram_Data_Out_WB[5*`BIT_PSUM+:`BIT_PSUM]),
    .i_Psum_Bank6(Psram_Data_Out_WB[6*`BIT_PSUM+:`BIT_PSUM]),
    .i_Psum_Bank7(Psram_Data_Out_WB[7*`BIT_PSUM+:`BIT_PSUM]),
    .i_Psum_Bank8(Psram_Data_Out_WB[8*`BIT_PSUM+:`BIT_PSUM]),
    .i_Psum_Bank9(Psram_Data_Out_WB[9*`BIT_PSUM+:`BIT_PSUM]),
    .i_Psum_Bank10(Psram_Data_Out_WB[`BIT_PSUM*10+:`BIT_PSUM]),
    .i_Psum_Bank11(Psram_Data_Out_WB[`BIT_PSUM*11+:`BIT_PSUM]),
    .i_Psum_Bank12(Psram_Data_Out_WB[`BIT_PSUM*12+:`BIT_PSUM]),
    .i_Psum_Bank13(Psram_Data_Out_WB[`BIT_PSUM*13+:`BIT_PSUM]),
    .i_Psum_Bank14(Psram_Data_Out_WB[`BIT_PSUM*14+:`BIT_PSUM]),
    .i_Psum_Bank15(Psram_Data_Out_WB[`BIT_PSUM*15+:`BIT_PSUM]),
    .i_Psum_Bank16(Psram_Data_Out_WB[`BIT_PSUM*16+:`BIT_PSUM]),
    .i_Psum_Bank17(Psram_Data_Out_WB[`BIT_PSUM*17+:`BIT_PSUM]),
    .i_Psum_Bank18(Psram_Data_Out_WB[`BIT_PSUM*18+:`BIT_PSUM]),
    .i_Psum_Bank19(Psram_Data_Out_WB[`BIT_PSUM*19+:`BIT_PSUM]),
    .i_Psum_Bank20(Psram_Data_Out_WB[`BIT_PSUM*20+:`BIT_PSUM]),
    .i_Psum_Bank21(Psram_Data_Out_WB[`BIT_PSUM*21+:`BIT_PSUM]),
    .i_Psum_Bank22(Psram_Data_Out_WB[`BIT_PSUM*22+:`BIT_PSUM]),
    .i_Psum_Bank23(Psram_Data_Out_WB[`BIT_PSUM*23+:`BIT_PSUM]),
    .i_Psum_Bank24(Psram_Data_Out_WB[`BIT_PSUM*24+:`BIT_PSUM]),
    .i_Psum_Bank25(Psram_Data_Out_WB[`BIT_PSUM*25+:`BIT_PSUM]),
    .i_Psum_Bank26(Psram_Data_Out_WB[`BIT_PSUM*26+:`BIT_PSUM]),
    .i_Psum_Bank27(Psram_Data_Out_WB[`BIT_PSUM*27+:`BIT_PSUM]),
    .i_Psum_Bank28(Psram_Data_Out_WB[`BIT_PSUM*28+:`BIT_PSUM]),
    .i_Psum_Bank29(Psram_Data_Out_WB[`BIT_PSUM*29+:`BIT_PSUM]),
    .i_Psum_Bank30(Psram_Data_Out_WB[`BIT_PSUM*30+:`BIT_PSUM]),
    .i_Psum_Bank31(Psram_Data_Out_WB[`BIT_PSUM*31+:`BIT_PSUM]),
    .i_Psram_En(Loader_Psram_En_One | Loader_Psram_En_Two),
    .i_Valid_WB_Psum(Valid_WB_Psum),
    .o_Data_WB_Out(Data_WB_Out_Psum), 
    .o_Valid_WB_Psum(o_Valid_WB_Out)
);



param_wb param_wb(
    .CLK(CLK), 
    .i_Param_WB(WB_Param_Out), .i_Valid_WB_Param(Valid_WB_Param),
    .o_Data_WB_Out(Data_WB_Out_Param)
);

assign o_Data_WB_Out = Data_WB_Out_Psum | Data_WB_Out_Param;





systolic_ctrl systolic_ctrl(
    .CLK(CLK),
    .RST(RST),
    .i_Instr_In(Instr_In),
    .o_Instr_Data(Instr_Data),
    .o_Isram_Addr_One(Isram_Addr_One),
    .o_Isram_Addr_Two(Isram_Addr_Two),
    .o_Isram_En_One(Isram_En_One),
    .o_Isram_En_Two(Isram_En_Two),
    .o_Isram_Wea_One(Isram_Wea_One),
    .o_Isram_Wea_Two(Isram_Wea_Two),
    .o_Wsram_Addr_One(Wsram_Addr_One),
    .o_Wsram_Addr_Two(Wsram_Addr_Two),
    .o_Wsram_En_One(Wsram_En_One),
    .o_Wsram_En_Two(Wsram_En_Two),
    .o_Wsram_Wea_One(Wsram_Wea_One),
    .o_Wsram_Wea_Two(Wsram_Wea_Two),
    .o_Psram_Addr_One(Psram_Addr_One),
    .o_Psram_Addr_Two(Psram_Addr_Two),
    .o_Psram_En_One(Psram_En_One),
    .o_Psram_En_Two(Psram_En_Two),
    .o_Psram_En_WB_One(Psram_En_WB_One),
    .o_Psram_En_WB_Two(Psram_En_WB_Two),
    .o_Psram_Addr_WB_One(Psram_Addr_WB_One),
    .o_Psram_Addr_WB_Two(Psram_Addr_WB_Two),
    // .o_Psram_Wea_One(Psram_Wea_One),
    // .o_Psram_Wea_Two(Psram_Wea_Two),
    .o_Psram_Valid_One(Psram_Valid_One),
    .o_Psram_Valid_Two(Psram_Valid_Two),
    .o_Init_Psram_Addr_One(Init_Psram_Addr_One),
    .o_Init_Psram_Addr_Two(Init_Psram_Addr_Two),
    .o_Init_Psram_En_One(Init_Psram_En_One),
    .o_Init_Psram_En_Two(Init_Psram_En_Two),
    .o_Init_Psram_Wea_One(Init_Psram_Wea_One),
    .o_Init_Psram_Wea_Two(Init_Psram_Wea_Two),
    .o_Systolic_En_ID(Systolic_En_ID),
    .o_Systolic_En_W(Systolic_En_W),
    .o_Finish_Flag(o_Flag_Finish_Out),
    .o_WB_Param(WB_Param_Out),
    .o_Valid_WB_Psum(Valid_WB_Psum),
    .o_Valid_WB_Param(Valid_WB_Param),
    .o_Execute_Isram(Execute_Isram),
    .o_Execute_Wsram(Execute_Wsram),
    .o_Execute_Psram(Execute_Psram), //for systolic array use psram
    .o_Num_Psum(Num_Psum),           //for Psram WB(Instruction)
    .o_Instr_Flag(Instr_Flag)
    );

systolic systolic( 
    .CLK(CLK), 
    .i_Data_I_In(Load_Isram_Data),
    .i_Data_W_In(Wsram_Data_Buf), 
    .i_EN_W_In(Systolic_En_W_1buf), 
    .i_EN_ID_In(Systolic_En_ID_1buf), 
    .i_Psum_In(Psram_Data_Out_Buf), 
    .i_Addr_P_In(Loader_Psram_Addr_Buf), 
    .i_Valid_P_In(Loader_Psram_Valid_Buf), 
    .o_Psum_Out(Psram_Data_In),
    .o_Addr_P_Out(Systolic_Psram_Addr), 
    .o_Valid_P_Out(Systolic_Psram_Valid)
    );



//systolic input data
assign Isram_Data_Buf = (Execute_Isram)? Isram_Data_Buf_Two : Isram_Data_Buf_One;
assign Wsram_Data_Buf = (Execute_Wsram)? Wsram_Data_Buf_Two : Wsram_Data_Buf_One;
assign Psram_Data_Out_Buf = (Execute_Psram)? Psram_Data_Out_Two_Buf : Psram_Data_Out_One_Buf;

//systolic output data
assign Systolic_Psram_Valid_One = (Execute_Psram)? 1'b0 : Systolic_Psram_Valid;
assign Systolic_Psram_Valid_Two = (Execute_Psram)? Systolic_Psram_Valid : 1'b0;

//WB Psram data
assign Psram_Data_Out_WB = (Num_Psum)? Psram_Data_Out_Two_Buf : Psram_Data_Out_One_Buf;

genvar i;
generate for (i=0;i<`PE_ROW;i=i+1) begin: Loop_I
    //Block RAM(ISRAM)
    // Component Name: spram_block
    // Memory Type: Single Port RAM
    // Width: 8
    // Depth: 1024 (10 bit address)
    // no Primitives Output Register
    // Operating Mode: No Change
    // Enable Port Type: Use ENA pin


    spram_block sram_i_1 ( //need to add double buffer
        .clka(~CLK), 
        .addra(Isram_Addr_One[9:0]), //addr 1024
        .dina(Instr_Data), 
        .douta(Isram_Data_One[`BIT_DATA*i+:`BIT_DATA]), 
        .ena(Isram_En_One[i]), 
        .wea(Isram_Wea_One[i])
    );


    sram_buffer #(`BIT_DATA) sram_buffer_i_1(
        .clka(CLK), 
        .ena(Isram_En_One[i]), 
        .wea(Isram_Wea_One[i]), 
        .douta(Isram_Data_One[`BIT_DATA*i+:`BIT_DATA]), 
        .douta_buf(Isram_Data_Buf_One[`BIT_DATA*i+:`BIT_DATA])
        );
        
    spram_block sram_i_2 (
        .clka(~CLK), 
        .addra(Isram_Addr_Two[9:0]), //addr 1024
        .dina(Instr_Data), 
        .douta(Isram_Data_Two[`BIT_DATA*i+:`BIT_DATA]), 
        .ena(Isram_En_Two[i]), 
        .wea(Isram_Wea_Two[i])
    );


    sram_buffer #(`BIT_DATA) sram_buffer_i_2(
        .clka(CLK), 
        .ena(Isram_En_Two[i]), 
        .wea(Isram_Wea_Two[i]), 
        .douta(Isram_Data_Two[`BIT_DATA*i+:`BIT_DATA]), 
        .douta_buf(Isram_Data_Buf_Two[`BIT_DATA*i+:`BIT_DATA])
        );

end
endgenerate



generate for (i=0;i<`PE_COL;i=i+1) begin: Loop_W
    //Block RAM(WSRAM)(= same as ISRAM)
    // Component Name: spram_block
    // Memory Type: Single Port RAM
    // Width: 8
    // Depth: 1024 (10 bit address)
    // no Primitives Output Register
    // Operating Mode: No Change
    // Enable Port Type: Use ENA pin

    spram_block   sram_w_1 (             //need to add for double buffer
        .clka(~CLK), 
        .addra(Wsram_Addr_One[9:0]), //1024
        .dina(Instr_Data), 
        .douta(Wsram_Data_One[`BIT_DATA*i+:`BIT_DATA]), 
        .ena(Wsram_En_One[i]), 
        .wea(Wsram_Wea_One[i]) 
    );

    sram_buffer #(`BIT_DATA) sram_buffer_w_1(
        .clka(CLK),
        .ena(Wsram_En_One[i]),
        .wea(Wsram_Wea_One[i]),
        .douta(Wsram_Data_One[`BIT_DATA*i+:`BIT_DATA]),
        .douta_buf(Wsram_Data_Buf_One[`BIT_DATA*i+:`BIT_DATA])
        );

    spram_block   sram_w_2 (
        .clka(~CLK), 
        .addra(Wsram_Addr_Two[9:0]), //1024
        .dina(Instr_Data), 
        .douta(Wsram_Data_Two[`BIT_DATA*i+:`BIT_DATA]), 
        .ena(Wsram_En_Two[i]), 
        .wea(Wsram_Wea_Two[i]) 
    );

    sram_buffer #(`BIT_DATA) sram_buffer_w_2(
        .clka(CLK), 
        .ena(Wsram_En_Two[i]), 
        .wea(Wsram_Wea_Two[i]), 
        .douta(Wsram_Data_Two[`BIT_DATA*i+:`BIT_DATA]), 
        .douta_buf(Wsram_Data_Buf_Two[`BIT_DATA*i+:`BIT_DATA])
        );


    //Block RAM(PSRAM)
    // Component Name: dpram_block
    // Memory Type: True Dual Port RAM
    // Common Clock: Checked
    // Width: 24
    // Depth: 512 (9 bit address)
    // Port A: Read First
    // Port B: Write First
    // no Primitives Output Register
    // Operating Mode: No Change
    // Enable Port Type: Use ENA pin


    dpram_block sram_psum_1 ( //port a: read&init&WB, port b: write
        .clka(~CLK), 
        .addra(Loader_Psram_Addr_One[i*`BIT_ADDR+:9] | Init_Psram_Addr_One[8:0] | Psram_Addr_WB_One), //addr: 512b
        .douta(Psram_Data_Out_One[i*`BIT_PSUM+:`BIT_PSUM]), 
        .dina(`BIT_PSUM'd0),
        .ena(Loader_Psram_En_One[i]| Init_Psram_En_One | Psram_En_WB_One[i]),
        .wea(Init_Psram_Wea_One), 
        
        .clkb(CLK), 
        .addrb(Systolic_Psram_Addr[i*`BIT_ADDR+:9]), 
        .dinb(Psram_Data_In[i*`BIT_PSUM+:`BIT_PSUM]), 
        .doutb(),
        .enb(Systolic_Psram_Valid_One[i]), 
        .web(Systolic_Psram_Valid_One[i])
    );

    sram_buffer #(`BIT_PSUM) sram_buffer_p_1(
        .clka(CLK), 
        .ena(Loader_Psram_En_One[i]| Init_Psram_En_One | Psram_En_WB_One[i]), 
        .wea(Init_Psram_Wea_One), 
        .douta(Psram_Data_Out_One[`BIT_PSUM*i+:`BIT_PSUM]), 
        .douta_buf(Psram_Data_Out_One_Buf[`BIT_PSUM*i+:`BIT_PSUM])
        );

    dpram_block sram_psum_2( //port a: read&init&WB, port b: write
        .clka(~CLK), 
        .addra(Loader_Psram_Addr_Two[i*`BIT_ADDR+:9] | Init_Psram_Addr_Two[8:0]| Psram_Addr_WB_Two), //addr: 512b
        .douta(Psram_Data_Out_Two[i*`BIT_PSUM+:`BIT_PSUM]), 
        .dina(`BIT_PSUM'd0),
        .ena(Loader_Psram_En_Two[i] | Init_Psram_En_Two| Psram_En_WB_Two[i]),
        .wea(Init_Psram_Wea_Two), 
        
        .clkb(CLK), 
        .addrb(Systolic_Psram_Addr[i*`BIT_ADDR+:9]), 
        .dinb(Psram_Data_In[i*`BIT_PSUM+:`BIT_PSUM]), 
        .doutb(),
        .enb(Systolic_Psram_Valid_Two[i]), 
        .web(Systolic_Psram_Valid_Two[i])
    );

    sram_buffer #(`BIT_PSUM) sram_buffer_p_2(
        .clka(CLK), 
        .ena(Loader_Psram_En_Two[i] | Init_Psram_En_Two | Psram_En_WB_Two[i]), 
        .wea(Init_Psram_Wea_Two), 
        .douta(Psram_Data_Out_Two[`BIT_PSUM*i+:`BIT_PSUM]), 
        .douta_buf(Psram_Data_Out_Two_Buf[`BIT_PSUM*i+:`BIT_PSUM])
        );

end
endgenerate

dffq #(`BIT_ADDR*`PE_COL) dffq_Addr1(.CLK(CLK), .D(Loader_Psram_Addr), .Q(Loader_Psram_Addr_Buf));
dffq #(`PE_COL) dffq_Valid1(.CLK(CLK), .D(Psram_Valid), .Q(Psram_Valid_1buf));

//systolic_loader_p input
assign Psram_Addr = (Execute_Psram)? Psram_Addr_Two : Psram_Addr_One;
assign Psram_En = (Execute_Psram)? Psram_En_Two : Psram_En_One;
assign Psram_Valid = (Execute_Psram)? Psram_Valid_Two : Psram_Valid_One;

//systolic_loader_p output
assign Loader_Psram_Addr_One = (Execute_Psram)? `BIT_ADDR'd0 : Loader_Psram_Addr;
assign Loader_Psram_Addr_Two = (Execute_Psram)? Loader_Psram_Addr : `BIT_ADDR'd0;
assign Loader_Psram_En_One = (Execute_Psram)? `PE_COL'd0 : Loader_Psram_En;
assign Loader_Psram_En_Two = (Execute_Psram)? Loader_Psram_En : `PE_COL'd0;




systolic_loader_i  systolic_loader_i (.o_Data_I_In(Load_Isram_Data), .i_Data_I_In(Isram_Data_Buf), .CLK(CLK));
systolic_loader_p  systolic_loader_p (
    .CLK(CLK),
    .i_Psram_Addr(Psram_Addr), 
    .i_Psram_Valid_1buf(Psram_Valid_1buf), 
    .i_Psram_En(Psram_En), 
    .o_Psram_Addr_To_Sram(Loader_Psram_Addr),
    .o_Psram_En_To_Sram(Loader_Psram_En),
    .o_Psram_Valid_To_Systolic(Loader_Psram_Valid_Buf)
    );


systolic_loader_w  systolic_loader_w (
    .CLK(CLK), 
    .RST(RST),
    .i_Systolic_En_ID(Systolic_En_ID),
    .i_Systolic_En_W(Systolic_En_W), 
    .o_Systolic_En_ID(Systolic_En_ID_1buf), 
    .o_Systolic_En_W(Systolic_En_W_1buf)
    );


endmodule
