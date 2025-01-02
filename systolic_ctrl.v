`include "./param.v"

module systolic_ctrl (
    CLK, RST, i_Instr_In,
    o_Instr_Data,
    o_Isram_Addr_One, o_Isram_Addr_Two,
    o_Isram_En_One, o_Isram_En_Two, 
    o_Isram_Wea_One, o_Isram_Wea_Two,
    o_Wsram_Addr_One, o_Wsram_Addr_Two,
    o_Wsram_En_One, o_Wsram_En_Two,
    o_Wsram_Wea_One, o_Wsram_Wea_Two,
    o_Psram_Addr_One, o_Psram_Addr_Two,
    o_Psram_En_One, o_Psram_En_Two,
    o_Psram_En_WB_One, o_Psram_En_WB_Two,
    o_Psram_Addr_WB_One, o_Psram_Addr_WB_Two,
    // o_Psram_Wea_One, o_Psram_Wea_Two,
    o_Psram_Valid_One, o_Psram_Valid_Two,
    o_Init_Psram_Addr_One, o_Init_Psram_Addr_Two,
    o_Init_Psram_En_One, o_Init_Psram_En_Two,
    o_Init_Psram_Wea_One, o_Init_Psram_Wea_Two,
    o_Systolic_En_ID, o_Systolic_En_W,
    o_Finish_Flag,
    o_WB_Param , o_Valid_WB_Param,
    o_Valid_WB_Psum,
    o_Execute_Isram, //for systolic array use isram
    o_Execute_Wsram, //for systolic array use wsram
    o_Execute_Psram, //for systolic array use psram
    o_Num_Psum, //Num of Instruction for Psram WB
    o_Instr_Flag // request instruction for cpu
    );

input CLK, RST;
input [`BIT_INSTR-1:0] i_Instr_In;
output [`BIT_DATA-1:0] o_Instr_Data;

output [`PE_ROW-1:0] o_Isram_En_One, o_Isram_En_Two;
output [`PE_ROW-1:0] o_Isram_Wea_One, o_Isram_Wea_Two;
output [`BIT_ADDR-1:0] o_Isram_Addr_One, o_Isram_Addr_Two;

output [`PE_COL-1:0] o_Wsram_En_One, o_Wsram_En_Two;
output [`PE_COL-1:0] o_Wsram_Wea_One, o_Wsram_Wea_Two;
output [`BIT_ADDR-1:0] o_Wsram_Addr_One, o_Wsram_Addr_Two;

output [`PE_COL-1:0] o_Psram_En_One, o_Psram_En_Two;
output [`PE_COL-1:0] o_Psram_En_WB_One, o_Psram_En_WB_Two;
output [`BIT_ADDR-1:0] o_Psram_Addr_WB_One, o_Psram_Addr_WB_Two;
// output [`PE_COL-1:0] o_Psram_Wea_One, o_Psram_Wea_Two;
output [`BIT_ADDR-1:0] o_Psram_Addr_One, o_Psram_Addr_Two;
output [`PE_COL-1:0] o_Psram_Valid_One, o_Psram_Valid_Two;

output [`BIT_ADDR-1:0] o_Init_Psram_Addr_One, o_Init_Psram_Addr_Two;
output o_Init_Psram_En_One, o_Init_Psram_En_Two;
output o_Init_Psram_Wea_One, o_Init_Psram_Wea_Two;



output [`BIT_ROW_ID-1:0] o_Systolic_En_ID;
output [`PE_COL-1:0] o_Systolic_En_W;
output o_Finish_Flag;
output [`BIT_DATA-1:0] o_WB_Param;
output o_Valid_WB_Psum;
output o_Valid_WB_Param;
output o_Execute_Isram, o_Execute_Wsram, o_Execute_Psram;
output o_Num_Psum;
output o_Instr_Flag;

//instruction Decoder register
reg [`BIT_DATA-1:0] r_Param_S, r_Param_OC, r_Param_IC;
reg [`BIT_DATA-1:0] r_Param_Trg;
reg [`BIT_DATA-1:0] r_Param_Base_Wsram;
reg [`BIT_DATA-1:0] r_WB_Param;
reg r_Num_Sram_I, r_Num_Sram_W, r_Num_Sram_P; // 0 is ram 1, 1 is ram 2
reg Switch_Isram, Switch_Wsram, Switch_Psram;

reg [`BIT_DATA-1:0] r_Instr_Data;

reg [`PE_ROW-1:0] r_Isram_En_Decode_One, r_Isram_En_Decode_Two;
reg [`PE_ROW-1:0] r_Isram_En_FSM;
reg [`PE_ROW-1:0] r_Isram_Wea_Decode_One, r_Isram_Wea_Decode_Two;
reg [`BIT_ADDR-1:0] r_Isram_Addr_Decode_One, r_Isram_Addr_Decode_Two;
reg [`BIT_ADDR-1:0] r_Isram_Addr_FSM;

reg [`PE_COL-1:0] r_Wsram_En_Decode_One, r_Wsram_En_Decode_Two;
reg [`PE_COL-1:0] r_Wsram_En_FSM;
reg [`PE_COL-1:0] r_Wsram_Wea_Decode_One, r_Wsram_Wea_Decode_Two;
reg [`BIT_ADDR-1:0] r_Wsram_Addr_Decode_One, r_Wsram_Addr_Decode_Two;
reg [`BIT_ADDR-1:0] r_Wsram_Addr_FSM;

reg [`PE_COL-1:0] r_Psram_En_WB_One, r_Psram_En_WB_Two;
reg [`BIT_ADDR-1:0] r_Psram_Addr_WB_One, r_Psram_Addr_WB_Two;

reg Fsm_Execute_Flag;

wire [`BIT_ADDR-1:0] Isram_Addr_FSM_One, Isram_Addr_FSM_Two;
wire [`PE_ROW-1:0] Isram_En_FSM_One, Isram_En_FSM_Two;
wire [`BIT_ADDR-1:0] Wsram_Addr_FSM_One, Wsram_Addr_FSM_Two;
wire [`PE_COL-1:0] Wsram_En_FSM_One, Wsram_En_FSM_Two;
wire [`BIT_ADDR-1:0] Psram_Addr_FSM_One, Psram_Addr_FSM_Two;
wire [`PE_COL-1:0] Psram_En_FSM_One, Psram_En_FSM_Two;
wire [`PE_COL-1:0] Psram_Valid_One, Psram_Valid_Two;







//fsm register
reg [`FSM_BIT-1:0] FSM_State;
reg [`BIT_ADDR-1:0] Run_Cnt, Run_Cnt_Init;
reg [`BIT_DATA-1:0] Set_Param_S, Set_Param_OC, Set_Param_IC;
reg [`BIT_DATA-1:0] Set_Param_Trg;
reg [`BIT_DATA-1:0] Set_Param_Base_Wsram;
reg [`BIT_ADDR-1:0] r_Psram_Addr_Decode_One, r_Psram_Addr_Decode_Two;
reg [`BIT_ADDR-1:0] r_Psram_Addr_FSM;
reg [`PE_COL-1:0] r_Psram_En_Decode_One, r_Psram_En_Decode_Two;
reg [`PE_COL-1:0] r_Psram_En_FSM;
reg [`PE_COL-1:0] r_Psram_Valid;
reg r_Valid_WB_Param;
reg r_Valid_WB_Psum_One, r_Valid_WB_Psum_Two;
reg Layer_Finish_Flag;

//Init psum
reg r_Init_Psum;
reg [`BIT_ADDR-1:0] r_Init_Psram_Addr_One, r_Init_Psram_Addr_Two;
reg r_Init_Psram_En_One, r_Init_Psram_En_Two;
reg r_Init_Psram_Wea_One, r_Init_Psram_Wea_Two;



reg [`BIT_ROW_ID-1:0] Systolic_En_ID;
reg [`PE_COL-1:0] Systolic_En_W;
reg [`BIT_DATA-1:0] Base_I, Base_W;
reg [`BIT_DATA-1:0] State_IC, State_OC;
reg [`BIT_DATA-1:0] Run_IC, Run_OC;
reg [`BIT_PARAM-1:0] Next_OC, Next_IC;
reg Change_OC, Last_OC, Last_Execute;

reg Finish_Flag;
reg r_Layer_End, Layer_Finish;
reg Done_Init_Psum;
reg Instr_Flag;

//Switch_*sram is systolic operating sram(set to fsm(Switch State))
assign Isram_Addr_FSM_One = (Switch_Isram)? `BIT_ADDR'd0 : r_Isram_Addr_FSM;
assign Isram_Addr_FSM_Two = (Switch_Isram)? r_Isram_Addr_FSM: `BIT_ADDR'd0;
assign Isram_En_FSM_One = (Switch_Isram)? `PE_ROW'b0 : r_Isram_En_FSM;
assign Isram_En_FSM_Two = (Switch_Isram)? r_Isram_En_FSM : `PE_ROW'b0;

assign Wsram_Addr_FSM_One = (Switch_Wsram)? `BIT_ADDR'd0 : r_Wsram_Addr_FSM;
assign Wsram_Addr_FSM_Two = (Switch_Wsram)? r_Wsram_Addr_FSM: `BIT_ADDR'd0;
assign Wsram_En_FSM_One = (Switch_Wsram)? `PE_COL'b0 : r_Wsram_En_FSM;
assign Wsram_En_FSM_Two = (Switch_Wsram)? r_Wsram_En_FSM : `PE_COL'b0;

assign Psram_Addr_FSM_One = (Switch_Psram)? `BIT_ADDR'd0 : r_Psram_Addr_FSM;
assign Psram_Addr_FSM_Two = (Switch_Psram)? r_Psram_Addr_FSM: `BIT_ADDR'd0;
assign Psram_En_FSM_One = (Switch_Psram)? `PE_COL'b0 : r_Psram_En_FSM;
assign Psram_En_FSM_Two = (Switch_Psram)? r_Psram_En_FSM : `PE_COL'b0;
assign Psram_Valid_One = (Switch_Psram)? `PE_COL'b0 : r_Psram_Valid;
assign Psram_Valid_Two = (Switch_Psram)? r_Psram_Valid : `PE_COL'b0;



assign o_Isram_Addr_One = r_Isram_Addr_Decode_One | Isram_Addr_FSM_One;
assign o_Isram_Addr_Two = r_Isram_Addr_Decode_Two | Isram_Addr_FSM_Two;
assign o_Isram_En_One = r_Isram_En_Decode_One | Isram_En_FSM_One;
assign o_Isram_En_Two = r_Isram_En_Decode_Two | Isram_En_FSM_Two;
assign o_Isram_Wea_One = r_Isram_En_Decode_One;
assign o_Isram_Wea_Two = r_Isram_En_Decode_Two;

assign o_Wsram_Addr_One = r_Wsram_Addr_Decode_One | Wsram_Addr_FSM_One;
assign o_Wsram_Addr_Two = r_Wsram_Addr_Decode_Two | Wsram_Addr_FSM_Two;
assign o_Wsram_En_One = r_Wsram_En_Decode_One | Wsram_En_FSM_One;
assign o_Wsram_En_Two = r_Wsram_En_Decode_Two | Wsram_En_FSM_Two;
assign o_Wsram_Wea_One = r_Wsram_En_Decode_One;
assign o_Wsram_Wea_Two = r_Wsram_En_Decode_Two;

assign o_Psram_Addr_One = r_Psram_Addr_Decode_One | Psram_Addr_FSM_One;
assign o_Psram_Addr_Two = r_Psram_Addr_Decode_Two | Psram_Addr_FSM_Two;
assign o_Psram_En_One = r_Psram_En_Decode_One | Psram_En_FSM_One;
assign o_Psram_En_Two = r_Psram_En_Decode_Two | Psram_En_FSM_Two;
assign o_Psram_En_WB_One = r_Psram_En_WB_One;
assign o_Psram_En_WB_Two = r_Psram_En_WB_Two;
assign o_Psram_Addr_WB_One = r_Psram_Addr_WB_One;
assign o_Psram_Addr_WB_Two = r_Psram_Addr_WB_Two;

// assign o_Psram_Wea_One = r_Init_Psram_Wea_One;
// assign o_Psram_Wea_Two = r_Init_Psram_Wea_Two;
assign o_Psram_Valid_One = Psram_Valid_One; //psram Valid is for systolic array use psram
assign o_Psram_Valid_Two = Psram_Valid_Two;


assign o_Init_Psram_Addr_One = r_Init_Psram_Addr_One;
assign o_Init_Psram_Addr_Two = r_Init_Psram_Addr_Two;
assign o_Init_Psram_En_One = r_Init_Psram_En_One;
assign o_Init_Psram_En_Two = r_Init_Psram_En_Two;
assign o_Init_Psram_Wea_One = r_Init_Psram_Wea_One;
assign o_Init_Psram_Wea_Two = r_Init_Psram_Wea_Two;





assign o_Systolic_En_ID = Systolic_En_ID;
assign o_Systolic_En_W = Systolic_En_W;
assign o_Finish_Flag = Layer_Finish_Flag;

assign o_WB_Param = r_WB_Param;
assign o_Valid_WB_Psum = r_Valid_WB_Psum_One | r_Valid_WB_Psum_Two;
// assign o_Valid_WB_Psum_One = r_Valid_WB_Psum_One;
// assign o_Valid_WB_Psum_Two = r_Valid_WB_Psum_Two;
assign o_Valid_WB_Param = r_Valid_WB_Param;

assign o_Instr_Data = r_Instr_Data;

assign o_Execute_Psram = Switch_Psram;
assign o_Execute_Isram = Switch_Isram;
assign o_Execute_Wsram = Switch_Wsram;
assign o_Num_Psum = r_Num_Sram_P; //Num of Instruction for Psram WB

assign o_Instr_Flag = Instr_Flag;


wire in_valid;
wire [`BIT_DATA-1:0] in_data;
wire [`BIT_PARAM-1:0] in_param;
wire [`BIT_ADDR-1:0] in_addr;
wire [`BIT_SEL-1:0] in_bank;
wire [`BIT_OPCODE-1:0] in_opcode;

assign in_data = i_Instr_In[0 +: `BIT_DATA];
assign in_param = i_Instr_In[`BIT_DATA +: `BIT_PARAM] ;
assign in_addr = i_Instr_In[`BIT_DATA +: `BIT_ADDR];
assign in_bank = i_Instr_In[(`BIT_DATA+`BIT_ADDR) +: `BIT_SEL] ;
assign in_opcode = i_Instr_In[(`BIT_DATA+`BIT_PARAM) +: `BIT_OPCODE];
assign in_valid = i_Instr_In[(`BIT_DATA+`BIT_PARAM+`BIT_OPCODE) +: 1];


reg test_flag, test_flag_2;

always@(posedge CLK, posedge RST) //instruction Decode(not fsm, isram wsram write)
begin
    if(RST) begin
        r_Param_S <= 0;
        r_Param_OC <= 0;
        r_Param_IC <= 0;
        r_Param_Trg <= 0;
        r_Param_Base_Wsram <= 0;
        r_Isram_Addr_Decode_One <= 0;
        r_Isram_Addr_Decode_Two <= 0;
        r_Instr_Data <= `BIT_DATA'd0;
        r_Isram_En_Decode_One <= 0;
        r_Isram_En_Decode_Two <= 0;
        r_Isram_Wea_Decode_One <= 0;
        r_Isram_Wea_Decode_Two <= 0;
        r_Wsram_Addr_Decode_One <= 0;
        r_Wsram_Addr_Decode_Two <= 0;
        r_Wsram_En_Decode_One <= 0;
        r_Wsram_En_Decode_Two <= 0;
        r_Wsram_Wea_Decode_One <= 0;
        r_Wsram_Wea_Decode_Two <= 0;
        r_Valid_WB_Psum_One <= 0;
        r_Valid_WB_Psum_Two <= 0;
        r_Psram_Addr_WB_One <= 0;
        r_Psram_Addr_WB_Two <= 0;
        r_Psram_En_WB_One <= 0;
        r_Psram_En_WB_Two <= 0;
        Fsm_Execute_Flag <= 0;
        r_WB_Param <= 0;
        r_Psram_Addr_Decode_One <= 0;
        r_Psram_Addr_Decode_Two <= 0;
        r_Psram_En_Decode_One <= 0;
        r_Psram_En_Decode_Two <= 0;
        r_Valid_WB_Param <= 0;
        r_Num_Sram_I <= 0;
        r_Num_Sram_W <= 0;
        r_Num_Sram_P <= 0;
        Instr_Flag <= 0;
        r_Init_Psum <= 0;
        test_flag <= 0;
    end
    else if(in_valid) begin
        Instr_Flag <= 1'b0; //receive instruction, flag set to 0
        if(in_opcode == `OPCODE_PARAM)begin
            case(in_param)
            `PARAM_S: begin
                r_Param_S <= in_data;
                r_Param_OC <= r_Param_OC;
                r_Param_IC <= r_Param_IC;
                r_Param_Trg <= r_Param_Trg;
                r_Param_Base_Wsram <= r_Param_Base_Wsram;
                r_Num_Sram_I <= r_Num_Sram_I;
                r_Num_Sram_W <= r_Num_Sram_W;
                r_Num_Sram_P <= r_Num_Sram_P;
                r_Layer_End <= r_Layer_End;
            end
            `PARAM_OC: begin
                r_Param_S <= r_Param_S;
                r_Param_OC <= in_data;
                r_Param_IC <= r_Param_IC;
                r_Param_Trg <= r_Param_Trg;
                r_Param_Base_Wsram <= r_Param_Base_Wsram;
                r_Num_Sram_I <= r_Num_Sram_I;
                r_Num_Sram_W <= r_Num_Sram_W;
                r_Num_Sram_P <= r_Num_Sram_P;
                r_Layer_End <= r_Layer_End;
            end
            `PARAM_IC: begin
                r_Param_S <= r_Param_S;
                r_Param_OC <= r_Param_OC;
                r_Param_IC <= in_data;
                r_Param_Trg <= r_Param_Trg;
                r_Param_Base_Wsram <= r_Param_Base_Wsram;        
                r_Num_Sram_I <= r_Num_Sram_I;
                r_Num_Sram_W <= r_Num_Sram_W;
                r_Num_Sram_P <= r_Num_Sram_P;   
                r_Layer_End <= r_Layer_End;                 
            end
            `PARAM_TRG :begin
                r_Param_S <= r_Param_S;
                r_Param_OC <= r_Param_OC;
                r_Param_IC <= r_Param_IC;
                r_Param_Trg <= in_data;
                r_Param_Base_Wsram <= r_Param_Base_Wsram;
                r_Num_Sram_I <= r_Num_Sram_I;
                r_Num_Sram_W <= r_Num_Sram_W;
                r_Num_Sram_P <= r_Num_Sram_P;
                r_Layer_End <= r_Layer_End;
            end
            `PARAM_BASE_WSRAM :begin
                r_Param_S <= r_Param_S;
                r_Param_OC <= r_Param_OC;
                r_Param_IC <= r_Param_IC;
                r_Param_Trg <= r_Param_Trg;
                r_Param_Base_Wsram <= in_data;
                r_Num_Sram_I <= r_Num_Sram_I;
                r_Num_Sram_W <= r_Num_Sram_W;
                r_Num_Sram_P <= r_Num_Sram_P;
                r_Layer_End <= r_Layer_End;
            end
            `PARAM_SEL_ISRAM :begin
                r_Param_S <= r_Param_S;
                r_Param_OC <= r_Param_OC;
                r_Param_IC <= r_Param_IC;
                r_Param_Trg <= r_Param_Trg;
                r_Param_Base_Wsram <= r_Param_Base_Wsram;
                r_Num_Sram_I <= in_data[0]; //0: isram_1, 1: isram_2
                r_Num_Sram_W <= r_Num_Sram_W;
                r_Num_Sram_P <= r_Num_Sram_P;
                r_Layer_End <= r_Layer_End;
            end
            `PARAM_SEL_WSRAM: begin
                r_Param_S <= r_Param_S;
                r_Param_OC <= r_Param_OC;
                r_Param_IC <= r_Param_IC;
                r_Param_Trg <= r_Param_Trg;
                r_Param_Base_Wsram <= r_Param_Base_Wsram;
                r_Num_Sram_I <= r_Num_Sram_I;
                r_Num_Sram_W <= in_data[0]; //0: wsram_1, 1: wsram_2
                r_Num_Sram_P <= r_Num_Sram_P;
                r_Layer_End <= r_Layer_End;
            end
            `PARAM_SEL_PSRAM: begin
                r_Param_S <= r_Param_S;
                r_Param_OC <= r_Param_OC;
                r_Param_IC <= r_Param_IC;
                r_Param_Trg <= r_Param_Trg;
                r_Param_Base_Wsram <= r_Param_Base_Wsram;
                r_Num_Sram_I <= r_Num_Sram_I;
                r_Num_Sram_W <= r_Num_Sram_W;
                r_Num_Sram_P <= in_data[0]; //0: psram_1, 1: psram_2
                r_Layer_End <= r_Layer_End;
            end
            `PARAM_LAYER_END: begin
                r_Param_S <= r_Param_S;
                r_Param_OC <= r_Param_OC;
                r_Param_IC <= r_Param_IC;
                r_Param_Trg <= r_Param_Trg;
                r_Param_Base_Wsram <= r_Param_Base_Wsram;
                r_Num_Sram_I <= r_Num_Sram_I;
                r_Num_Sram_W <= r_Num_Sram_W;
                r_Num_Sram_P <= r_Num_Sram_P;
                r_Layer_End <= in_data[0];
            end
            default: begin
                r_Param_S <= r_Param_S;
                r_Param_OC <= r_Param_OC;
                r_Param_IC <= r_Param_IC;
                r_Param_Trg <= r_Param_Trg;
                r_Param_Base_Wsram <= r_Param_Base_Wsram;
                r_Num_Sram_I <= r_Num_Sram_I;
                r_Num_Sram_W <= r_Num_Sram_W;
                r_Num_Sram_P <= r_Num_Sram_P;
                r_Layer_End <= r_Layer_End;
            end
            endcase


            r_Isram_Addr_Decode_One       <= 0; //last input 
            r_Isram_Addr_Decode_Two       <= 0;
            r_Isram_En_Decode_One         <= 0;
            r_Isram_En_Decode_Two         <= 0;


            r_Instr_Data       <= r_Instr_Data;
            r_Isram_Wea_Decode_One        <= r_Isram_Wea_Decode_One;
            r_Isram_Wea_Decode_Two        <= r_Isram_Wea_Decode_Two;
            r_Wsram_Addr_Decode_One       <= r_Wsram_Addr_Decode_One;
            r_Wsram_Addr_Decode_Two       <= r_Wsram_Addr_Decode_Two;
            r_Wsram_En_Decode_One         <= r_Wsram_En_Decode_One;
            r_Wsram_En_Decode_Two         <= r_Wsram_En_Decode_Two;
            r_Wsram_Wea_Decode_One        <= r_Wsram_Wea_Decode_One;
            r_Wsram_Wea_Decode_Two        <= r_Wsram_Wea_Decode_Two;
            r_Valid_WB_Psum_One    <= r_Valid_WB_Psum_One;
            r_Valid_WB_Psum_Two    <= r_Valid_WB_Psum_Two;
            // Fsm_Execute_Flag    <= Fsm_Execute_Flag;
            r_WB_Param         <= r_WB_Param;
            r_Psram_Addr_Decode_One       <= r_Psram_Addr_Decode_One;
            r_Psram_Addr_Decode_Two       <= r_Psram_Addr_Decode_Two;
            r_Psram_En_Decode_One         <= r_Psram_En_Decode_One;
            r_Psram_En_Decode_Two         <= r_Psram_En_Decode_Two;

        end
        else if(in_opcode == `OPCODE_LDSRAM)begin
            if(r_Param_Trg == `TRG_ISRAM)begin
                if(!r_Num_Sram_I) begin
                    r_Isram_Addr_Decode_One <= in_addr;
                    r_Instr_Data <= in_data;
                    r_Isram_En_Decode_One <= `PE_ROW'd1 << in_bank; //need to debug
                    // r_Isram_Wea_Decode_One <= `PE_ROW'd1 << in_bank;
                    r_Isram_Addr_Decode_Two <= 0;
                    r_Isram_En_Decode_Two <= 0;
                    // r_Isram_Wea_Decode_Two <= 0;
                end
                else begin
                    r_Isram_Addr_Decode_Two <= in_addr;
                    r_Instr_Data <= in_data;
                    r_Isram_En_Decode_Two <= `PE_ROW'b1 << in_bank; //need to debug
                    // r_Isram_Wea_Decode_Two <= `PE_ROW'b1 << in_bank;
                    r_Isram_Addr_Decode_One <= 0;
                    r_Isram_En_Decode_One <= 0;
                    // r_Isram_Wea_Decode_One <= 0;
                end

                r_Param_S          <= r_Param_S;
                r_Param_OC         <= r_Param_OC;
                r_Param_IC         <= r_Param_IC;
                r_Param_Trg        <= r_Param_Trg;
                r_Param_Base_Wsram <= r_Param_Base_Wsram ;
                r_Num_Sram_I       <= r_Num_Sram_I;
                r_Num_Sram_W       <= r_Num_Sram_W;
                r_Num_Sram_P       <= r_Num_Sram_P;
                r_Layer_End <= r_Layer_End;
                r_Wsram_Addr_Decode_One       <= r_Wsram_Addr_Decode_One;
                r_Wsram_Addr_Decode_Two       <= r_Wsram_Addr_Decode_Two;
                r_Wsram_En_Decode_One         <= r_Wsram_En_Decode_One;
                r_Wsram_En_Decode_Two         <= r_Wsram_En_Decode_Two;
                r_Wsram_Wea_Decode_One        <= r_Wsram_Wea_Decode_One;
                r_Wsram_Wea_Decode_Two        <= r_Wsram_Wea_Decode_Two;
                r_Valid_WB_Psum_One    <= r_Valid_WB_Psum_One;
                r_Valid_WB_Psum_Two    <= r_Valid_WB_Psum_Two;
                r_WB_Param         <= 0;
                r_Valid_WB_Param <= 0;
                r_Psram_Addr_Decode_One       <= r_Psram_Addr_Decode_One;
                r_Psram_Addr_Decode_Two       <= r_Psram_Addr_Decode_Two;
                r_Psram_En_Decode_One         <= r_Psram_En_Decode_One;
                r_Psram_En_Decode_Two         <= r_Psram_En_Decode_Two;
            end
            else if(r_Param_Trg == `TRG_WSRAM)begin
                if(!r_Num_Sram_W) begin
                    r_Wsram_Addr_Decode_One <= in_addr;
                    r_Instr_Data <= in_data;
                    r_Wsram_En_Decode_One <= `PE_COL'b1 << in_bank; //need to debug
                    // r_Wsram_Wea_Decode_One <= `PE_COL'b1 << in_bank;
                    r_Wsram_Addr_Decode_Two <= 0;
                    r_Wsram_En_Decode_Two <= 0;
                    // r_Wsram_Wea_Decode_Two <= 0;
                end
                else begin
                    r_Wsram_Addr_Decode_Two <= in_addr;
                    r_Instr_Data <= in_data;
                    r_Wsram_En_Decode_Two <= `PE_COL'b1 << in_bank; //need to debug
                    // r_Wsram_Wea_Decode_Two <= `PE_COL'b1 << in_bank;
                    r_Wsram_Addr_Decode_One <= 0;
                    r_Wsram_En_Decode_One <= 0;
                    // r_Wsram_Wea_Decode_One <= 0;
                end
                r_Param_S          <= r_Param_S;
                r_Param_OC         <= r_Param_OC;
                r_Param_IC         <= r_Param_IC;
                r_Param_Trg        <= r_Param_Trg;
                r_Param_Base_Wsram <= r_Param_Base_Wsram ;
                r_Num_Sram_I       <= r_Num_Sram_I;
                r_Num_Sram_W       <= r_Num_Sram_W;
                r_Num_Sram_P       <= r_Num_Sram_P;
                r_Layer_End <= r_Layer_End;
                r_Isram_Addr_Decode_One       <= r_Isram_Addr_Decode_One;
                r_Isram_Addr_Decode_Two       <= r_Isram_Addr_Decode_Two;
                // r_Instr_Data       <= r_Instr_Data;
                r_Isram_Wea_Decode_One        <= r_Isram_Wea_Decode_One;
                r_Isram_Wea_Decode_Two        <= r_Isram_Wea_Decode_Two;
                r_Valid_WB_Psum_One    <= r_Valid_WB_Psum_One;
                r_Valid_WB_Psum_Two    <= r_Valid_WB_Psum_Two;
                // Fsm_Execute_Flag    <= Fsm_Execute_Flag;
                r_WB_Param         <= r_WB_Param;
                r_Psram_Addr_Decode_One       <= r_Psram_Addr_Decode_One;
                r_Psram_Addr_Decode_Two       <= r_Psram_Addr_Decode_Two;
                r_Psram_En_Decode_One         <= r_Psram_En_Decode_One;
                r_Psram_En_Decode_Two         <= r_Psram_En_Decode_Two;
            end
        end
        else if (in_opcode == `OPCODE_EX)begin
            //write signal initialize
            test_flag <= 1'b1;
            Fsm_Execute_Flag <= 1'b1;

            if (!r_Num_Sram_I) begin //isram_1
                r_Isram_Addr_Decode_One <= 0;
                r_Isram_En_Decode_One <= 0;
                r_Isram_Wea_Decode_One <= 0;
            end
            else begin //isram_2
                r_Isram_Addr_Decode_Two <= 0;
                r_Isram_En_Decode_Two <= 0;
                r_Isram_Wea_Decode_Two <= 0;
            end
            if (!r_Num_Sram_W) begin //wsram_1
                r_Wsram_Addr_Decode_One <= 0;
                r_Wsram_En_Decode_One <= 0;
                r_Wsram_Wea_Decode_One <= 0;
            end
            else begin //isram_2
                r_Wsram_Addr_Decode_Two <= 0;
                r_Wsram_En_Decode_Two <= 0;
                r_Wsram_Wea_Decode_Two <= 0;
            end
           

            r_Param_S          <= r_Param_S;
            r_Param_OC         <= r_Param_OC;
            r_Param_IC         <= r_Param_IC;
            r_Param_Trg        <= r_Param_Trg;
            r_Param_Base_Wsram <= r_Param_Base_Wsram ;
            r_Num_Sram_I       <= r_Num_Sram_I;
            r_Num_Sram_W       <= r_Num_Sram_W;
            r_Num_Sram_P       <= r_Num_Sram_P;
            r_Layer_End <= r_Layer_End;
            // r_Isram_Addr_Decode       <= r_Isram_Addr_Decode;
            r_Instr_Data       <= r_Instr_Data;
            // r_Isram_En_Decode         <= r_Isram_En_Decode;
            // r_Isram_Wea        <= r_Isram_Wea;
            // r_Wsram_Addr_Decode       <= r_Wsram_Addr_Decode;
            // r_Wsram_En_Decode         <= r_Wsram_En_Decode;
            // r_Wsram_Wea        <= r_Wsram_Wea;
            r_Valid_WB_Psum_One    <= r_Valid_WB_Psum_One;
            r_Valid_WB_Psum_Two    <= r_Valid_WB_Psum_Two;
            // Fsm_Execute_Flag    <= Fsm_Execute_Flag;
            r_WB_Param         <= r_WB_Param;
            r_Psram_Addr_Decode_One       <= r_Psram_Addr_Decode_One;
            r_Psram_Addr_Decode_Two       <= r_Psram_Addr_Decode_Two;
            r_Psram_En_Decode_One         <= r_Psram_En_Decode_One;
            r_Psram_En_Decode_Two         <= r_Psram_En_Decode_Two;
        end
        else if(in_opcode == `OPCODE_WBPARAM) begin
            r_Valid_WB_Param <= 1'b1;
            case(in_param)
            `PARAM_S: r_WB_Param <= r_Param_S;
            `PARAM_IC: r_WB_Param <= r_Param_IC;
            `PARAM_OC: r_WB_Param <= r_Param_OC;
            `PARAM_TRG: r_WB_Param <= r_Param_Trg;
            `PARAM_BASE_WSRAM: r_WB_Param <= r_Param_Base_Wsram;
            `PARAM_SEL_ISRAM: r_WB_Param <= r_Num_Sram_I;
            `PARAM_SEL_WSRAM: r_WB_Param <= r_Num_Sram_W;
            `PARAM_SEL_PSRAM: r_WB_Param <= r_Num_Sram_P;
            `PARAM_LAYER_END: r_WB_Param <= r_Layer_End;
            default: r_WB_Param <= 0;
            endcase

            r_Param_S          <= r_Param_S;
            r_Param_OC         <= r_Param_OC;
            r_Param_IC         <= r_Param_IC;
            r_Param_Trg        <= r_Param_Trg;
            r_Param_Base_Wsram <= r_Param_Base_Wsram ;
            r_Num_Sram_I      <= r_Num_Sram_I;
            r_Num_Sram_W      <= r_Num_Sram_W;
            r_Num_Sram_P      <= r_Num_Sram_P;
            r_Layer_End <= r_Layer_End;
            r_Isram_Addr_Decode_One       <= r_Isram_Addr_Decode_One;
            r_Isram_Addr_Decode_Two       <= r_Isram_Addr_Decode_Two;
            r_Instr_Data       <= r_Instr_Data;
            r_Isram_En_Decode_One         <= r_Isram_En_Decode_One;
            r_Isram_En_Decode_Two         <= r_Isram_En_Decode_Two;
            r_Isram_Wea_Decode_One        <= r_Isram_Wea_Decode_One;
            r_Isram_Wea_Decode_Two        <= r_Isram_Wea_Decode_Two;
            r_Wsram_Addr_Decode_One       <= r_Wsram_Addr_Decode_One;
            r_Wsram_Addr_Decode_Two       <= r_Wsram_Addr_Decode_Two;
            r_Wsram_En_Decode_One         <= r_Wsram_En_Decode_One;
            r_Wsram_En_Decode_Two         <= r_Wsram_En_Decode_Two;
            r_Wsram_Wea_Decode_One        <= r_Wsram_Wea_Decode_One;
            r_Wsram_Wea_Decode_Two        <= r_Wsram_Wea_Decode_Two;
            r_Valid_WB_Psum_One    <= r_Valid_WB_Psum_One;
            r_Valid_WB_Psum_Two    <= r_Valid_WB_Psum_Two;
            // Fsm_Execute_Flag    <= Fsm_Execute_Flag;
            // r_WB_Param         <= r_WB_Param;
            r_Psram_Addr_Decode_One       <= r_Psram_Addr_Decode_One;
            r_Psram_En_Decode_One         <= r_Psram_En_Decode_One;
        end
        else if(in_opcode == `OPCODE_WBPSRAM)begin
            if(!r_Num_Sram_P) begin
                    r_Psram_Addr_WB_One <= in_addr;
                    r_Psram_En_WB_One <= `PE_COL'b1 << in_bank; //need to debug
                    r_Valid_WB_Psum_One <= 1'b1;
                    r_Psram_Addr_WB_Two <= 0;
                    r_Psram_En_WB_Two <= 0;
                    r_Valid_WB_Psum_Two <= 0;
                end
                else begin
                    r_Psram_Addr_WB_Two <= in_addr;
                    r_Psram_En_WB_Two <= `PE_COL'b1 << in_bank; //need to debug
                    r_Valid_WB_Psum_Two <= 1'b1;
                    r_Psram_Addr_WB_One <= 0;
                    r_Psram_En_WB_One <= 0;
                    r_Valid_WB_Psum_One <= 0;
                end




            r_Param_S          <= r_Param_S;
            r_Param_OC         <= r_Param_OC;
            r_Param_IC         <= r_Param_IC;
            r_Param_Trg        <= r_Param_Trg;
            r_Param_Base_Wsram <= r_Param_Base_Wsram ;
            r_Num_Sram_I       <= r_Num_Sram_I;
            r_Num_Sram_W       <= r_Num_Sram_W;
            r_Num_Sram_P       <= r_Num_Sram_P;
            r_Layer_End <= r_Layer_End;
            r_Isram_Addr_Decode_One       <= r_Isram_Addr_Decode_One;
            r_Isram_Addr_Decode_Two       <= r_Isram_Addr_Decode_Two;
            r_Instr_Data       <= r_Instr_Data;
            r_Isram_En_Decode_One         <= r_Isram_En_Decode_One;
            r_Isram_En_Decode_Two         <= r_Isram_En_Decode_Two;
            r_Isram_Wea_Decode_One        <= r_Isram_Wea_Decode_One;
            r_Isram_Wea_Decode_Two        <= r_Isram_Wea_Decode_Two;
            r_Wsram_Addr_Decode_One       <= r_Wsram_Addr_Decode_One;
            r_Wsram_Addr_Decode_Two       <= r_Wsram_Addr_Decode_Two;
            r_Wsram_En_Decode_One         <= r_Wsram_En_Decode_One;
            r_Wsram_En_Decode_Two         <= r_Wsram_En_Decode_Two;
            r_Wsram_Wea_Decode_One        <= r_Wsram_Wea_Decode_One;
            r_Wsram_Wea_Decode_Two        <= r_Wsram_Wea_Decode_Two;
            // r_Valid_WB_Psum    <= r_Valid_WB_Psum;
            // Fsm_Execute_Flag    <= Fsm_Execute_Flag;
            r_WB_Param         <= r_WB_Param;
            // r_Psram_Addr_Decode       <= r_Psram_Addr_Decode;
            // r_Psram_En_Decode         <= r_Psram_En_Decode;
            
        end

        else if (in_opcode == `OPCODE_INITPSUM)begin
            r_Init_Psum <= 1'b1; //init psum


            r_Psram_En_Decode_One <= r_Psram_En_Decode_One;
            r_Psram_En_Decode_Two <= r_Psram_En_Decode_Two;
            r_Param_S          <= r_Param_S;
            r_Param_OC         <= r_Param_OC;
            r_Param_IC         <= r_Param_IC;
            r_Param_Trg        <= r_Param_Trg;
            r_Param_Base_Wsram <= r_Param_Base_Wsram ;
            r_Num_Sram_I       <= r_Num_Sram_I;
            r_Num_Sram_W       <= r_Num_Sram_W;
            r_Num_Sram_P       <= r_Num_Sram_P;
            r_Layer_End <= r_Layer_End;
            r_Isram_Addr_Decode_One       <= r_Isram_Addr_Decode_One;
            r_Isram_Addr_Decode_Two       <= r_Isram_Addr_Decode_Two;
            r_Instr_Data       <= r_Instr_Data;
            r_Isram_En_Decode_One         <= r_Isram_En_Decode_One;
            r_Isram_En_Decode_Two         <= r_Isram_En_Decode_Two;
            r_Isram_Wea_Decode_One        <= r_Isram_Wea_Decode_One;
            r_Isram_Wea_Decode_Two        <= r_Isram_Wea_Decode_Two;
            r_Wsram_Addr_Decode_One       <= r_Wsram_Addr_Decode_One;
            r_Wsram_Addr_Decode_Two       <= r_Wsram_Addr_Decode_Two;
            r_Wsram_En_Decode_One         <= r_Wsram_En_Decode_One;
            r_Wsram_En_Decode_Two         <= r_Wsram_En_Decode_Two;
            r_Wsram_Wea_Decode_One        <= r_Wsram_Wea_Decode_One;
            r_Wsram_Wea_Decode_Two        <= r_Wsram_Wea_Decode_Two;
            r_Valid_WB_Psum_One    <= r_Valid_WB_Psum_One;
            r_Valid_WB_Psum_Two    <= r_Valid_WB_Psum_Two;
            // Fsm_Execute_Flag    <= Fsm_Execute_Flag;
            r_WB_Param         <= r_WB_Param;
            r_Psram_Addr_Decode_One       <= r_Psram_Addr_Decode_One;
            r_Psram_Addr_Decode_Two       <= r_Psram_Addr_Decode_Two;
        end    

        else begin
            r_Psram_En_Decode_One <= 0;    
            r_Psram_En_Decode_Two <= 0;       


            r_Param_S          <= r_Param_S;
            r_Param_OC         <= r_Param_OC;
            r_Param_IC         <= r_Param_IC;
            r_Param_Trg        <= r_Param_Trg;
            r_Param_Base_Wsram <= r_Param_Base_Wsram ;
            r_Num_Sram_I       <= r_Num_Sram_I;
            r_Num_Sram_W       <= r_Num_Sram_W;
            r_Num_Sram_P       <= r_Num_Sram_P;
            r_Layer_End <= r_Layer_End;
            r_Isram_Addr_Decode_One       <= r_Isram_Addr_Decode_One;
            r_Isram_Addr_Decode_Two       <= r_Isram_Addr_Decode_Two;
            r_Instr_Data       <= r_Instr_Data;
            r_Isram_En_Decode_One         <= r_Isram_En_Decode_One;
            r_Isram_En_Decode_Two         <= r_Isram_En_Decode_Two;
            r_Isram_Wea_Decode_One        <= r_Isram_Wea_Decode_One;
            r_Isram_Wea_Decode_Two        <= r_Isram_Wea_Decode_Two;
            r_Wsram_Addr_Decode_One       <= r_Wsram_Addr_Decode_One;
            r_Wsram_Addr_Decode_Two       <= r_Wsram_Addr_Decode_Two;
            r_Wsram_En_Decode_One         <= r_Wsram_En_Decode_One;
            r_Wsram_En_Decode_Two         <= r_Wsram_En_Decode_Two;
            r_Wsram_Wea_Decode_One        <= r_Wsram_Wea_Decode_One;
            r_Wsram_Wea_Decode_Two        <= r_Wsram_Wea_Decode_Two;
            r_Valid_WB_Psum_One    <= r_Valid_WB_Psum_One;
            r_Valid_WB_Psum_Two    <= r_Valid_WB_Psum_Two;
            // Fsm_Execute_Flag    <= Fsm_Execute_Flag;
            r_WB_Param         <= r_WB_Param;
            r_Psram_Addr_Decode_One       <= r_Psram_Addr_Decode_One;
            r_Psram_Addr_Decode_Two       <= r_Psram_Addr_Decode_Two;

        end
    end
    else begin //else(op_valid)
        r_Param_S          <= r_Param_S;
        r_Param_OC         <= r_Param_OC;
        r_Param_IC         <= r_Param_IC;
        r_Param_Trg        <= r_Param_Trg;
        r_Param_Base_Wsram <= r_Param_Base_Wsram ;
        r_Num_Sram_I       <= r_Num_Sram_I;
        r_Num_Sram_W       <= r_Num_Sram_W;
        r_Num_Sram_P       <= r_Num_Sram_P;
        r_Layer_End <= r_Layer_End;
        r_Isram_Addr_Decode_One       <= r_Isram_Addr_Decode_One;
        r_Isram_Addr_Decode_Two       <= r_Isram_Addr_Decode_Two;
        r_Instr_Data       <= r_Instr_Data;
        r_Isram_En_Decode_One         <= r_Isram_En_Decode_One;
        r_Isram_En_Decode_Two         <= r_Isram_En_Decode_Two;
        r_Isram_Wea_Decode_One        <= r_Isram_Wea_Decode_One;
        r_Isram_Wea_Decode_Two        <= r_Isram_Wea_Decode_Two;
        r_Wsram_Addr_Decode_One       <= r_Wsram_Addr_Decode_One;
        r_Wsram_Addr_Decode_Two       <= r_Wsram_Addr_Decode_Two;
        r_Wsram_En_Decode_One         <= r_Wsram_En_Decode_One;
        r_Wsram_En_Decode_Two         <= r_Wsram_En_Decode_Two;
        r_Wsram_Wea_Decode_One        <= r_Wsram_Wea_Decode_One;
        r_Wsram_Wea_Decode_Two        <= r_Wsram_Wea_Decode_Two;

        r_Valid_WB_Psum_One    <= 0;
        r_Valid_WB_Psum_Two    <= 0;
        if(Last_Execute)begin
            test_flag_2 <= 1'b1;
            Fsm_Execute_Flag <= 0;
        end

        // Fsm_Execute_Flag    <= Fsm_Execute_Flag;
        r_WB_Param         <= r_WB_Param;
        r_Psram_Addr_Decode_One       <= r_Psram_Addr_Decode_One;
        r_Psram_Addr_Decode_Two       <= r_Psram_Addr_Decode_Two;
        r_Psram_En_WB_One         <= 0;
        r_Psram_En_WB_Two         <= 0;
    
        
    end
end


// FSM
// FSM State
// 0: IDLE : wait for instruction(next layer)
// 1: SWITCH : double buffering change
// 2: SET : set value
// 3: LD : weight load
// 4: RUN : input load(= systolic array run)

always@(posedge CLK, posedge RST) begin
    if(RST) begin
        FSM_State <= `FSM_IDLE;
        Fsm_Execute_Flag <= 0;
        r_Psram_Addr_FSM <= 0;
        r_Psram_En_FSM <= 0;
        // r_Psram_Wea <= 0;
        r_Psram_Valid <= 0;
        Run_Cnt <= 0;
        State_IC <= 0;
        State_OC <= 0;
        Base_I <= 0;
        Base_W <= 0;
        Run_OC <= 0;
        Next_OC <= 0;
        Last_OC <= 0;
        Change_OC <= 1'b1;
        Run_IC <= 0;
        Next_IC <= 0;
        r_Wsram_Addr_FSM <= 0;
        r_Wsram_En_FSM <= 0;
        r_Isram_Addr_FSM <= 0;
        r_Isram_En_FSM <= 0;
        Last_Execute <= 0;
        Systolic_En_ID <= 0;
        Systolic_En_W <= 0;
        Finish_Flag <= 0;
        Layer_Finish <= 0;
        test_flag_2 <= 0;
    end

    else begin
        case(FSM_State)
        `FSM_IDLE: begin
            if(Fsm_Execute_Flag) begin
                FSM_State <= `FSM_SWITCH;
                // Fsm_Execute_Flag <= 0;
            end
            else begin
                FSM_State <= `FSM_IDLE;
                // Fsm_Execute_Flag <= Fsm_Execute_Flag;
            end
            // r_Psram_Addr_FSM <= 0;
            // r_Psram_En_FSM <= 0;
            // r_Psram_Wea <= 0;
            r_Psram_Valid <= 0;
            Run_Cnt <= 0;
            State_IC <= 0;
            State_OC <= 0;
            Base_I <= 0;
            Base_W <= 0;
            Run_OC <= 0;
            Next_OC <= 0;
            Last_OC <= 0;
            Change_OC <= 0;
            Run_IC <= 0;
            Next_IC <= 0;
            // r_Wsram_Addr_FSM <= 0;
            // r_Wsram_En_FSM <= 0;
            // r_Isram_Addr_FSM <= 0;
            // r_Isram_En_FSM <= 0;
            Last_Execute <= 0;
            // Systolic_En_ID <= 0;
            // Systolic_En_W <= 0;
            Finish_Flag <= 0;
            Layer_Finish <= 0;
            Layer_Finish_Flag <= 0;
            end
            
    
        `FSM_SWITCH: begin
            //state change
            if (Fsm_Execute_Flag) begin
                FSM_State <= `FSM_SET;
                Fsm_Execute_Flag <= 0;
            end
            else if(Layer_Finish) begin
                FSM_State <= `FSM_IDLE;
                Layer_Finish_Flag <= 1'b1; //Layer Finish & Finish_Flag = 1(Finish_Flag = 1, from Run state)
            end
            else if(Done_Init_Psum && !in_valid) begin//check end of psum init and no instruction
                // FSM_State <= `FSM_SET;
                Done_Init_Psum <= 1'b0;
                Instr_Flag <= 1'b1; //to cpu, if last excution instr is Layer_Finish.
                Layer_Finish <= r_Layer_End; // this computation set is end of layer.
            end
            else begin
                FSM_State <= FSM_State;
                r_Layer_End <= r_Layer_End;
            end

            Finish_Flag <= 0; //reset finish flag



            // set value upload
            Set_Param_S <= r_Param_S;
            Set_Param_OC <= r_Param_OC;
            Set_Param_IC <= r_Param_IC;
            Set_Param_Trg <= r_Param_Trg;
            Set_Param_Base_Wsram <= r_Param_Base_Wsram;

            //Change bram(double buffering), Operating Sram
            Switch_Isram <= r_Num_Sram_I;  
            Switch_Wsram <= r_Num_Sram_W;
            Switch_Psram <= r_Num_Sram_P;     

            // FSM_State <= `FSM_SET;
        end
        
        `FSM_SET: begin
            // State_IC <= Next_IC;
            // State_OC <= Next_OC;
            Base_I <= Set_Param_S * (State_IC / `PE_ROW);
            Base_W <= State_IC + (Set_Param_IC * (State_OC / `PE_COL));
            
            if(State_OC + `PE_COL < Set_Param_OC) begin
                Run_OC <= `BIT_DATA'd`PE_COL;

                if (State_IC + `PE_ROW < Set_Param_IC) begin
                    Run_IC <= `BIT_DATA'd`PE_ROW;
                    Next_IC <= State_IC + `BIT_DATA'd`PE_ROW;
                    Next_OC <= Next_OC;
                end
                else begin
                    Run_IC <= Set_Param_IC - State_IC; 
                    Next_IC <= 0;
                    Next_OC <= State_OC +`PE_COL;
                end

            end
            else begin
                Run_OC <= Set_Param_OC - State_OC;
                if (State_IC + `PE_ROW < Set_Param_IC) begin
                    Run_IC <= `BIT_DATA'd`PE_ROW;
                    Next_IC <= State_IC + `BIT_DATA'd`PE_ROW;
                    Next_OC <= Next_OC;
                end
                else begin
                    Run_IC <= Set_Param_IC - State_IC; 
                    Next_IC <= 0;
                    Next_OC <= 0;
                    Last_Execute <= 1'b1;
                end
            end
            FSM_State <= `FSM_LD;
        end
        `FSM_LD: begin
            if(Run_Cnt < `PE_ROW) begin
                Run_Cnt <= Run_Cnt + 1'd1;
                Systolic_En_ID <= Run_Cnt[5:0];
                if(Run_Cnt < Run_IC) begin
                    r_Wsram_Addr_FSM <= Base_W + Run_Cnt;
                    case(Run_OC)
                    `BIT_PARAM'd1: begin
                        Systolic_En_W <= `PE_COL'b0000_0000_0000_0000_0000_0000_0000_0001;
                        r_Wsram_En_FSM <= `PE_COL'b0000_0000_0000_0000_0000_0000_0000_0001;
                    end
                    `BIT_PARAM'd2: begin
                        Systolic_En_W <= `PE_COL'b0000_0000_0000_0000_0000_0000_0000_0011;
                        r_Wsram_En_FSM <= `PE_COL'b0000_0000_0000_0000_0000_0000_0000_0011;
                    end
                    `BIT_PARAM'd3: begin
                        Systolic_En_W <= `PE_COL'b0000_0000_0000_0000_0000_0000_0000_0111;
                        r_Wsram_En_FSM <= `PE_COL'b0000_0000_0000_0000_0000_0000_0000_0111;
                    end
                    `BIT_PARAM'd4: begin
                        Systolic_En_W <= `PE_COL'b0000_0000_0000_0000_0000_0000_0000_1111;
                        r_Wsram_En_FSM <= `PE_COL'b0000_0000_0000_0000_0000_0000_0000_1111;
                    end
                    `BIT_PARAM'd5: begin
                        Systolic_En_W <= `PE_COL'b0000_0000_0000_0000_0000_0000_0001_1111;
                        r_Wsram_En_FSM <= `PE_COL'b0000_0000_0000_0000_0000_0000_0001_1111;
                    end
                    `BIT_PARAM'd6: begin
                        Systolic_En_W <= `PE_COL'b0000_0000_0000_0000_0000_0000_0011_1111;
                        r_Wsram_En_FSM <= `PE_COL'b0000_0000_0000_0000_0000_0000_0011_1111;
                    end
                    `BIT_PARAM'd7: begin
                        Systolic_En_W <= `PE_COL'b0000_0000_0000_0000_0000_0000_0111_1111;
                        r_Wsram_En_FSM <= `PE_COL'b0000_0000_0000_0000_0000_0000_0111_1111;
                    end
                    `BIT_PARAM'd8: begin
                        Systolic_En_W <= `PE_COL'b0000_0000_0000_0000_0000_0000_1111_1111;
                        r_Wsram_En_FSM <= `PE_COL'b0000_0000_0000_0000_0000_0000_1111_1111;
                    end
                    `BIT_PARAM'd9: begin
                        Systolic_En_W <= `PE_COL'b0000_0000_0000_0000_0000_0001_1111_1111;
                        r_Wsram_En_FSM <= `PE_COL'b0000_0000_0000_0000_0000_0001_1111_1111;
                    end
                    `BIT_PARAM'd10: begin
                        Systolic_En_W <= `PE_COL'b0000_0000_0000_0000_0000_0011_1111_1111;
                        r_Wsram_En_FSM <= `PE_COL'b0000_0000_0000_0000_0000_0011_1111_1111;
                    end
                    `BIT_PARAM'd11: begin
                        Systolic_En_W <= `PE_COL'b0000_0000_0000_0000_0000_0111_1111_1111;
                        r_Wsram_En_FSM <= `PE_COL'b0000_0000_0000_0000_0000_0111_1111_1111;
                    end
                    `BIT_PARAM'd12: begin
                        Systolic_En_W <= `PE_COL'b0000_0000_0000_0000_0000_1111_1111_1111;
                        r_Wsram_En_FSM <= `PE_COL'b0000_0000_0000_0000_0000_1111_1111_1111;
                    end
                    `BIT_PARAM'd13: begin
                        Systolic_En_W <= `PE_COL'b0000_0000_0000_0000_0001_1111_1111_1111;
                        r_Wsram_En_FSM <= `PE_COL'b0000_0000_0000_0000_0001_1111_1111_1111;
                    end
                    `BIT_PARAM'd14: begin
                        Systolic_En_W <= `PE_COL'b0000_0000_0000_0000_0011_1111_1111_1111;
                        r_Wsram_En_FSM <= `PE_COL'b0000_0000_0000_0000_0011_1111_1111_1111;
                    end
                    `BIT_PARAM'd15: begin
                        Systolic_En_W <= `PE_COL'b0000_0000_0000_0000_0111_1111_1111_1111;
                        r_Wsram_En_FSM <= `PE_COL'b0000_0000_0000_0000_0111_1111_1111_1111;
                    end
                    `BIT_PARAM'd16: begin
                        Systolic_En_W <= `PE_COL'b0000_0000_0000_0000_1111_1111_1111_1111;
                        r_Wsram_En_FSM <= `PE_COL'b0000_0000_0000_0000_1111_1111_1111_1111;
                    end
                    `BIT_PARAM'd17: begin
                        Systolic_En_W <= `PE_COL'b0000_0000_0000_0001_1111_1111_1111_1111;
                        r_Wsram_En_FSM <= `PE_COL'b0000_0000_0000_0001_1111_1111_1111_1111;
                    end
                    `BIT_PARAM'd18: begin
                        Systolic_En_W <= `PE_COL'b0000_0000_0000_0011_1111_1111_1111_1111;
                        r_Wsram_En_FSM <= `PE_COL'b0000_0000_0000_0011_1111_1111_1111_1111;
                    end
                    `BIT_PARAM'd19: begin
                        Systolic_En_W <= `PE_COL'b0000_0000_0000_0111_1111_1111_1111_1111;
                        r_Wsram_En_FSM <= `PE_COL'b0000_0000_0000_0111_1111_1111_1111_1111;
                    end
                    `BIT_PARAM'd20: begin
                        Systolic_En_W <= `PE_COL'b0000_0000_0000_1111_1111_1111_1111_1111;
                        r_Wsram_En_FSM <= `PE_COL'b0000_0000_0000_1111_1111_1111_1111_1111;
                    end
                    `BIT_PARAM'd21: begin
                        Systolic_En_W <= `PE_COL'b0000_0000_0001_1111_1111_1111_1111_1111;
                        r_Wsram_En_FSM <= `PE_COL'b0000_0000_0001_1111_1111_1111_1111_1111;
                    end
                    `BIT_PARAM'd22: begin
                        Systolic_En_W <= `PE_COL'b0000_0000_0011_1111_1111_1111_1111_1111;
                        r_Wsram_En_FSM <= `PE_COL'b0000_0000_0011_1111_1111_1111_1111_1111;
                    end
                    `BIT_PARAM'd23: begin
                        Systolic_En_W <= `PE_COL'b0000_0000_0111_1111_1111_1111_1111_1111;
                        r_Wsram_En_FSM <= `PE_COL'b0000_0000_0111_1111_1111_1111_1111_1111;
                    end
                    `BIT_PARAM'd24: begin
                        Systolic_En_W <= `PE_COL'b0000_0000_1111_1111_1111_1111_1111_1111;
                        r_Wsram_En_FSM <= `PE_COL'b0000_0000_1111_1111_1111_1111_1111_1111;
                    end
                    `BIT_PARAM'd25: begin
                        Systolic_En_W <= `PE_COL'b0000_0001_1111_1111_1111_1111_1111_1111;
                        r_Wsram_En_FSM <= `PE_COL'b0000_0001_1111_1111_1111_1111_1111_1111;
                    end
                    `BIT_PARAM'd26: begin
                        Systolic_En_W <= `PE_COL'b0000_0011_1111_1111_1111_1111_1111_1111;
                        r_Wsram_En_FSM <= `PE_COL'b0000_0011_1111_1111_1111_1111_1111_1111;
                    end
                    `BIT_PARAM'd27: begin
                        Systolic_En_W <= `PE_COL'b0000_0111_1111_1111_1111_1111_1111_1111;
                        r_Wsram_En_FSM <= `PE_COL'b0000_0111_1111_1111_1111_1111_1111_1111;
                    end
                    `BIT_PARAM'd28: begin
                        Systolic_En_W <= `PE_COL'b0000_1111_1111_1111_1111_1111_1111_1111;
                        r_Wsram_En_FSM <= `PE_COL'b0000_1111_1111_1111_1111_1111_1111_1111;
                    end
                    `BIT_PARAM'd29: begin
                        Systolic_En_W <= `PE_COL'b0001_1111_1111_1111_1111_1111_1111_1111;
                        r_Wsram_En_FSM <= `PE_COL'b0001_1111_1111_1111_1111_1111_1111_1111;
                    end
                    `BIT_PARAM'd30: begin
                        Systolic_En_W <= `PE_COL'b0011_1111_1111_1111_1111_1111_1111_1111;
                        r_Wsram_En_FSM <= `PE_COL'b0011_1111_1111_1111_1111_1111_1111_1111;
                    end
                    `BIT_PARAM'd31: begin
                        Systolic_En_W <= `PE_COL'b0111_1111_1111_1111_1111_1111_1111_1111;
                        r_Wsram_En_FSM <= `PE_COL'b0111_1111_1111_1111_1111_1111_1111_1111;
                    end
                    `BIT_PARAM'd32: begin
                        Systolic_En_W <= `PE_COL'b1111_1111_1111_1111_1111_1111_1111_1111;
                        r_Wsram_En_FSM <= `PE_COL'b1111_1111_1111_1111_1111_1111_1111_1111;
                    end        
                    default: begin
                        Systolic_En_W <= `PE_COL'b0000_0000_0000_0000_0000_0000_0000_0000;
                        r_Wsram_En_FSM <= `PE_COL'b0000_0000_0000_0000_0000_0000_0000_0000;
                    end
                    endcase
                end
                else begin
                    Systolic_En_W <= 0;
                    r_Wsram_En_FSM <= 0;

                    // Systolic_En_ID <= 0;
                    r_Wsram_Addr_FSM <= 0;
                end 
            end
            else begin
                Run_Cnt <= 0;
                Systolic_En_ID <= 6'd33; //do not weight load, none match Row_ID
                Systolic_En_W <= 0;
                r_Wsram_En_FSM <= 0;
                r_Wsram_Addr_FSM <= 0;
                FSM_State <= `FSM_RUN;
            end
        end
        
        
        `FSM_RUN: begin
            if (Run_Cnt < Set_Param_S) begin
                Run_Cnt <= Run_Cnt + 1'd1;
                r_Isram_Addr_FSM <= Base_I + Run_Cnt;
                r_Psram_Addr_FSM <= (State_OC/`PE_COL) * Set_Param_S + Run_Cnt;

                case(Run_IC)
                    `BIT_PARAM'd1: 
                        r_Isram_En_FSM <= `PE_ROW'b0000_0000_0000_0000_0000_0000_0000_0001;
                    `BIT_PARAM'd2: 
                        r_Isram_En_FSM <= `PE_ROW'b0000_0000_0000_0000_0000_0000_0000_0011;
                    `BIT_PARAM'd3: 
                        r_Isram_En_FSM <= `PE_ROW'b0000_0000_0000_0000_0000_0000_0000_0111;
                    `BIT_PARAM'd4: 
                        r_Isram_En_FSM <= `PE_ROW'b0000_0000_0000_0000_0000_0000_0000_1111;
                    `BIT_PARAM'd5: 
                        r_Isram_En_FSM <= `PE_ROW'b0000_0000_0000_0000_0000_0000_0001_1111;
                    `BIT_PARAM'd6: 
                        r_Isram_En_FSM <= `PE_ROW'b0000_0000_0000_0000_0000_0000_0011_1111;
                    `BIT_PARAM'd7: 
                        r_Isram_En_FSM <= `PE_ROW'b0000_0000_0000_0000_0000_0000_0111_1111;
                    `BIT_PARAM'd8: 
                        r_Isram_En_FSM <= `PE_ROW'b0000_0000_0000_0000_0000_0000_1111_1111;
                    `BIT_PARAM'd9:
                        r_Isram_En_FSM <= `PE_ROW'b0000_0000_0000_0000_0000_0001_1111_1111;
                    `BIT_PARAM'd10:
                        r_Isram_En_FSM <= `PE_ROW'b0000_0000_0000_0000_0000_0011_1111_1111;
                    `BIT_PARAM'd11:
                        r_Isram_En_FSM <= `PE_ROW'b0000_0000_0000_0000_0000_0111_1111_1111;
                    `BIT_PARAM'd12:
                        r_Isram_En_FSM <= `PE_ROW'b0000_0000_0000_0000_0000_1111_1111_1111;
                    `BIT_PARAM'd13:
                        r_Isram_En_FSM <= `PE_ROW'b0000_0000_0000_0000_0001_1111_1111_1111;
                    `BIT_PARAM'd14:
                        r_Isram_En_FSM <= `PE_ROW'b0000_0000_0000_0000_0011_1111_1111_1111;
                    `BIT_PARAM'd15:
                        r_Isram_En_FSM <= `PE_ROW'b0000_0000_0000_0000_0111_1111_1111_1111;
                    `BIT_PARAM'd16:
                        r_Isram_En_FSM <= `PE_ROW'b0000_0000_0000_0000_1111_1111_1111_1111;
                    `BIT_PARAM'd17:
                        r_Isram_En_FSM <= `PE_ROW'b0000_0000_0000_0001_1111_1111_1111_1111;
                    `BIT_PARAM'd18:
                        r_Isram_En_FSM <= `PE_ROW'b0000_0000_0000_0011_1111_1111_1111_1111;
                    `BIT_PARAM'd19:
                        r_Isram_En_FSM <= `PE_ROW'b0000_0000_0000_0111_1111_1111_1111_1111;
                    `BIT_PARAM'd20:
                        r_Isram_En_FSM <= `PE_ROW'b0000_0000_0000_1111_1111_1111_1111_1111;
                    `BIT_PARAM'd21:
                        r_Isram_En_FSM <= `PE_ROW'b0000_0000_0001_1111_1111_1111_1111_1111;
                    `BIT_PARAM'd22:
                        r_Isram_En_FSM <= `PE_ROW'b0000_0000_0011_1111_1111_1111_1111_1111;
                    `BIT_PARAM'd23:
                        r_Isram_En_FSM <= `PE_ROW'b0000_0000_0111_1111_1111_1111_1111_1111;
                    `BIT_PARAM'd24:
                        r_Isram_En_FSM <= `PE_ROW'b0000_0000_1111_1111_1111_1111_1111_1111;
                    `BIT_PARAM'd25:
                        r_Isram_En_FSM <= `PE_ROW'b0000_0001_1111_1111_1111_1111_1111_1111;
                    `BIT_PARAM'd26:
                        r_Isram_En_FSM <= `PE_ROW'b0000_0011_1111_1111_1111_1111_1111_1111;
                    `BIT_PARAM'd27:
                        r_Isram_En_FSM <= `PE_ROW'b0000_0111_1111_1111_1111_1111_1111_1111;
                    `BIT_PARAM'd28:
                        r_Isram_En_FSM <= `PE_ROW'b0000_1111_1111_1111_1111_1111_1111_1111;
                    `BIT_PARAM'd29:
                        r_Isram_En_FSM <= `PE_ROW'b0001_1111_1111_1111_1111_1111_1111_1111;
                    `BIT_PARAM'd30:
                        r_Isram_En_FSM <= `PE_ROW'b0011_1111_1111_1111_1111_1111_1111_1111;
                    `BIT_PARAM'd31:
                        r_Isram_En_FSM <= `PE_ROW'b0111_1111_1111_1111_1111_1111_1111_1111;
                    `BIT_PARAM'd32:
                        r_Isram_En_FSM <= `PE_ROW'b1111_1111_1111_1111_1111_1111_1111_1111;                    
                    default:
                        r_Isram_En_FSM <= `PE_ROW'b0000_0000_0000_0000_0000_0000_0000_0000;
                endcase

                case(Run_OC)
                `BIT_PARAM'd1: begin //use{}
                    r_Psram_En_FSM <= `PE_COL'b0000_0000_0000_0000_0000_0000_0000_0001;
                    r_Psram_Valid <= `PE_COL'b0000_0000_0000_0000_0000_0000_0000_0001;
                end
                `BIT_PARAM'd2: begin
                    r_Psram_En_FSM <= `PE_COL'b0000_0000_0000_0000_0000_0000_0000_0011;
                    r_Psram_Valid <= `PE_COL'b0000_0000_0000_0000_0000_0000_0000_0011;
                end
                `BIT_PARAM'd3: begin
                    r_Psram_En_FSM <= `PE_COL'b0000_0000_0000_0000_0000_0000_0000_0111;
                    r_Psram_Valid <= `PE_COL'b0000_0000_0000_0000_0000_0000_0000_0111;
                end
                `BIT_PARAM'd4: begin
                    r_Psram_En_FSM <= `PE_COL'b0000_0000_0000_0000_0000_0000_0000_1111;
                    r_Psram_Valid <= `PE_COL'b0000_0000_0000_0000_0000_0000_0000_1111;
                end
                `BIT_PARAM'd5: begin
                    r_Psram_En_FSM <= `PE_COL'b0000_0000_0000_0000_0000_0000_0001_1111;
                    r_Psram_Valid <= `PE_COL'b0000_0000_0000_0000_0000_0000_0001_1111;
                end
                `BIT_PARAM'd6: begin
                    r_Psram_En_FSM <= `PE_COL'b0000_0000_0000_0000_0000_0000_0011_1111;
                    r_Psram_Valid <= `PE_COL'b0000_0000_0000_0000_0000_0000_0011_1111;
                end
                `BIT_PARAM'd7: begin
                    r_Psram_En_FSM <= `PE_COL'b0000_0000_0000_0000_0000_0000_0111_1111;
                    r_Psram_Valid <= `PE_COL'b0000_0000_0000_0000_0000_0000_0111_1111;
                end
                `BIT_PARAM'd8: begin
                    r_Psram_En_FSM <= `PE_COL'b0000_0000_0000_0000_0000_0000_1111_1111;
                    r_Psram_Valid <= `PE_COL'b0000_0000_0000_0000_0000_0000_1111_1111;
                end
                `BIT_PARAM'd9: begin
                    r_Psram_En_FSM <= `PE_COL'b0000_0000_0000_0000_0000_0001_1111_1111;
                    r_Psram_Valid <= `PE_COL'b0000_0000_0000_0000_0000_0001_1111_1111;
                end
                `BIT_PARAM'd10: begin
                    r_Psram_En_FSM <= `PE_COL'b0000_0000_0000_0000_0000_0011_1111_1111;
                    r_Psram_Valid <= `PE_COL'b0000_0000_0000_0000_0000_0011_1111_1111;
                end
                `BIT_PARAM'd11: begin
                    r_Psram_En_FSM <= `PE_COL'b0000_0000_0000_0000_0000_0111_1111_1111;
                    r_Psram_Valid <= `PE_COL'b0000_0000_0000_0000_0000_0111_1111_1111;
                end
                `BIT_PARAM'd12: begin
                    r_Psram_En_FSM <= `PE_COL'b0000_0000_0000_0000_0000_1111_1111_1111;
                    r_Psram_Valid <= `PE_COL'b0000_0000_0000_0000_0000_1111_1111_1111;
                end
                `BIT_PARAM'd13: begin
                    r_Psram_En_FSM <= `PE_COL'b0000_0000_0000_0000_0001_1111_1111_1111;
                    r_Psram_Valid <= `PE_COL'b0000_0000_0000_0000_0001_1111_1111_1111;
                end
                `BIT_PARAM'd14: begin
                    r_Psram_En_FSM <= `PE_COL'b0000_0000_0000_0000_0011_1111_1111_1111;
                    r_Psram_Valid <= `PE_COL'b0000_0000_0000_0000_0011_1111_1111_1111;
                end
                `BIT_PARAM'd15: begin
                    r_Psram_En_FSM <= `PE_COL'b0000_0000_0000_0000_0111_1111_1111_1111;
                    r_Psram_Valid <= `PE_COL'b0000_0000_0000_0000_0111_1111_1111_1111;
                end
                `BIT_PARAM'd16: begin
                    r_Psram_En_FSM <= `PE_COL'b0000_0000_0000_0000_1111_1111_1111_1111;
                    r_Psram_Valid <= `PE_COL'b0000_0000_0000_0000_1111_1111_1111_1111;
                end
                `BIT_PARAM'd17: begin
                    r_Psram_En_FSM <= `PE_COL'b0000_0000_0000_0001_1111_1111_1111_1111;
                    r_Psram_Valid <= `PE_COL'b0000_0000_0000_0001_1111_1111_1111_1111;
                end
                `BIT_PARAM'd18: begin
                    r_Psram_En_FSM <= `PE_COL'b0000_0000_0000_0011_1111_1111_1111_1111;
                    r_Psram_Valid <= `PE_COL'b0000_0000_0000_0011_1111_1111_1111_1111;
                end
                `BIT_PARAM'd19: begin
                    r_Psram_En_FSM <= `PE_COL'b0000_0000_0000_0111_1111_1111_1111_1111;
                    r_Psram_Valid <= `PE_COL'b0000_0000_0000_0111_1111_1111_1111_1111;
                end
                `BIT_PARAM'd20: begin
                    r_Psram_En_FSM <= `PE_COL'b0000_0000_0000_1111_1111_1111_1111_1111;
                    r_Psram_Valid <= `PE_COL'b0000_0000_0000_1111_1111_1111_1111_1111;
                end
                `BIT_PARAM'd21: begin
                    r_Psram_En_FSM <= `PE_COL'b0000_0000_0001_1111_1111_1111_1111_1111;
                    r_Psram_Valid <= `PE_COL'b0000_0000_0001_1111_1111_1111_1111_1111;
                end
                `BIT_PARAM'd22: begin
                    r_Psram_En_FSM <= `PE_COL'b0000_0000_0011_1111_1111_1111_1111_1111;
                    r_Psram_Valid <= `PE_COL'b0000_0000_0011_1111_1111_1111_1111_1111;
                end
                `BIT_PARAM'd23: begin
                    r_Psram_En_FSM <= `PE_COL'b0000_0000_0111_1111_1111_1111_1111_1111;
                    r_Psram_Valid <= `PE_COL'b0000_0000_0111_1111_1111_1111_1111_1111;
                end
                `BIT_PARAM'd24: begin
                    r_Psram_En_FSM <= `PE_COL'b0000_0000_1111_1111_1111_1111_1111_1111;
                    r_Psram_Valid <= `PE_COL'b0000_0000_1111_1111_1111_1111_1111_1111;
                end
                `BIT_PARAM'd25: begin
                    r_Psram_En_FSM <= `PE_COL'b0000_0001_1111_1111_1111_1111_1111_1111;
                    r_Psram_Valid <= `PE_COL'b0000_0001_1111_1111_1111_1111_1111_1111;
                end
                `BIT_PARAM'd26: begin
                    r_Psram_En_FSM <= `PE_COL'b0000_0011_1111_1111_1111_1111_1111_1111;
                    r_Psram_Valid <= `PE_COL'b0000_0011_1111_1111_1111_1111_1111_1111;
                end
                `BIT_PARAM'd27: begin
                    r_Psram_En_FSM <= `PE_COL'b0000_0111_1111_1111_1111_1111_1111_1111;
                    r_Psram_Valid <= `PE_COL'b0000_0111_1111_1111_1111_1111_1111_1111;
                end
                `BIT_PARAM'd28: begin
                    r_Psram_En_FSM <= `PE_COL'b0000_1111_1111_1111_1111_1111_1111_1111;
                    r_Psram_Valid <= `PE_COL'b0000_1111_1111_1111_1111_1111_1111_1111;
                end
                `BIT_PARAM'd29: begin
                    r_Psram_En_FSM <= `PE_COL'b0001_1111_1111_1111_1111_1111_1111_1111;
                    r_Psram_Valid <= `PE_COL'b0001_1111_1111_1111_1111_1111_1111_1111;
                end
                `BIT_PARAM'd30: begin
                    r_Psram_En_FSM <= `PE_COL'b0011_1111_1111_1111_1111_1111_1111_1111;
                    r_Psram_Valid <= `PE_COL'b0011_1111_1111_1111_1111_1111_1111_1111;
                end
                `BIT_PARAM'd31: begin
                    r_Psram_En_FSM <= `PE_COL'b0111_1111_1111_1111_1111_1111_1111_1111;
                    r_Psram_Valid <= `PE_COL'b0111_1111_1111_1111_1111_1111_1111_1111;
                end
                `BIT_PARAM'd32: begin
                    r_Psram_En_FSM <= `PE_COL'b1111_1111_1111_1111_1111_1111_1111_1111;
                    r_Psram_Valid <= `PE_COL'b1111_1111_1111_1111_1111_1111_1111_1111;
                end
                default: begin
                    r_Psram_En_FSM <= 0;
                    r_Psram_Valid <= 0;
                end
                endcase

                FSM_State       <= FSM_State;
                // Fsm_Execute_Flag <= Fsm_Execute_Flag ;
                // r_Psram_Addr_FSM    <= r_Psram_Addr_FSM;
                // r_Psram_En_FSM      <= r_Psram_En_FSM;
                // r_Psram_Wea     <= r_Psram_Wea;
                // r_Psram_Valid   <= r_Psram_Valid;
                // Run_Cnt         <= Run_Cnt;
                // State_IC        <= State_IC;
                // State_OC        <= State_OC;
                Base_I          <= Base_I;
                Base_W          <= Base_W;
                Run_OC          <= Run_OC;
                // Next_OC         <= Next_OC;
                Last_OC         <= Last_OC;
                Change_OC       <= Change_OC;
                Run_IC          <= Run_IC;
                // Next_IC         <= Next_IC;
                r_Wsram_Addr_FSM    <= r_Wsram_Addr_FSM;
                r_Wsram_En_FSM      <= r_Wsram_En_FSM;
                // r_Isram_Addr_FSM    <= r_Isram_Addr_FSM;
                // r_Isram_En_FSM      <= r_Isram_En_FSM;
                Last_Execute     <= Last_Execute;
                Systolic_En_ID  <= Systolic_En_ID;
                Systolic_En_W   <= Systolic_En_W;
                Finish_Flag     <= Finish_Flag;
            end
            else begin
                if(Last_Execute) begin
                    FSM_State <= `FSM_SWITCH;
                    // Fsm_Execute_Flag <= 0;
                    Finish_Flag <= 1'b1;
                end
                else begin
                    FSM_State <= `FSM_SET;
                    // Fsm_Execute_Flag <= Fsm_Execute_Flag;
                    Finish_Flag <= Finish_Flag;
                end

                State_IC <= Next_IC;
                State_OC <= Next_OC;

                Run_Cnt <= 0;
                r_Isram_Addr_FSM <= 0;
                r_Psram_Addr_FSM <= 0;
                r_Isram_En_FSM <= 0;
                r_Psram_En_FSM <= 0;
                // r_Psram_Wea <= 0;
                r_Psram_Valid <= 0;




                // FSM_State       <= FSM_State;
                // Fsm_Execute_Flag <= Fsm_Execute_Flag ;
                // r_Psram_Addr_FSM    <= r_Psram_Addr_FSM;
                // r_Psram_En_FSM      <= r_Psram_En_FSM;
                // r_Psram_Wea     <= r_Psram_Wea;
                // r_Psram_Valid   <= r_Psram_Valid;
                // Run_Cnt         <= Run_Cnt;
                // State_IC        <= State_IC;
                // State_OC        <= State_OC;
                Base_I          <= Base_I;
                Base_W          <= Base_W;
                Run_OC          <= Run_OC;
                // Next_OC         <= Next_OC;
                Last_OC         <= Last_OC;
                Change_OC       <= Change_OC;
                Run_IC          <= Run_IC;
                // Next_IC         <= Next_IC;
                r_Wsram_Addr_FSM    <= r_Wsram_Addr_FSM;
                r_Wsram_En_FSM      <= r_Wsram_En_FSM;
                // r_Isram_Addr_FSM    <= r_Isram_Addr_FSM;
                // r_Isram_En_FSM      <= r_Isram_En_FSM;
                Last_Execute     <= Last_Execute;
                Systolic_En_ID  <= Systolic_En_ID;
                Systolic_En_W   <= Systolic_En_W;
                // Finish_Flag     <= Finish_Flag;
            end
            
            
        end




        default: begin

            FSM_State <= `FSM_IDLE;
            // FSM_State       <= FSM_State;
            // Fsm_Execute_Flag <= Fsm_Execute_Flag ;
            r_Psram_Addr_FSM    <= r_Psram_Addr_FSM;
            r_Psram_En_FSM      <= r_Psram_En_FSM;
            // r_Psram_Wea     <= r_Psram_Wea;
            r_Psram_Valid   <= r_Psram_Valid;
            Run_Cnt         <= Run_Cnt;
            State_IC        <= State_IC;
            State_OC        <= State_OC;
            Base_I          <= Base_I;
            Base_W          <= Base_W;
            Run_OC          <= Run_OC;
            Next_OC         <= Next_OC;
            Last_OC         <= Last_OC;
            Change_OC       <= Change_OC;
            Run_IC          <= Run_IC;
            Next_IC         <= Next_IC;
            r_Wsram_Addr_FSM    <= r_Wsram_Addr_FSM;
            r_Wsram_En_FSM      <= r_Wsram_En_FSM;
            r_Isram_Addr_FSM    <= r_Isram_Addr_FSM;
            r_Isram_En_FSM      <= r_Isram_En_FSM;
            Last_Execute     <= Last_Execute;
            Systolic_En_ID  <= Systolic_En_ID;
            Systolic_En_W   <= Systolic_En_W;
            Finish_Flag     <= Finish_Flag;
        end
        endcase
    end
end




//initailize psum sram

always@(posedge CLK, posedge RST) begin
    if(RST) begin
        Run_Cnt_Init <= 0;
        r_Init_Psram_Addr_One <= 0;
        r_Init_Psram_En_One <= 0;
        r_Init_Psram_Wea_One <= 0;
        r_Init_Psram_Addr_Two <= 0;
        r_Init_Psram_En_Two <= 0;
        r_Init_Psram_Wea_Two <= 0;
        Done_Init_Psum <= 0;
    end
    else if(r_Init_Psum && (!Done_Init_Psum)) begin
        if(Run_Cnt_Init < (((r_Param_OC - 8'd1) / `PE_COL)+1'b1) * r_Param_S) begin
            Run_Cnt_Init <= Run_Cnt_Init +1'b1;
            if (!r_Num_Sram_P) begin
                r_Init_Psram_Addr_One <= Run_Cnt_Init;
                r_Init_Psram_En_One <= 1'b1;
                r_Init_Psram_Wea_One <= 1'b1;

            end
            else begin
                r_Init_Psram_Addr_Two <= Run_Cnt_Init;
                r_Init_Psram_En_Two <= 1'b1;
                r_Init_Psram_Wea_Two <= 1'b1;
            end
        end
        else if (Run_Cnt_Init == (((r_Param_OC - 8'd1) / `PE_COL)+1'b1) * r_Param_S) begin
            Done_Init_Psum <= 1'b1;
            r_Init_Psum <= 0;
        end
        else begin
            Run_Cnt_Init <= 0;
            r_Init_Psram_Addr_One <= 0;
            r_Init_Psram_En_One <= 0;
            r_Init_Psram_Wea_One <= 0;
            r_Init_Psram_Addr_Two <= 0;
            r_Init_Psram_En_Two <= 0;
            r_Init_Psram_Wea_Two <= 0;
        end
    end
    else begin
        Run_Cnt_Init <= 0;
        r_Init_Psram_Addr_One <= 0;
        r_Init_Psram_En_One <= 0;
        r_Init_Psram_Wea_One <= 0;
        r_Init_Psram_Addr_Two <= 0;
        r_Init_Psram_En_Two <= 0;
        r_Init_Psram_Wea_Two <= 0;
    end
end


endmodule
