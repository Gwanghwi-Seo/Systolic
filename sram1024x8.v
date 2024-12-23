`include "./param.v"

module sram1024x8 ( CLK, i_DataIn, i_Addr, i_EN_R, i_EN_W, o_DataOut);

input   CLK;
input   [7:0]   i_DataIn;
input   [9:0]   i_Addr;
input   i_EN_R,   i_EN_W;
output   [7:0]   o_DataOut;
//output   o_Valid;

/*
//reg   [5:0]   AddrBuf;
reg   EN_R_Buf,   EN_W_Buf;

always @(posedge CLK) begin
   EN_R_Buf <= i_EN_R;
   //EN_W_Buf <= i_EN_W;
end
*/
wire   [7:0] DataIn;
wire   [9:0]   Addr;
wire   EN_R, EN_W;

`ifdef RTL_SIM
   assign   #(`TDLY_MEM)   DataIn   = i_DataIn;
   assign   #(`TDLY_MEM)   Addr   = i_Addr;
   assign   #(`TDLY_MEM)   EN_R   = i_EN_R;
   assign   #(`TDLY_MEM)   EN_W   = i_EN_W;
`else
   Inverter_chain_for_sim_4 #( .WIDTH(8) ) Inverter_chain_DataIn ( .A(i_DataIn), .Y(DataIn));
   Inverter_chain_for_sim_4 #( .WIDTH(10) ) Inverter_chain_Addr ( .A(i_Addr), .Y(Addr));
   Inverter_chain_for_sim_4 #( .WIDTH(1) ) Inverter_chain_EN_R ( .A(i_EN_R), .Y(EN_R));
   Inverter_chain_for_sim_4 #( .WIDTH(1) ) Inverter_chain_EN_W ( .A(i_EN_W), .Y(EN_W));
`endif
//`ifdef RTL_SIM
//   assign   #(`TDLY_MEM)   DataIn   = i_DataIn;
//   assign   #(`TDLY_MEM)   Addr   = i_Addr;
//   assign   #(`TDLY_MEM)   EN_R   = i_EN_R;
//   assign   #(`TDLY_MEM)   EN_W   = i_EN_W;
//`else
//   DLY_HOLD #(8)   DLY_HOLD_DataIn ( .A(i_DataIn), .Y(DataIn) );
//   DLY_HOLD #(10)   DLY_HOLD_Addr   ( .A(i_Addr), .Y(Addr) );
//   DLY_HOLD #(1)   DLY_HOLD_EN_R   ( .A(i_EN_R), .Y(EN_R) );
//   DLY_HOLD #(1)   DLY_HOLD_EN_W   ( .A(i_EN_W), .Y(EN_W) );
//`endif

wire   CENYw, WENYw;
wire   [9:0]   AYw;
wire   [7:0]   Qw;
wire   [1:0]   SOw;
cmos28lpp_ra1_hd_1024x8m8 sram_cmos28lpp_ra1_hd_1024x8m8 (
   .CENY(CENYw),
   .WENY(WENYw),
   .AY(AYw),
   .Q(o_DataOut),
   .SO(SOw),
   .CLK(CLK),
   .CEN(~EN_R),
   .WEN(~EN_W),
   .A(Addr),
   .D(DataIn),
   .EMA(3'b100),
   .EMAW(2'd0),
   .TEN(1'b1),
   .TCEN(1'b1),
   .TWEN(1'b1),
   .TA(10'd0),
   .TD(8'd0),
   .RET1N(1'b1),
   .SI(2'd0),
   .SE(1'b0),
   .DFTRAMBYP(1'b0) );

//assign   o_Valid = EN_R_Buf;

endmodule


