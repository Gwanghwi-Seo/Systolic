// ISA (v1)
// OPVALID(1) / OPCODE(3) / SEL(4)+ADDR(16) or PARAM(20) / DATA(8): total(32)

`define PE_ROW 32
`define PE_COL 32

`define BIT_ROW_ID 6

`define OPVALID 1'b1

`define BIT_OPCODE 3
`define OPCODE_NOP   `BIT_OPCODE'd0
`define OPCODE_PARAM  `BIT_OPCODE'd1
`define OPCODE_LDSRAM   `BIT_OPCODE'd2
`define OPCODE_STSRAM   `BIT_OPCODE'd3
`define OPCODE_EX     `BIT_OPCODE'd4
`define OPCODE_WBPSRAM  `BIT_OPCODE'd5
`define OPCODE_WBPARAM  `BIT_OPCODE'd6
`define OPCODE_INITPSUM  `BIT_OPCODE'd7

// param
`define BIT_PARAM   20
`define BIT_SEL    6
`define BIT_ADDR   14
`define BIT_VALID   1
`define PARAM_BASE_WSRAM  `BIT_PARAM'd0
`define PARAM_S    `BIT_PARAM'd1
`define PARAM_OC   `BIT_PARAM'd2
`define PARAM_IC  `BIT_PARAM'd3
`define PARAM_TRG   `BIT_PARAM'd4
`define PARAM_IC_WH  `BIT_PARAM'd5
`define PARAM_BASE_WSRAM_WH  `BIT_PARAM'd6
`define PARAM_SEL_ISRAM  `BIT_PARAM'd7
`define PARAM_SEL_WSRAM  `BIT_PARAM'd8
`define PARAM_SEL_PSRAM  `BIT_PARAM'd9
`define PARAM_LAYER_END  `BIT_PARAM'd10

// data
`define BIT_DATA  8
`define BIT_PSUM  24
`define TRG_ISRAM  `BIT_DATA'd0
`define TRG_WSRAM   `BIT_DATA'd1
`define TRG_PSRAM   `BIT_DATA'd2

`define BIT_INSTR   (1+`BIT_OPCODE+`BIT_PARAM+`BIT_DATA)

//FSM
`define FSM_BIT 3
`define FSM_IDLE `FSM_BIT'd0
`define FSM_SWITCH `FSM_BIT'd1 //Switch double buffer for BRAM
// `define FSM_INIT_PSUM `FSM_BIT'd1
`define FSM_SET `FSM_BIT'd2
`define FSM_LD `FSM_BIT'd3
`define FSM_RUN `FSM_BIT'd4

`define TDLY_MEM 1
//`define RTL SIM



