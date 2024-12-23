`include "./param.v"
module dpsram512x24 ( CLK, i_DataIn_A, i_DataIn_B, i_Addr_A, i_Addr_B, 
                  i_EN_R_A, i_EN_R_B, i_EN_W_A, i_EN_W_B, o_DataOut_A, o_DataOut_B );

input   CLK;
input   [23:0]   i_DataIn_A, i_DataIn_B;
input   [8:0]   i_Addr_A, i_Addr_B;
input   i_EN_R_A,   i_EN_W_A;
input    i_EN_R_B,   i_EN_W_B;
output   [23:0]   o_DataOut_A, o_DataOut_B;
//output   o_Valid_A, o_Valid_B;


//reg   [5:0]   AddrBuf;
//reg   EN_R_Buf_A,   EN_W_Buf_A;
//reg EN_R_Buf_B, EN_W_Buf_B;
/*
always @(posedge CLK) begin
   EN_R_Buf_A <= i_EN_R_A;
   EN_R_Buf_B <= i_EN_R_B;
   //EN_W_Buf <= i_EN_W;
end
*/
wire   [23:0] DataIn_A, DataIn_B;
wire   [8:0]   Addr_A, Addr_B;
wire   EN_R_A, EN_W_A;
wire   EN_R_B, EN_W_B;
`ifdef RTL_SIM
   assign   #(`TDLY_MEM)   DataIn_A   = i_DataIn_A;
   assign   #(`TDLY_MEM)   Addr_A   = i_Addr_A;
   assign   #(`TDLY_MEM)   EN_R_A   = i_EN_R_A;
   assign   #(`TDLY_MEM)   EN_W_A   = i_EN_W_A;
   assign   #(`TDLY_MEM)   DataIn_B   = i_DataIn_B;
   assign   #(`TDLY_MEM)   Addr_B   = i_Addr_B;
   assign   #(`TDLY_MEM)   EN_R_B   = i_EN_R_B;
   assign   #(`TDLY_MEM)   EN_W_B   = i_EN_W_B;
`else
   Inverter_chain_for_sim_32 #( .WIDTH(24) ) Inverter_chain_DataIn_A ( .A(i_DataIn_A), .Y(DataIn_A));
   Inverter_chain_for_sim_32 #( .WIDTH(9) ) Inverter_chain_Addr_A ( .A(i_Addr_A), .Y(Addr_A));
   Inverter_chain_for_sim_32 #( .WIDTH(1) ) Inverter_chain_EN_R_A ( .A(i_EN_R_A), .Y(EN_R_A));
   Inverter_chain_for_sim_32 #( .WIDTH(1) ) Inverter_chain_EN_W_A ( .A(i_EN_W_A), .Y(EN_W_A));
   Inverter_chain_for_sim_32 #( .WIDTH(24) ) Inverter_chain_DataIn_B ( .A(i_DataIn_B), .Y(DataIn_B));
   Inverter_chain_for_sim_32 #( .WIDTH(9) ) Inverter_chain_Addr_B ( .A(i_Addr_B), .Y(Addr_B));
   Inverter_chain_for_sim_32 #( .WIDTH(1) ) Inverter_chain_EN_R_B ( .A(i_EN_R_B), .Y(EN_R_B));
   Inverter_chain_for_sim_32 #( .WIDTH(1) ) Inverter_chain_EN_W_B ( .A(i_EN_W_B), .Y(EN_W_B));
`endif
//`ifdef RTL_SIM
//   assign   #(`TDLY_MEM)   DataIn_A   = i_DataIn_A;
//   assign   #(`TDLY_MEM)   Addr_A   = i_Addr_A;
//   assign   #(`TDLY_MEM)   EN_R_A   = i_EN_R_A;
//   assign   #(`TDLY_MEM)   EN_W_A   = i_EN_W_A;
//   assign   #(`TDLY_MEM)   DataIn_B   = i_DataIn_B;
//   assign   #(`TDLY_MEM)   Addr_B   = i_Addr_B;
//   assign   #(`TDLY_MEM)   EN_R_B   = i_EN_R_B;
//   assign   #(`TDLY_MEM)   EN_W_B   = i_EN_W_B;
//`else
//   DLY_HOLD #(24)   DLY_HOLD_DataIn_A ( .A(i_DataIn_A), .Y(DataIn_A) );
//   DLY_HOLD #(9)   DLY_HOLD_Addr_A   ( .A(i_Addr_A), .Y(Addr_A) );
//   DLY_HOLD #(1)   DLY_HOLD_EN_R_A   ( .A(i_EN_R_A), .Y(EN_R_A) );
//   DLY_HOLD #(1)   DLY_HOLD_EN_W_A   ( .A(i_EN_W_A), .Y(EN_W_A) );
//   DLY_HOLD #(24)   DLY_HOLD_DataIn_B ( .A(i_DataIn_B), .Y(DataIn_B) );
//   DLY_HOLD #(9)   DLY_HOLD_Addr_B   ( .A(i_Addr_B), .Y(Addr_B) );
//   DLY_HOLD #(1)   DLY_HOLD_EN_R_B   ( .A(i_EN_R_B), .Y(EN_R_B) );
//   DLY_HOLD #(1)   DLY_HOLD_EN_W_B   ( .A(i_EN_W_B), .Y(EN_W_B) );
//`endif
wire   CENYw_A, WENYw_A;
wire   CENYw_B, WENYw_B;
wire   [8:0]   AYw_A, AYw_B;
wire   [23:0]   Qw_A, Qw_B;
wire   [1:0]   SOw_A, SOw_B;
cmos28lpp_ra2_hd_512x24m8 sram_cmos28lpp_ra2_hd_512x24m8 ( 
//   .VDDCE(1'b1), //1bit
//   .VDDPE(1'b1), //1bit
//   .VSSE(1'b1), //1bit
   .CENYA(CENYw_A), 
   .WENYA(WENYw_A), 
   .AYA(AYw_A), 
   .CENYB(CENYw_B), 
   .WENYB(WENYw_B),
   .AYB(AYw_B), 
   .QA(o_DataOut_A), 
   .QB(o_DataOut_B), 
   .SOA(SOw_A), 
   .SOB(SOw_B), 
   .CLKA(CLK), 
   .CENA(~EN_R_A), 
   .WENA(~EN_W_A), 
   .AA(Addr_A), 
   .DA(DataIn_A), 
   .CLKB(~CLK), 
   .CENB(~EN_R_B), 
   .WENB(~EN_W_B), 
   .AB(Addr_B), 
   .DB(DataIn_B), 
   .EMAA(3'b100),
   .EMAWA(2'd0), 
   .EMAB(3'b100), 
   .EMAWB(2'd0), 
   .TENA(1'b1), 
   .TCENA(1'b1), 
   .TWENA(1'b1), 
   .TAA(9'd0), 
   .TDA(24'd0), 
   .TENB(1'b1), 
   .TCENB(1'b1), 
   .TWENB(1'b1), 
   .TAB(9'd0), 
   .TDB(24'd0),
   .RET1N(1'b1), 
   .SIA(2'd0), 
   .SEA(1'b0), 
   .DFTRAMBYP(1'b0), 
   .SIB(2'd0), 
   .SEB(1'b0), 
   .COLLDISN(1'b1) //1bit
);

//assign   o_Valid_A = EN_R_Buf_A;
//assign   o_Valid_B = EN_R_Buf_B;

endmodule

