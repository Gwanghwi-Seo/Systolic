`include "./param.v"

module systolic_ctrl (
    CLK, RST, i_Instr_In,
    o_Instr_Data,
    o_Isram_Addr, o_Isram_En, o_Isram_Wea,
    o_Wsram_Addr, o_Wsram_En, o_Wsram_Wea,
    o_Psram_Addr, o_Psram_En, o_Psram_Wea, o_Psram_Valid,
    o_Systolic_En_ID, o_Systolic_En_W,
    o_Finish_Flag,
    o_WB_Param , o_Valid_WB_Psum, o_Valid_WB_Param
    );

input CLK, RST;
input [`BIT_INSTR-1:0] i_Instr_In;
output [`BIT_DATA-1:0] o_Instr_Data;

output [`PE_ROW-1:0] o_Isram_En;
output [`PE_ROW-1:0] o_Isram_Wea;
output [`BIT_ADDR-1:0] o_Isram_Addr;

output [`PE_COL-1:0] o_Wsram_En;
output [`PE_COL-1:0] o_Wsram_Wea;
output [`BIT_ADDR-1:0] o_Wsram_Addr;

output [`PE_COL-1:0] o_Psram_En;
output [`PE_COL-1:0] o_Psram_Wea;
output [`BIT_ADDR-1:0] o_Psram_Addr;
output [`PE_COL-1:0] o_Psram_Valid;

output [`BIT_ROW_ID-1:0] o_Systolic_En_ID;
output [`PE_COL-1:0] o_Systolic_En_W;
output o_Finish_Flag;
output [`BIT_DATA-1:0] o_WB_Param;
output o_Valid_WB_Psum;
output o_Valid_WB_Param;

//instruction decoder register
reg [`BIT_DATA-1:0] r_Param_S, r_Param_OC, r_Param_IC;
reg [`BIT_DATA-1:0] r_Param_Trg;
reg [`BIT_DATA-1:0] r_Param_Base_Wsram;
reg [`BIT_DATA-1:0] r_WB_Param;


reg[`BIT_DATA-1:0] r_Instr_Data;

// reg [`PE_ROW-1:0] r_Isram_En;
reg [`PE_ROW-1:0] r_Isram_En_decode;
reg [`PE_ROW-1:0] r_Isram_En_FSM;
reg [`PE_ROW-1:0] r_Isram_Wea;
// reg [`BIT_ADDR-1:0] r_Isram_Addr;
reg [`BIT_ADDR-1:0] r_Isram_Addr_decode;
reg [`BIT_ADDR-1:0] r_Isram_Addr_FSM;

// reg [`PE_COL-1:0] r_Wsram_En;
reg [`PE_COL-1:0] r_Wsram_En_decode;
reg [`PE_COL-1:0] r_Wsram_En_FSM;
reg [`PE_COL-1:0] r_Wsram_Wea;
// reg [`BIT_ADDR-1:0] r_Wsram_Addr;
reg [`BIT_ADDR-1:0] r_Wsram_Addr_decode;
reg [`BIT_ADDR-1:0] r_Wsram_Addr_FSM;

reg Fsm_Execute_Flag;


//fsm register
reg[`FSM_BIT-1:0] FSM_State;
reg[`BIT_PARAM-1:0] Run_Cnt;
reg[`BIT_ADDR-1:0] r_Psram_Addr_decode;
reg[`BIT_ADDR-1:0] r_Psram_Addr_FSM;
reg [`PE_COL-1:0] r_Psram_En_decode, r_Psram_En_FSM, r_Psram_Wea;
reg [`PE_COL-1:0] r_Psram_Valid;
reg r_Valid_WB_Psum, r_Valid_WB_Param;


reg [`BIT_ROW_ID-1:0] Systolic_En_ID;
reg [`PE_COL-1:0] Systolic_En_W;
reg[`BIT_DATA-1:0] Base_I, Base_W;
reg[`BIT_DATA-1:0] State_IC, State_OC;
reg[`BIT_DATA-1:0] Run_IC, Run_OC;
reg [`BIT_PARAM-1:0] Next_OC, Next_IC;
reg Change_OC, Last_OC, Last_Execute;

reg Finish_Flag;

assign o_Isram_Addr = r_Isram_Addr_decode | r_Isram_Addr_FSM;
assign o_Wsram_Addr = r_Wsram_Addr_decode | r_Wsram_Addr_FSM;

assign o_Isram_En = r_Isram_En_decode | r_Isram_En_FSM;
assign o_Wsram_En = r_Wsram_En_decode | r_Wsram_En_FSM;

assign o_Instr_Data = r_Instr_Data;

// assign o_Isram_Addr = r_Isram_Addr;
// assign o_Isram_En = r_Isram_En;
assign o_Isram_Wea = r_Isram_Wea;
// assign o_Wsram_Addr = r_Wsram_Addr;
// assign o_Wsram_En = r_Wsram_En;
assign o_Wsram_Wea = r_Wsram_Wea;
assign o_Psram_Addr = r_Psram_Addr_decode | r_Psram_Addr_FSM;

assign o_Psram_En = r_Psram_En_decode | r_Psram_En_FSM;
assign o_Psram_Wea = r_Psram_Wea;
assign o_Psram_Valid = r_Psram_Valid;

assign o_Systolic_En_ID = Systolic_En_ID;
assign o_Systolic_En_W = Systolic_En_W;
assign o_Finish_Flag = Finish_Flag;

assign o_WB_Param = r_WB_Param;
assign o_Valid_WB_Psum = r_Valid_WB_Psum;
assign o_Valid_WB_Param = r_Valid_WB_Param;

wire in_valid;
wire [`BIT_DATA-1:0] in_data;
wire [`BIT_PARAM-1:0] in_param;
wire [`BIT_ADDR-1:0] in_addr;
wire [`BIT_SEL-1:0] in_bank;
wire [`BIT_OPCODE-1:0] in_opcode;

assign in_data = i_Instr_In[0+:`BIT_DATA];
assign in_param = i_Instr_In[`BIT_DATA +: `BIT_PARAM] ;
assign in_addr = i_Instr_In[`BIT_DATA +: `BIT_ADDR];
assign in_bank = i_Instr_In[(`BIT_DATA+`BIT_ADDR) +: `BIT_SEL] ;
assign in_opcode = i_Instr_In[(`BIT_DATA+`BIT_PARAM) +: `BIT_OPCODE];
assign in_valid = i_Instr_In[(`BIT_DATA+`BIT_PARAM+`BIT_OPCODE) +: 1];


always@(posedge CLK, posedge RST) //instruction decode(not fsm, isram wsram write)
begin
    if(RST) begin
        r_Param_S <= 0;
        r_Param_OC <= 0;
        r_Param_IC <= 0;
        r_Param_Trg <= 0;
        r_Param_Base_Wsram <= 0;
        r_Isram_Addr_decode <= 0;
        r_Instr_Data <= 0;
        r_Isram_En_decode <= 0;
        r_Isram_Wea <= 0;
        r_Wsram_Addr_decode <= 0;
        r_Wsram_En_decode <= 0;
        r_Wsram_Wea <= 0;
        r_Valid_WB_Psum <= 0;
        Fsm_Execute_Flag <= 0;
        r_WB_Param <= 0;
        r_Psram_Addr_decode <= 0;
        r_Psram_En_decode <= 0;
        r_Valid_WB_Param <= 0;
    end
    else if(in_valid) begin
        if(in_opcode == `OPCODE_PARAM)begin
            case(in_param)
            `PARAM_S: begin
                r_Param_S <= in_data;
                r_Param_OC <= r_Param_OC;
                r_Param_IC <= r_Param_IC;
                r_Param_Trg <= r_Param_Trg;
                r_Param_Base_Wsram <= r_Param_Base_Wsram;
            end
            `PARAM_OC: begin
                r_Param_S <= r_Param_S;
                r_Param_OC <= in_data;
                r_Param_IC <= r_Param_IC;
                r_Param_Trg <= r_Param_Trg;
                r_Param_Base_Wsram <= r_Param_Base_Wsram;

            end
            `PARAM_IC: begin
                r_Param_S <= r_Param_S;
                r_Param_OC <= r_Param_OC;
                r_Param_IC <= in_data;
                r_Param_Trg <= r_Param_Trg;
                r_Param_Base_Wsram <= r_Param_Base_Wsram;            
            end
            `PARAM_TRG :begin
                r_Param_S <= r_Param_S;
                r_Param_OC <= r_Param_OC;
                r_Param_IC <= r_Param_IC;
                r_Param_Trg <= in_data;
                r_Param_Base_Wsram <= r_Param_Base_Wsram;
            end
            `PARAM_BASE_WSRAM :begin
                r_Param_S <= r_Param_S;
                r_Param_OC <= r_Param_OC;
                r_Param_IC <= r_Param_IC;
                r_Param_Trg <= r_Param_Trg;
                r_Param_Base_Wsram <= in_data;
            end
            default: begin
                r_Param_S <= r_Param_S;
                r_Param_OC <= r_Param_OC;
                r_Param_IC <= r_Param_IC;
                r_Param_Trg <= r_Param_Trg;
                r_Param_Base_Wsram <= r_Param_Base_Wsram;
            end
            endcase


            r_Isram_Addr_decode       <= 0; //last input 
            r_Isram_En_decode         <= 0;

            // r_Param_S          <= r_Param_S;
            // r_Param_OC         <= r_Param_OC;
            // r_Param_IC         <= r_Param_IC;
            // r_Param_Trg        <= r_Param_Trg;
            // r_Param_Base_Wsram <= r_Param_Base_Wsram ;
            r_Instr_Data       <= r_Instr_Data;
            r_Isram_Wea        <= r_Isram_Wea;
            r_Wsram_Addr_decode       <= r_Wsram_Addr_decode;
            r_Wsram_En_decode         <= r_Wsram_En_decode;
            r_Wsram_Wea        <= r_Wsram_Wea;
            r_Valid_WB_Psum    <= r_Valid_WB_Psum;
            Fsm_Execute_Flag    <= Fsm_Execute_Flag;
            r_WB_Param         <= r_WB_Param;
            r_Psram_Addr_decode       <= r_Psram_Addr_decode;
            r_Psram_En_decode         <= r_Psram_En_decode;


        end
        else if(in_opcode == `OPCODE_LDSRAM)begin
            if(r_Param_Trg == `TRG_ISRAM)begin
                r_Isram_Addr_decode <= in_addr;
                r_Instr_Data <= in_data;
                case(in_bank)
                4'd0: begin //bank0
                    r_Isram_En_decode <= `PE_ROW'b0000_0001;
                    r_Isram_Wea <= `PE_ROW'b0000_0001;
                end
                4'd1: begin //bank1
                    r_Isram_En_decode <= `PE_ROW'b0000_0010;
                    r_Isram_Wea <= `PE_ROW'b0000_0010;
                end
                4'd2: begin //bank2
                    r_Isram_En_decode <= `PE_ROW'b0000_0100;
                    r_Isram_Wea <= `PE_ROW'b0000_0100;
                end
                4'd3: begin //bank3
                    r_Isram_En_decode <= `PE_ROW'b0000_1000;
                    r_Isram_Wea <= `PE_ROW'b0000_1000;
                end
                4'd4: begin //bank4
                    r_Isram_En_decode <= `PE_ROW'b0001_0000;
                    r_Isram_Wea <= `PE_ROW'b0001_0000;
                end
                4'd5: begin //bank5
                    r_Isram_En_decode <= `PE_ROW'b0010_0000;
                    r_Isram_Wea <= `PE_ROW'b0010_0000;
                end
                4'd6: begin //bank6
                    r_Isram_En_decode <= `PE_ROW'b0100_0000;
                    r_Isram_Wea <= `PE_ROW'b0100_0000;
                end
                4'd7: begin //bank7
                    r_Isram_En_decode <= `PE_ROW'b1000_0000;
                    r_Isram_Wea <= `PE_ROW'b1000_0000;
                end
                default: begin
                    r_Isram_En_decode <= `PE_ROW'b0000_0000;
                    r_Isram_Wea <= `PE_ROW'b0000_0000;
                end
                endcase
                r_Param_S          <= r_Param_S;
                r_Param_OC         <= r_Param_OC;
                r_Param_IC         <= r_Param_IC;
                r_Param_Trg        <= r_Param_Trg;
                r_Param_Base_Wsram <= r_Param_Base_Wsram ;
                // r_Isram_Addr_decode       <= r_Isram_Addr_decode;
                // r_Instr_Data       <= r_Instr_Data;
                // r_Isram_En_decode         <= r_Isram_En_decode;
                // r_Isram_Wea        <= r_Isram_Wea;
                // r_Wsram_Addr_decode       <= r_Wsram_Addr_decode;
                // r_Wsram_En_decode         <= r_Wsram_En_decode;
                // r_Wsram_Wea        <= r_Wsram_Wea;
                r_Valid_WB_Psum    <= r_Valid_WB_Psum;
                Fsm_Execute_Flag    <= Fsm_Execute_Flag;
                r_WB_Param         <= 0;
                r_Valid_WB_Param <= 0;
                r_Psram_Addr_decode       <= r_Psram_Addr_decode;
                r_Psram_En_decode         <= r_Psram_En_decode;
            end
            else if(r_Param_Trg == `TRG_WSRAM)begin
                r_Wsram_Addr_decode <= in_addr;
                r_Instr_Data <= in_data;
                case(in_bank)
                4'd0: begin //bank0
                    r_Wsram_En_decode <= `PE_COL'b0001;
                    r_Wsram_Wea <= `PE_COL'b0001;
                end
                4'd1: begin //bank1
                    r_Wsram_En_decode <= `PE_COL'b0010;
                    r_Wsram_Wea <= `PE_COL'b0010;
                end
                4'd2: begin //bank2
                    r_Wsram_En_decode <= `PE_COL'b0100;
                    r_Wsram_Wea <= `PE_COL'b0100;
                end
                4'd3: begin //bank3
                    r_Wsram_En_decode <= `PE_COL'b1000;
                    r_Wsram_Wea <= `PE_COL'b1000;
                end
                default: begin
                    r_Wsram_En_decode <= `PE_COL'b0000;
                    r_Wsram_Wea <= `PE_COL'b0000;
                end

                endcase
            end
            r_Param_S          <= r_Param_S;
            r_Param_OC         <= r_Param_OC;
            r_Param_IC         <= r_Param_IC;
            r_Param_Trg        <= r_Param_Trg;
            r_Param_Base_Wsram <= r_Param_Base_Wsram ;
            // r_Isram_Addr_decode       <= r_Isram_Addr_decode;
            // r_Instr_Data       <= r_Instr_Data;
            // r_Isram_En_decode         <= r_Isram_En_decode;
            // r_Isram_Wea        <= r_Isram_Wea;
            // r_Wsram_Addr_decode       <= r_Wsram_Addr_decode;
            // r_Wsram_En_decode         <= r_Wsram_En_decode;
            // r_Wsram_Wea        <= r_Wsram_Wea;
            r_Valid_WB_Psum    <= r_Valid_WB_Psum;
            Fsm_Execute_Flag    <= Fsm_Execute_Flag;
            r_WB_Param         <= r_WB_Param;
            r_Psram_Addr_decode       <= r_Psram_Addr_decode;
            r_Psram_En_decode         <= r_Psram_En_decode;
        end
        else if (in_opcode == `OPCODE_EX)begin
            r_Isram_Addr_decode <= 0;
            r_Isram_En_decode <= 0;
            r_Isram_Wea <= 0;
            r_Wsram_Addr_decode <= 0;
            r_Wsram_En_decode <= 0;
            r_Wsram_Wea <= 0;
            Fsm_Execute_Flag <= 1'b1;

            r_Param_S          <= r_Param_S;
            r_Param_OC         <= r_Param_OC;
            r_Param_IC         <= r_Param_IC;
            r_Param_Trg        <= r_Param_Trg;
            r_Param_Base_Wsram <= r_Param_Base_Wsram ;
            // r_Isram_Addr_decode       <= r_Isram_Addr_decode;
            r_Instr_Data       <= r_Instr_Data;
            // r_Isram_En_decode         <= r_Isram_En_decode;
            // r_Isram_Wea        <= r_Isram_Wea;
            // r_Wsram_Addr_decode       <= r_Wsram_Addr_decode;
            // r_Wsram_En_decode         <= r_Wsram_En_decode;
            // r_Wsram_Wea        <= r_Wsram_Wea;
            r_Valid_WB_Psum    <= r_Valid_WB_Psum;
            // Fsm_Execute_Flag    <= Fsm_Execute_Flag;
            r_WB_Param         <= r_WB_Param;
            r_Psram_Addr_decode       <= r_Psram_Addr_decode;
            r_Psram_En_decode         <= r_Psram_En_decode;
        end
        else if(in_opcode == `OPCODE_WBPARAM)begin
            r_Valid_WB_Param <= 1'b1;
            case(in_param)
            `PARAM_S: r_WB_Param <= r_Param_S;
            `PARAM_IC: r_WB_Param <= r_Param_IC;
            `PARAM_OC: r_WB_Param <= r_Param_OC;
            default: r_WB_Param <= 0;
            endcase

            r_Param_S          <= r_Param_S;
            r_Param_OC         <= r_Param_OC;
            r_Param_IC         <= r_Param_IC;
            r_Param_Trg        <= r_Param_Trg;
            r_Param_Base_Wsram <= r_Param_Base_Wsram ;
            r_Isram_Addr_decode       <= r_Isram_Addr_decode;
            r_Instr_Data       <= r_Instr_Data;
            r_Isram_En_decode         <= r_Isram_En_decode;
            r_Isram_Wea        <= r_Isram_Wea;
            r_Wsram_Addr_decode       <= r_Wsram_Addr_decode;
            r_Wsram_En_decode         <= r_Wsram_En_decode;
            r_Wsram_Wea        <= r_Wsram_Wea;
            r_Valid_WB_Psum    <= r_Valid_WB_Psum;
            Fsm_Execute_Flag    <= Fsm_Execute_Flag;
            // r_WB_Param         <= r_WB_Param;
            r_Psram_Addr_decode       <= r_Psram_Addr_decode;
            r_Psram_En_decode         <= r_Psram_En_decode;
        end
        else if(in_opcode == `OPCODE_WBPSRAM)begin
            r_Psram_Addr_decode <= in_addr;
            r_Valid_WB_Psum <= 1'b1; //psumout valid signal.
            case(in_bank)
                `BIT_SEL'd0: begin
                    r_Psram_En_decode <= `BIT_SEL'b0001;
                end
                `BIT_SEL'd1: begin
                    r_Psram_En_decode <= `BIT_SEL'b0010;
                end
                `BIT_SEL'd2: begin
                    r_Psram_En_decode <= `BIT_SEL'b0100;
                end
                `BIT_SEL'd3: begin
                    r_Psram_En_decode <= `BIT_SEL'b1000;
                end
                default: begin
                    r_Psram_En_decode <= `BIT_SEL'b0000;
                end
            endcase

            r_Param_S          <= r_Param_S;
            r_Param_OC         <= r_Param_OC;
            r_Param_IC         <= r_Param_IC;
            r_Param_Trg        <= r_Param_Trg;
            r_Param_Base_Wsram <= r_Param_Base_Wsram ;
            r_Isram_Addr_decode       <= r_Isram_Addr_decode;
            r_Instr_Data       <= r_Instr_Data;
            r_Isram_En_decode         <= r_Isram_En_decode;
            r_Isram_Wea        <= r_Isram_Wea;
            r_Wsram_Addr_decode       <= r_Wsram_Addr_decode;
            r_Wsram_En_decode         <= r_Wsram_En_decode;
            r_Wsram_Wea        <= r_Wsram_Wea;
            // r_Valid_WB_Psum    <= r_Valid_WB_Psum;
            Fsm_Execute_Flag    <= Fsm_Execute_Flag;
            r_WB_Param         <= r_WB_Param;
            // r_Psram_Addr_decode       <= r_Psram_Addr_decode;
            // r_Psram_En_decode         <= r_Psram_En_decode;
            
        end
        else begin
            r_Psram_En_decode <= 0;           


            r_Param_S          <= r_Param_S;
            r_Param_OC         <= r_Param_OC;
            r_Param_IC         <= r_Param_IC;
            r_Param_Trg        <= r_Param_Trg;
            r_Param_Base_Wsram <= r_Param_Base_Wsram ;
            r_Isram_Addr_decode       <= r_Isram_Addr_decode;
            r_Instr_Data       <= r_Instr_Data;
            r_Isram_En_decode         <= r_Isram_En_decode;
            r_Isram_Wea        <= r_Isram_Wea;
            r_Wsram_Addr_decode       <= r_Wsram_Addr_decode;
            r_Wsram_En_decode         <= r_Wsram_En_decode;
            r_Wsram_Wea        <= r_Wsram_Wea;
            r_Valid_WB_Psum    <= r_Valid_WB_Psum;
            Fsm_Execute_Flag    <= Fsm_Execute_Flag;
            r_WB_Param         <= r_WB_Param;
            r_Psram_Addr_decode       <= r_Psram_Addr_decode;
            r_Psram_En_decode         <= r_Psram_En_decode;
        end
    end
    else begin //else(op_valid)
        r_Param_S          <= r_Param_S;
        r_Param_OC         <= r_Param_OC;
        r_Param_IC         <= r_Param_IC;
        r_Param_Trg        <= r_Param_Trg;
        r_Param_Base_Wsram <= r_Param_Base_Wsram ;
        r_Isram_Addr_decode       <= r_Isram_Addr_decode;
        r_Instr_Data       <= r_Instr_Data;
        r_Isram_En_decode         <= r_Isram_En_decode;
        r_Isram_Wea        <= r_Isram_Wea;
        r_Wsram_Addr_decode       <= r_Wsram_Addr_decode;
        r_Wsram_En_decode         <= r_Wsram_En_decode;
        r_Wsram_Wea        <= r_Wsram_Wea;
        r_Valid_WB_Psum    <= 0;
        if(Last_Execute)begin
            Fsm_Execute_Flag <= 0;
        end

        // Fsm_Execute_Flag    <= Fsm_Execute_Flag;
        r_WB_Param         <= r_WB_Param;
        r_Psram_Addr_decode       <= r_Psram_Addr_decode;
        r_Psram_En_decode         <= r_Psram_En_decode;
    
        
    end
end


// reg[`FSM_BIT-1:0] FSM_State;
// reg[`CNT_BIT-1:0] Run_Cnt;
// reg[`BIT_ADDR-1:0] r_Psram_Addr;
// reg r_Psram_En, r_Psram_Wea;
// reg[`BIT_PARAM-1:0] Base_I, Base_W;
// reg[`BIT_PARAM-1:0] State_IC, State_OC;
// reg[`BIT_PARAM-1:0] Run_IC, Run_OC;
// reg Change_OC, Last_OC, Last_Execute;



always@(posedge CLK, posedge RST) begin
    if(RST) begin
        FSM_State <= `FSM_IDLE;
        // Fsm_Execute_Flag <= 0;
        r_Psram_Addr_FSM <= 0;
        r_Psram_En_FSM <= 0;
        r_Psram_Wea <= 0;
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
    end

    else begin
        case(FSM_State)
        `FSM_IDLE: begin
            if(Fsm_Execute_Flag) begin
                FSM_State <= `FSM_INIT_PSUM;
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
            Systolic_En_ID <= 0;
            Systolic_En_W <= 0;
            Finish_Flag <= 0;
            end
        end

        `FSM_INIT_PSUM: begin
            if(Run_Cnt < (((r_Param_OC - 8'd1) / `PE_COL)+1'b1) * r_Param_S) begin
                FSM_State <= FSM_State;
                r_Psram_Addr_FSM <= Run_Cnt;
                r_Psram_En_FSM <= 4'b1111;
                r_Psram_Wea <= 4'b1111;
                Run_Cnt <= Run_Cnt +1'b1;
    
                // FSM_State       <= FSM_State;
                // Fsm_Execute_Flag <= Fsm_Execute_Flag ;
                // r_Psram_Addr_FSM    <= r_Psram_Addr_FSM;
                // r_Psram_En_FSM      <= r_Psram_En_FSM;
                // r_Psram_Wea     <= r_Psram_Wea;
                r_Psram_Valid   <= r_Psram_Valid;
                // Run_Cnt         <= Run_Cnt;
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
            else begin
                FSM_State <= `FSM_SET;
                r_Psram_Addr_FSM <= 0;
                r_Psram_En_FSM <= 0;
                r_Psram_Wea <= 0;
                Run_Cnt <= 0;
                // FSM_State       <= FSM_State;
                // Fsm_Execute_Flag <= Fsm_Execute_Flag ;
                // r_Psram_Addr_FSM    <= r_Psram_Addr_FSM;
                // r_Psram_En_FSM      <= r_Psram_En_FSM;
                // r_Psram_Wea     <= r_Psram_Wea;
                r_Psram_Valid   <= r_Psram_Valid;
                // Run_Cnt         <= Run_Cnt;
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
        end
        `FSM_SET: begin
            // State_IC <= Next_IC;
            // State_OC <= Next_OC;
            Base_I <= r_Param_S * (State_IC / `PE_ROW);
            Base_W <= State_IC + (r_Param_IC * (State_OC / `PE_COL));
            
            if(State_OC + `PE_COL < r_Param_OC) begin
                Run_OC <= `BIT_DATA'd`PE_COL;

                if (State_IC + `PE_ROW < r_Param_IC) begin
                    Run_IC <= `BIT_DATA'd`PE_ROW;
                    Next_IC <= State_IC + `BIT_DATA'd`PE_ROW;
                    Next_OC <= Next_OC;
                end
                else begin
                    Run_IC <= r_Param_IC - State_IC; 
                    Next_IC <= 0;
                    Next_OC <= State_OC +`PE_COL;
                end

            end
            else begin
                Run_OC <= r_Param_OC - State_OC;
                if (State_IC + `PE_ROW < r_Param_IC) begin
                    Run_IC <= `BIT_DATA'd`PE_ROW;
                    Next_IC <= State_IC + `BIT_DATA'd`PE_ROW;
                    Next_OC <= Next_OC;
                end
                else begin
                    Run_IC <= r_Param_IC - State_IC; 
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
                Systolic_En_ID <= Run_Cnt[3:0];
                if( Run_Cnt < Run_IC) begin
                    r_Wsram_Addr_FSM <= Base_W + Run_Cnt;    
                    case(Run_OC)
                    `BIT_PARAM'd1: begin
                        Systolic_En_W <= `PE_COL'b0001;
                        r_Wsram_En_FSM <= `PE_COL'b0001;
                    end
                    `BIT_PARAM'd2: begin
                        Systolic_En_W <= `PE_COL'b0011;
                        r_Wsram_En_FSM <= `PE_COL'b0011;
                    end
                    `BIT_PARAM'd3: begin
                        Systolic_En_W <= `PE_COL'b0111;
                        r_Wsram_En_FSM <= `PE_COL'b0111;
                    end
                    `BIT_PARAM'd4: begin
                        Systolic_En_W <= `PE_COL'b1111;
                        r_Wsram_En_FSM <= `PE_COL'b1111;
                    end
                    default: begin
                        Systolic_En_W <= `PE_COL'b0000;
                        r_Wsram_En_FSM <= `PE_COL'b0000;
                    end
                    endcase
                end
                else begin
                    Systolic_En_W <= 0;
                    Systolic_En_ID <= 0;
                    r_Wsram_Addr_FSM <= r_Wsram_Addr_FSM;
                end 
            end
            else begin
                Run_Cnt <= 0;
                Systolic_En_ID <= Systolic_En_ID;
                Systolic_En_W <= 0;
                r_Wsram_En_FSM <= 0;
                r_Wsram_Addr_FSM <= 0;
                FSM_State <= `FSM_RUN;
            end
        end
        
        
        `FSM_RUN: begin
            if (Run_Cnt < r_Param_S) begin
                Run_Cnt <= Run_Cnt + 1'd1;
                r_Isram_Addr_FSM <= Base_I + Run_Cnt;
                r_Psram_Addr_FSM <= (State_OC/`PE_COL) * r_Param_S + Run_Cnt;

                case(Run_IC)
                `BIT_PARAM'd1: 
                    r_Isram_En_FSM <= `PE_ROW'b0000_0001;
                `BIT_PARAM'd2: 
                    r_Isram_En_FSM <= `PE_ROW'b0000_0011;
                `BIT_PARAM'd3: 
                    r_Isram_En_FSM <= `PE_ROW'b0000_0111;
                `BIT_PARAM'd4: 
                    r_Isram_En_FSM <= `PE_ROW'b0000_1111;
                `BIT_PARAM'd5: 
                    r_Isram_En_FSM <= `PE_ROW'b0001_1111;
                `BIT_PARAM'd6: 
                    r_Isram_En_FSM <= `PE_ROW'b0011_1111;
                `BIT_PARAM'd7: 
                    r_Isram_En_FSM <= `PE_ROW'b0111_1111;
                `BIT_PARAM'd8: 
                    r_Isram_En_FSM <= `PE_ROW'b1111_1111;
                default:
                    r_Isram_En_FSM <= `PE_ROW'b0000_0000;
                endcase

                case(Run_OC)
                `BIT_PARAM'd1: begin //use{}
                    r_Psram_En_FSM <= `PE_COL'b0001;
                    r_Psram_Valid <= `PE_COL'b0001;
                end
                `BIT_PARAM'd2: begin
                    r_Psram_En_FSM <= `PE_COL'b0011;
                    r_Psram_Valid <= `PE_COL'b0011;
                end
                `BIT_PARAM'd3: begin
                    r_Psram_En_FSM <= `PE_COL'b0111;
                    r_Psram_Valid <= `PE_COL'b0111;
                end
                `BIT_PARAM'd4: begin
                    r_Psram_En_FSM <= `PE_COL'b1111;
                    r_Psram_Valid <= `PE_COL'b1111;
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
                r_Psram_Wea     <= r_Psram_Wea;
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
                    FSM_State <= `FSM_IDLE;
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
                r_Psram_Wea <= 0;
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
            r_Psram_Wea     <= r_Psram_Wea;
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

endmodule
