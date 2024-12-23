`timescale 1ns / 1ps
`include "./param.v"

module systolic_loader_i (CLK, i_Data_I_In, o_Data_I_In);
    input CLK;
    input [`PE_ROW*`BIT_DATA-1:0] i_Data_I_In;
    output [`PE_ROW*`BIT_DATA-1:0] o_Data_I_In;

    // FIFO Declarations
    reg [`BIT_DATA-1:0] FIFO_1 [0:0];
    reg [`BIT_DATA-1:0] FIFO_2 [1:0];
    reg [`BIT_DATA-1:0] FIFO_3 [2:0];
    reg [`BIT_DATA-1:0] FIFO_4 [3:0];
    reg [`BIT_DATA-1:0] FIFO_5 [4:0];
    reg [`BIT_DATA-1:0] FIFO_6 [5:0];
    reg [`BIT_DATA-1:0] FIFO_7 [6:0];
    reg [`BIT_DATA-1:0] FIFO_8 [7:0];
    reg [`BIT_DATA-1:0] FIFO_9 [8:0];
    reg [`BIT_DATA-1:0] FIFO_10 [9:0];
    reg [`BIT_DATA-1:0] FIFO_11 [10:0];
    reg [`BIT_DATA-1:0] FIFO_12 [11:0];
    reg [`BIT_DATA-1:0] FIFO_13 [12:0];
    reg [`BIT_DATA-1:0] FIFO_14 [13:0];
    reg [`BIT_DATA-1:0] FIFO_15 [14:0];
    reg [`BIT_DATA-1:0] FIFO_16 [15:0];
    reg [`BIT_DATA-1:0] FIFO_17 [16:0];
    reg [`BIT_DATA-1:0] FIFO_18 [17:0];
    reg [`BIT_DATA-1:0] FIFO_19 [18:0];
    reg [`BIT_DATA-1:0] FIFO_20 [19:0];
    reg [`BIT_DATA-1:0] FIFO_21 [20:0];
    reg [`BIT_DATA-1:0] FIFO_22 [21:0];
    reg [`BIT_DATA-1:0] FIFO_23 [22:0];
    reg [`BIT_DATA-1:0] FIFO_24 [23:0];
    reg [`BIT_DATA-1:0] FIFO_25 [24:0];
    reg [`BIT_DATA-1:0] FIFO_26 [25:0];
    reg [`BIT_DATA-1:0] FIFO_27 [26:0];
    reg [`BIT_DATA-1:0] FIFO_28 [27:0];
    reg [`BIT_DATA-1:0] FIFO_29 [28:0];
    reg [`BIT_DATA-1:0] FIFO_30 [29:0];
    reg [`BIT_DATA-1:0] FIFO_31 [30:0];

    // Level 0 Assignments
    assign o_Data_I_In[0*`BIT_DATA +: `BIT_DATA] = i_Data_I_In[0*`BIT_DATA +: `BIT_DATA];
    assign o_Data_I_In[1*`BIT_DATA +: `BIT_DATA] = FIFO_1[0];
    assign o_Data_I_In[2*`BIT_DATA +: `BIT_DATA] = FIFO_2[0];
    assign o_Data_I_In[3*`BIT_DATA +: `BIT_DATA] = FIFO_3[0];
    assign o_Data_I_In[4*`BIT_DATA +: `BIT_DATA] = FIFO_4[0];
    assign o_Data_I_In[5*`BIT_DATA +: `BIT_DATA] = FIFO_5[0];
    assign o_Data_I_In[6*`BIT_DATA +: `BIT_DATA] = FIFO_6[0];
    assign o_Data_I_In[7*`BIT_DATA +: `BIT_DATA] = FIFO_7[0];
    assign o_Data_I_In[8*`BIT_DATA +: `BIT_DATA] = FIFO_8[0];
    assign o_Data_I_In[9*`BIT_DATA +: `BIT_DATA] = FIFO_9[0];
    assign o_Data_I_In[10*`BIT_DATA +: `BIT_DATA] = FIFO_10[0];
    assign o_Data_I_In[11*`BIT_DATA +: `BIT_DATA] = FIFO_11[0];
    assign o_Data_I_In[12*`BIT_DATA +: `BIT_DATA] = FIFO_12[0];
    assign o_Data_I_In[13*`BIT_DATA +: `BIT_DATA] = FIFO_13[0];
    assign o_Data_I_In[14*`BIT_DATA +: `BIT_DATA] = FIFO_14[0];
    assign o_Data_I_In[15*`BIT_DATA +: `BIT_DATA] = FIFO_15[0];
    assign o_Data_I_In[16*`BIT_DATA +: `BIT_DATA] = FIFO_16[0];
    assign o_Data_I_In[17*`BIT_DATA +: `BIT_DATA] = FIFO_17[0];
    assign o_Data_I_In[18*`BIT_DATA +: `BIT_DATA] = FIFO_18[0];
    assign o_Data_I_In[19*`BIT_DATA +: `BIT_DATA] = FIFO_19[0];
    assign o_Data_I_In[20*`BIT_DATA +: `BIT_DATA] = FIFO_20[0];
    assign o_Data_I_In[21*`BIT_DATA +: `BIT_DATA] = FIFO_21[0];
    assign o_Data_I_In[22*`BIT_DATA +: `BIT_DATA] = FIFO_22[0];
    assign o_Data_I_In[23*`BIT_DATA +: `BIT_DATA] = FIFO_23[0];
    assign o_Data_I_In[24*`BIT_DATA +: `BIT_DATA] = FIFO_24[0];
    assign o_Data_I_In[25*`BIT_DATA +: `BIT_DATA] = FIFO_25[0];
    assign o_Data_I_In[26*`BIT_DATA +: `BIT_DATA] = FIFO_26[0];
    assign o_Data_I_In[27*`BIT_DATA +: `BIT_DATA] = FIFO_27[0];
    assign o_Data_I_In[28*`BIT_DATA +: `BIT_DATA] = FIFO_28[0];
    assign o_Data_I_In[29*`BIT_DATA +: `BIT_DATA] = FIFO_29[0];
    assign o_Data_I_In[30*`BIT_DATA +: `BIT_DATA] = FIFO_30[0];
    assign o_Data_I_In[31*`BIT_DATA +: `BIT_DATA] = FIFO_31[0];

    // Level 1 Logic
    always @(posedge CLK) begin
        FIFO_1[0] <= i_Data_I_In[1*`BIT_DATA +: `BIT_DATA];
        FIFO_2[0] <= FIFO_2[1];
        FIFO_3[0] <= FIFO_3[1];
        FIFO_4[0] <= FIFO_4[1];
        FIFO_5[0] <= FIFO_5[1];
        FIFO_6[0] <= FIFO_6[1];
        FIFO_7[0] <= FIFO_7[1];
        FIFO_8[0] <= FIFO_8[1];
        FIFO_9[0] <= FIFO_9[1];
        FIFO_10[0] <= FIFO_10[1];
        FIFO_11[0] <= FIFO_11[1];
        FIFO_12[0] <= FIFO_12[1];
        FIFO_13[0] <= FIFO_13[1];
        FIFO_14[0] <= FIFO_14[1];
        FIFO_15[0] <= FIFO_15[1];
        FIFO_16[0] <= FIFO_16[1];
        FIFO_17[0] <= FIFO_17[1];
        FIFO_18[0] <= FIFO_18[1];
        FIFO_19[0] <= FIFO_19[1];
        FIFO_20[0] <= FIFO_20[1];
        FIFO_21[0] <= FIFO_21[1];
        FIFO_22[0] <= FIFO_22[1];
        FIFO_23[0] <= FIFO_23[1];
        FIFO_24[0] <= FIFO_24[1];
        FIFO_25[0] <= FIFO_25[1];
        FIFO_26[0] <= FIFO_26[1];
        FIFO_27[0] <= FIFO_27[1];
        FIFO_28[0] <= FIFO_28[1];
        FIFO_29[0] <= FIFO_29[1];
        FIFO_30[0] <= FIFO_30[1];
        FIFO_31[0] <= FIFO_31[1];
    end

    // Level 2 Logic
    always @(posedge CLK) begin
        FIFO_2[1] <= i_Data_I_In[2*`BIT_DATA +: `BIT_DATA];
        FIFO_3[1] <= FIFO_3[2];
        FIFO_4[1] <= FIFO_4[2];
        FIFO_5[1] <= FIFO_5[2];
        FIFO_6[1] <= FIFO_6[2];
        FIFO_7[1] <= FIFO_7[2];
        FIFO_8[1] <= FIFO_8[2];
        FIFO_9[1] <= FIFO_9[2];
        FIFO_10[1] <= FIFO_10[2];
        FIFO_11[1] <= FIFO_11[2];
        FIFO_12[1] <= FIFO_12[2];
        FIFO_13[1] <= FIFO_13[2];
        FIFO_14[1] <= FIFO_14[2];
        FIFO_15[1] <= FIFO_15[2];
        FIFO_16[1] <= FIFO_16[2];
        FIFO_17[1] <= FIFO_17[2];
        FIFO_18[1] <= FIFO_18[2];
        FIFO_19[1] <= FIFO_19[2];
        FIFO_20[1] <= FIFO_20[2];
        FIFO_21[1] <= FIFO_21[2];
        FIFO_22[1] <= FIFO_22[2];
        FIFO_23[1] <= FIFO_23[2];
        FIFO_24[1] <= FIFO_24[2];
        FIFO_25[1] <= FIFO_25[2];
        FIFO_26[1] <= FIFO_26[2];
        FIFO_27[1] <= FIFO_27[2];
        FIFO_28[1] <= FIFO_28[2];
        FIFO_29[1] <= FIFO_29[2];
        FIFO_30[1] <= FIFO_30[2];
        FIFO_31[1] <= FIFO_31[2];
    end

    // Level 3 Logic
    always @(posedge CLK) begin
        FIFO_3[2] <= i_Data_I_In[3*`BIT_DATA +: `BIT_DATA];
        FIFO_4[2] <= FIFO_4[3];
        FIFO_5[2] <= FIFO_5[3];
        FIFO_6[2] <= FIFO_6[3];
        FIFO_7[2] <= FIFO_7[3];
        FIFO_8[2] <= FIFO_8[3];
        FIFO_9[2] <= FIFO_9[3];
        FIFO_10[2] <= FIFO_10[3];
        FIFO_11[2] <= FIFO_11[3];
        FIFO_12[2] <= FIFO_12[3];
        FIFO_13[2] <= FIFO_13[3];
        FIFO_14[2] <= FIFO_14[3];
        FIFO_15[2] <= FIFO_15[3];
        FIFO_16[2] <= FIFO_16[3];
        FIFO_17[2] <= FIFO_17[3];
        FIFO_18[2] <= FIFO_18[3];
        FIFO_19[2] <= FIFO_19[3];
        FIFO_20[2] <= FIFO_20[3];
        FIFO_21[2] <= FIFO_21[3];
        FIFO_22[2] <= FIFO_22[3];
        FIFO_23[2] <= FIFO_23[3];
        FIFO_24[2] <= FIFO_24[3];
        FIFO_25[2] <= FIFO_25[3];
        FIFO_26[2] <= FIFO_26[3];
        FIFO_27[2] <= FIFO_27[3];
        FIFO_28[2] <= FIFO_28[3];
        FIFO_29[2] <= FIFO_29[3];
        FIFO_30[2] <= FIFO_30[3];
        FIFO_31[2] <= FIFO_31[3];
    end

    // Level 4 Logic
    always @(posedge CLK) begin
        FIFO_4[3] <= i_Data_I_In[4*`BIT_DATA +: `BIT_DATA];
        FIFO_5[3] <= FIFO_5[4];
        FIFO_6[3] <= FIFO_6[4];
        FIFO_7[3] <= FIFO_7[4];
        FIFO_8[3] <= FIFO_8[4];
        FIFO_9[3] <= FIFO_9[4];
        FIFO_10[3] <= FIFO_10[4];
        FIFO_11[3] <= FIFO_11[4];
        FIFO_12[3] <= FIFO_12[4];
        FIFO_13[3] <= FIFO_13[4];
        FIFO_14[3] <= FIFO_14[4];
        FIFO_15[3] <= FIFO_15[4];
        FIFO_16[3] <= FIFO_16[4];
        FIFO_17[3] <= FIFO_17[4];
        FIFO_18[3] <= FIFO_18[4];
        FIFO_19[3] <= FIFO_19[4];
        FIFO_20[3] <= FIFO_20[4];
        FIFO_21[3] <= FIFO_21[4];
        FIFO_22[3] <= FIFO_22[4];
        FIFO_23[3] <= FIFO_23[4];
        FIFO_24[3] <= FIFO_24[4];
        FIFO_25[3] <= FIFO_25[4];
        FIFO_26[3] <= FIFO_26[4];
        FIFO_27[3] <= FIFO_27[4];
        FIFO_28[3] <= FIFO_28[4];
        FIFO_29[3] <= FIFO_29[4];
        FIFO_30[3] <= FIFO_30[4];
        FIFO_31[3] <= FIFO_31[4];
    end

    // Level 5 Logic
    always @(posedge CLK) begin
        FIFO_5[4] <= i_Data_I_In[5*`BIT_DATA +: `BIT_DATA];
        FIFO_6[4] <= FIFO_6[5];
        FIFO_7[4] <= FIFO_7[5];
        FIFO_8[4] <= FIFO_8[5];
        FIFO_9[4] <= FIFO_9[5];
        FIFO_10[4] <= FIFO_10[5];
        FIFO_11[4] <= FIFO_11[5];
        FIFO_12[4] <= FIFO_12[5];
        FIFO_13[4] <= FIFO_13[5];
        FIFO_14[4] <= FIFO_14[5];
        FIFO_15[4] <= FIFO_15[5];
        FIFO_16[4] <= FIFO_16[5];
        FIFO_17[4] <= FIFO_17[5];
        FIFO_18[4] <= FIFO_18[5];
        FIFO_19[4] <= FIFO_19[5];
        FIFO_20[4] <= FIFO_20[5];
        FIFO_21[4] <= FIFO_21[5];
        FIFO_22[4] <= FIFO_22[5];
        FIFO_23[4] <= FIFO_23[5];
        FIFO_24[4] <= FIFO_24[5];
        FIFO_25[4] <= FIFO_25[5];
        FIFO_26[4] <= FIFO_26[5];
        FIFO_27[4] <= FIFO_27[5];
        FIFO_28[4] <= FIFO_28[5];
        FIFO_29[4] <= FIFO_29[5];
        FIFO_30[4] <= FIFO_30[5];
        FIFO_31[4] <= FIFO_31[5];
    end

    // Level 6 Logic
    always @(posedge CLK) begin
        FIFO_6[5] <= i_Data_I_In[6*`BIT_DATA +: `BIT_DATA];
        FIFO_7[5] <= FIFO_7[6];
        FIFO_8[5] <= FIFO_8[6];
        FIFO_9[5] <= FIFO_9[6];
        FIFO_10[5] <= FIFO_10[6];
        FIFO_11[5] <= FIFO_11[6];
        FIFO_12[5] <= FIFO_12[6];
        FIFO_13[5] <= FIFO_13[6];
        FIFO_14[5] <= FIFO_14[6];
        FIFO_15[5] <= FIFO_15[6];
        FIFO_16[5] <= FIFO_16[6];
        FIFO_17[5] <= FIFO_17[6];
        FIFO_18[5] <= FIFO_18[6];
        FIFO_19[5] <= FIFO_19[6];
        FIFO_20[5] <= FIFO_20[6];
        FIFO_21[5] <= FIFO_21[6];
        FIFO_22[5] <= FIFO_22[6];
        FIFO_23[5] <= FIFO_23[6];
        FIFO_24[5] <= FIFO_24[6];
        FIFO_25[5] <= FIFO_25[6];
        FIFO_26[5] <= FIFO_26[6];
        FIFO_27[5] <= FIFO_27[6];
        FIFO_28[5] <= FIFO_28[6];
        FIFO_29[5] <= FIFO_29[6];
        FIFO_30[5] <= FIFO_30[6];
        FIFO_31[5] <= FIFO_31[6];
    end

    // Level 7 Logic
    always @(posedge CLK) begin
        FIFO_7[6] <= i_Data_I_In[7*`BIT_DATA +: `BIT_DATA];
        FIFO_8[6] <= FIFO_8[7];
        FIFO_9[6] <= FIFO_9[7];
        FIFO_10[6] <= FIFO_10[7];
        FIFO_11[6] <= FIFO_11[7];
        FIFO_12[6] <= FIFO_12[7];
        FIFO_13[6] <= FIFO_13[7];
        FIFO_14[6] <= FIFO_14[7];
        FIFO_15[6] <= FIFO_15[7];
        FIFO_16[6] <= FIFO_16[7];
        FIFO_17[6] <= FIFO_17[7];
        FIFO_18[6] <= FIFO_18[7];
        FIFO_19[6] <= FIFO_19[7];
        FIFO_20[6] <= FIFO_20[7];
        FIFO_21[6] <= FIFO_21[7];
        FIFO_22[6] <= FIFO_22[7];
        FIFO_23[6] <= FIFO_23[7];
        FIFO_24[6] <= FIFO_24[7];
        FIFO_25[6] <= FIFO_25[7];
        FIFO_26[6] <= FIFO_26[7];
        FIFO_27[6] <= FIFO_27[7];
        FIFO_28[6] <= FIFO_28[7];
        FIFO_29[6] <= FIFO_29[7];
        FIFO_30[6] <= FIFO_30[7];
        FIFO_31[6] <= FIFO_31[7];
    end

    // Level 8 Logic
    always @(posedge CLK) begin
        FIFO_8[7] <= i_Data_I_In[8*`BIT_DATA +: `BIT_DATA];
        FIFO_9[7] <= FIFO_9[8];
        FIFO_10[7] <= FIFO_10[8];
        FIFO_11[7] <= FIFO_11[8];
        FIFO_12[7] <= FIFO_12[8];
        FIFO_13[7] <= FIFO_13[8];
        FIFO_14[7] <= FIFO_14[8];
        FIFO_15[7] <= FIFO_15[8];
        FIFO_16[7] <= FIFO_16[8];
        FIFO_17[7] <= FIFO_17[8];
        FIFO_18[7] <= FIFO_18[8];
        FIFO_19[7] <= FIFO_19[8];
        FIFO_20[7] <= FIFO_20[8];
        FIFO_21[7] <= FIFO_21[8];
        FIFO_22[7] <= FIFO_22[8];
        FIFO_23[7] <= FIFO_23[8];
        FIFO_24[7] <= FIFO_24[8];
        FIFO_25[7] <= FIFO_25[8];
        FIFO_26[7] <= FIFO_26[8];
        FIFO_27[7] <= FIFO_27[8];
        FIFO_28[7] <= FIFO_28[8];
        FIFO_29[7] <= FIFO_29[8];
        FIFO_30[7] <= FIFO_30[8];
        FIFO_31[7] <= FIFO_31[8];
    end

    // Level 9 Logic
    always @(posedge CLK) begin
        FIFO_9[8] <= i_Data_I_In[9*`BIT_DATA +: `BIT_DATA];
        FIFO_10[8] <= FIFO_10[9];
        FIFO_11[8] <= FIFO_11[9];
        FIFO_12[8] <= FIFO_12[9];
        FIFO_13[8] <= FIFO_13[9];
        FIFO_14[8] <= FIFO_14[9];
        FIFO_15[8] <= FIFO_15[9];
        FIFO_16[8] <= FIFO_16[9];
        FIFO_17[8] <= FIFO_17[9];
        FIFO_18[8] <= FIFO_18[9];
        FIFO_19[8] <= FIFO_19[9];
        FIFO_20[8] <= FIFO_20[9];
        FIFO_21[8] <= FIFO_21[9];
        FIFO_22[8] <= FIFO_22[9];
        FIFO_23[8] <= FIFO_23[9];
        FIFO_24[8] <= FIFO_24[9];
        FIFO_25[8] <= FIFO_25[9];
        FIFO_26[8] <= FIFO_26[9];
        FIFO_27[8] <= FIFO_27[9];
        FIFO_28[8] <= FIFO_28[9];
        FIFO_29[8] <= FIFO_29[9];
        FIFO_30[8] <= FIFO_30[9];
        FIFO_31[8] <= FIFO_31[9];
    end

    // Level 10 Logic
    always @(posedge CLK) begin
        FIFO_10[9] <= i_Data_I_In[10*`BIT_DATA +: `BIT_DATA];
        FIFO_11[9] <= FIFO_11[10];
        FIFO_12[9] <= FIFO_12[10];
        FIFO_13[9] <= FIFO_13[10];
        FIFO_14[9] <= FIFO_14[10];
        FIFO_15[9] <= FIFO_15[10];
        FIFO_16[9] <= FIFO_16[10];
        FIFO_17[9] <= FIFO_17[10];
        FIFO_18[9] <= FIFO_18[10];
        FIFO_19[9] <= FIFO_19[10];
        FIFO_20[9] <= FIFO_20[10];
        FIFO_21[9] <= FIFO_21[10];
        FIFO_22[9] <= FIFO_22[10];
        FIFO_23[9] <= FIFO_23[10];
        FIFO_24[9] <= FIFO_24[10];
        FIFO_25[9] <= FIFO_25[10];
        FIFO_26[9] <= FIFO_26[10];
        FIFO_27[9] <= FIFO_27[10];
        FIFO_28[9] <= FIFO_28[10];
        FIFO_29[9] <= FIFO_29[10];
        FIFO_30[9] <= FIFO_30[10];
        FIFO_31[9] <= FIFO_31[10];
    end

    // Level 11 Logic
    always @(posedge CLK) begin
        FIFO_11[10] <= i_Data_I_In[11*`BIT_DATA +: `BIT_DATA];
        FIFO_12[10] <= FIFO_12[11];
        FIFO_13[10] <= FIFO_13[11];
        FIFO_14[10] <= FIFO_14[11];
        FIFO_15[10] <= FIFO_15[11];
        FIFO_16[10] <= FIFO_16[11];
        FIFO_17[10] <= FIFO_17[11];
        FIFO_18[10] <= FIFO_18[11];
        FIFO_19[10] <= FIFO_19[11];
        FIFO_20[10] <= FIFO_20[11];
        FIFO_21[10] <= FIFO_21[11];
        FIFO_22[10] <= FIFO_22[11];
        FIFO_23[10] <= FIFO_23[11];
        FIFO_24[10] <= FIFO_24[11];
        FIFO_25[10] <= FIFO_25[11];
        FIFO_26[10] <= FIFO_26[11];
        FIFO_27[10] <= FIFO_27[11];
        FIFO_28[10] <= FIFO_28[11];
        FIFO_29[10] <= FIFO_29[11];
        FIFO_30[10] <= FIFO_30[11];
        FIFO_31[10] <= FIFO_31[11];
    end

    // Level 12 Logic
    always @(posedge CLK) begin
        FIFO_12[11] <= i_Data_I_In[12*`BIT_DATA +: `BIT_DATA];
        FIFO_13[11] <= FIFO_13[12];
        FIFO_14[11] <= FIFO_14[12];
        FIFO_15[11] <= FIFO_15[12];
        FIFO_16[11] <= FIFO_16[12];
        FIFO_17[11] <= FIFO_17[12];
        FIFO_18[11] <= FIFO_18[12];
        FIFO_19[11] <= FIFO_19[12];
        FIFO_20[11] <= FIFO_20[12];
        FIFO_21[11] <= FIFO_21[12];
        FIFO_22[11] <= FIFO_22[12];
        FIFO_23[11] <= FIFO_23[12];
        FIFO_24[11] <= FIFO_24[12];
        FIFO_25[11] <= FIFO_25[12];
        FIFO_26[11] <= FIFO_26[12];
        FIFO_27[11] <= FIFO_27[12];
        FIFO_28[11] <= FIFO_28[12];
        FIFO_29[11] <= FIFO_29[12];
        FIFO_30[11] <= FIFO_30[12];
        FIFO_31[11] <= FIFO_31[12];
    end

    // Level 13 Logic
    always @(posedge CLK) begin
        FIFO_13[12] <= i_Data_I_In[13*`BIT_DATA +: `BIT_DATA];
        FIFO_14[12] <= FIFO_14[13];
        FIFO_15[12] <= FIFO_15[13];
        FIFO_16[12] <= FIFO_16[13];
        FIFO_17[12] <= FIFO_17[13];
        FIFO_18[12] <= FIFO_18[13];
        FIFO_19[12] <= FIFO_19[13];
        FIFO_20[12] <= FIFO_20[13];
        FIFO_21[12] <= FIFO_21[13];
        FIFO_22[12] <= FIFO_22[13];
        FIFO_23[12] <= FIFO_23[13];
        FIFO_24[12] <= FIFO_24[13];
        FIFO_25[12] <= FIFO_25[13];
        FIFO_26[12] <= FIFO_26[13];
        FIFO_27[12] <= FIFO_27[13];
        FIFO_28[12] <= FIFO_28[13];
        FIFO_29[12] <= FIFO_29[13];
        FIFO_30[12] <= FIFO_30[13];
        FIFO_31[12] <= FIFO_31[13];
    end

    // Level 14 Logic
    always @(posedge CLK) begin
        FIFO_14[13] <= i_Data_I_In[14*`BIT_DATA +: `BIT_DATA];
        FIFO_15[13] <= FIFO_15[14];
        FIFO_16[13] <= FIFO_16[14];
        FIFO_17[13] <= FIFO_17[14];
        FIFO_18[13] <= FIFO_18[14];
        FIFO_19[13] <= FIFO_19[14];
        FIFO_20[13] <= FIFO_20[14];
        FIFO_21[13] <= FIFO_21[14];
        FIFO_22[13] <= FIFO_22[14];
        FIFO_23[13] <= FIFO_23[14];
        FIFO_24[13] <= FIFO_24[14];
        FIFO_25[13] <= FIFO_25[14];
        FIFO_26[13] <= FIFO_26[14];
        FIFO_27[13] <= FIFO_27[14];
        FIFO_28[13] <= FIFO_28[14];
        FIFO_29[13] <= FIFO_29[14];
        FIFO_30[13] <= FIFO_30[14];
        FIFO_31[13] <= FIFO_31[14];
    end

    // Level 15 Logic
    always @(posedge CLK) begin
        FIFO_15[14] <= i_Data_I_In[15*`BIT_DATA +: `BIT_DATA];
        FIFO_16[14] <= FIFO_16[15];
        FIFO_17[14] <= FIFO_17[15];
        FIFO_18[14] <= FIFO_18[15];
        FIFO_19[14] <= FIFO_19[15];
        FIFO_20[14] <= FIFO_20[15];
        FIFO_21[14] <= FIFO_21[15];
        FIFO_22[14] <= FIFO_22[15];
        FIFO_23[14] <= FIFO_23[15];
        FIFO_24[14] <= FIFO_24[15];
        FIFO_25[14] <= FIFO_25[15];
        FIFO_26[14] <= FIFO_26[15];
        FIFO_27[14] <= FIFO_27[15];
        FIFO_28[14] <= FIFO_28[15];
        FIFO_29[14] <= FIFO_29[15];
        FIFO_30[14] <= FIFO_30[15];
        FIFO_31[14] <= FIFO_31[15];
    end

    // Level 16 Logic
    always @(posedge CLK) begin
        FIFO_16[15] <= i_Data_I_In[16*`BIT_DATA +: `BIT_DATA];
        FIFO_17[15] <= FIFO_17[16];
        FIFO_18[15] <= FIFO_18[16];
        FIFO_19[15] <= FIFO_19[16];
        FIFO_20[15] <= FIFO_20[16];
        FIFO_21[15] <= FIFO_21[16];
        FIFO_22[15] <= FIFO_22[16];
        FIFO_23[15] <= FIFO_23[16];
        FIFO_24[15] <= FIFO_24[16];
        FIFO_25[15] <= FIFO_25[16];
        FIFO_26[15] <= FIFO_26[16];
        FIFO_27[15] <= FIFO_27[16];
        FIFO_28[15] <= FIFO_28[16];
        FIFO_29[15] <= FIFO_29[16];
        FIFO_30[15] <= FIFO_30[16];
        FIFO_31[15] <= FIFO_31[16];
    end

    // Level 17 Logic
    always @(posedge CLK) begin
        FIFO_17[16] <= i_Data_I_In[17*`BIT_DATA +: `BIT_DATA];
        FIFO_18[16] <= FIFO_18[17];
        FIFO_19[16] <= FIFO_19[17];
        FIFO_20[16] <= FIFO_20[17];
        FIFO_21[16] <= FIFO_21[17];
        FIFO_22[16] <= FIFO_22[17];
        FIFO_23[16] <= FIFO_23[17];
        FIFO_24[16] <= FIFO_24[17];
        FIFO_25[16] <= FIFO_25[17];
        FIFO_26[16] <= FIFO_26[17];
        FIFO_27[16] <= FIFO_27[17];
        FIFO_28[16] <= FIFO_28[17];
        FIFO_29[16] <= FIFO_29[17];
        FIFO_30[16] <= FIFO_30[17];
        FIFO_31[16] <= FIFO_31[17];
    end

    // Level 18 Logic
    always @(posedge CLK) begin
        FIFO_18[17] <= i_Data_I_In[18*`BIT_DATA +: `BIT_DATA];
        FIFO_19[17] <= FIFO_19[18];
        FIFO_20[17] <= FIFO_20[18];
        FIFO_21[17] <= FIFO_21[18];
        FIFO_22[17] <= FIFO_22[18];
        FIFO_23[17] <= FIFO_23[18];
        FIFO_24[17] <= FIFO_24[18];
        FIFO_25[17] <= FIFO_25[18];
        FIFO_26[17] <= FIFO_26[18];
        FIFO_27[17] <= FIFO_27[18];
        FIFO_28[17] <= FIFO_28[18];
        FIFO_29[17] <= FIFO_29[18];
        FIFO_30[17] <= FIFO_30[18];
        FIFO_31[17] <= FIFO_31[18];
    end

    // Level 19 Logic
    always @(posedge CLK) begin
        FIFO_19[18] <= i_Data_I_In[19*`BIT_DATA +: `BIT_DATA];
        FIFO_20[18] <= FIFO_20[19];
        FIFO_21[18] <= FIFO_21[19];
        FIFO_22[18] <= FIFO_22[19];
        FIFO_23[18] <= FIFO_23[19];
        FIFO_24[18] <= FIFO_24[19];
        FIFO_25[18] <= FIFO_25[19];
        FIFO_26[18] <= FIFO_26[19];
        FIFO_27[18] <= FIFO_27[19];
        FIFO_28[18] <= FIFO_28[19];
        FIFO_29[18] <= FIFO_29[19];
        FIFO_30[18] <= FIFO_30[19];
        FIFO_31[18] <= FIFO_31[19];
    end

    // Level 20 Logic
    always @(posedge CLK) begin
        FIFO_20[19] <= i_Data_I_In[20*`BIT_DATA +: `BIT_DATA];
        FIFO_21[19] <= FIFO_21[20];
        FIFO_22[19] <= FIFO_22[20];
        FIFO_23[19] <= FIFO_23[20];
        FIFO_24[19] <= FIFO_24[20];
        FIFO_25[19] <= FIFO_25[20];
        FIFO_26[19] <= FIFO_26[20];
        FIFO_27[19] <= FIFO_27[20];
        FIFO_28[19] <= FIFO_28[20];
        FIFO_29[19] <= FIFO_29[20];
        FIFO_30[19] <= FIFO_30[20];
        FIFO_31[19] <= FIFO_31[20];
    end

    // Level 21 Logic
    always @(posedge CLK) begin
        FIFO_21[20] <= i_Data_I_In[21*`BIT_DATA +: `BIT_DATA];
        FIFO_22[20] <= FIFO_22[21];
        FIFO_23[20] <= FIFO_23[21];
        FIFO_24[20] <= FIFO_24[21];
        FIFO_25[20] <= FIFO_25[21];
        FIFO_26[20] <= FIFO_26[21];
        FIFO_27[20] <= FIFO_27[21];
        FIFO_28[20] <= FIFO_28[21];
        FIFO_29[20] <= FIFO_29[21];
        FIFO_30[20] <= FIFO_30[21];
        FIFO_31[20] <= FIFO_31[21];
    end

    // Level 22 Logic
    always @(posedge CLK) begin
        FIFO_22[21] <= i_Data_I_In[22*`BIT_DATA +: `BIT_DATA];
        FIFO_23[21] <= FIFO_23[22];
        FIFO_24[21] <= FIFO_24[22];
        FIFO_25[21] <= FIFO_25[22];
        FIFO_26[21] <= FIFO_26[22];
        FIFO_27[21] <= FIFO_27[22];
        FIFO_28[21] <= FIFO_28[22];
        FIFO_29[21] <= FIFO_29[22];
        FIFO_30[21] <= FIFO_30[22];
        FIFO_31[21] <= FIFO_31[22];
    end

    // Level 23 Logic
    always @(posedge CLK) begin
        FIFO_23[22] <= i_Data_I_In[23*`BIT_DATA +: `BIT_DATA];
        FIFO_24[22] <= FIFO_24[23];
        FIFO_25[22] <= FIFO_25[23];
        FIFO_26[22] <= FIFO_26[23];
        FIFO_27[22] <= FIFO_27[23];
        FIFO_28[22] <= FIFO_28[23];
        FIFO_29[22] <= FIFO_29[23];
        FIFO_30[22] <= FIFO_30[23];
        FIFO_31[22] <= FIFO_31[23];
    end

    // Level 24 Logic
    always @(posedge CLK) begin
        FIFO_24[23] <= i_Data_I_In[24*`BIT_DATA +: `BIT_DATA];
        FIFO_25[23] <= FIFO_25[24];
        FIFO_26[23] <= FIFO_26[24];
        FIFO_27[23] <= FIFO_27[24];
        FIFO_28[23] <= FIFO_28[24];
        FIFO_29[23] <= FIFO_29[24];
        FIFO_30[23] <= FIFO_30[24];
        FIFO_31[23] <= FIFO_31[24];
    end

    // Level 25 Logic
    always @(posedge CLK) begin
        FIFO_25[24] <= i_Data_I_In[25*`BIT_DATA +: `BIT_DATA];
        FIFO_26[24] <= FIFO_26[25];
        FIFO_27[24] <= FIFO_27[25];
        FIFO_28[24] <= FIFO_28[25];
        FIFO_29[24] <= FIFO_29[25];
        FIFO_30[24] <= FIFO_30[25];
        FIFO_31[24] <= FIFO_31[25];
    end

    // Level 26 Logic
    always @(posedge CLK) begin
        FIFO_26[25] <= i_Data_I_In[26*`BIT_DATA +: `BIT_DATA];
        FIFO_27[25] <= FIFO_27[26];
        FIFO_28[25] <= FIFO_28[26];
        FIFO_29[25] <= FIFO_29[26];
        FIFO_30[25] <= FIFO_30[26];
        FIFO_31[25] <= FIFO_31[26];
    end

    // Level 27 Logic
    always @(posedge CLK) begin
        FIFO_27[26] <= i_Data_I_In[27*`BIT_DATA +: `BIT_DATA];
        FIFO_28[26] <= FIFO_28[27];
        FIFO_29[26] <= FIFO_29[27];
        FIFO_30[26] <= FIFO_30[27];
        FIFO_31[26] <= FIFO_31[27];
    end

    // Level 28 Logic
    always @(posedge CLK) begin
        FIFO_28[27] <= i_Data_I_In[28*`BIT_DATA +: `BIT_DATA];
        FIFO_29[27] <= FIFO_29[28];
        FIFO_30[27] <= FIFO_30[28];
        FIFO_31[27] <= FIFO_31[28];
    end

    // Level 29 Logic
    always @(posedge CLK) begin
        FIFO_29[28] <= i_Data_I_In[29*`BIT_DATA +: `BIT_DATA];
        FIFO_30[28] <= FIFO_30[29];
        FIFO_31[28] <= FIFO_31[29];
    end

    // Level 30 Logic
    always @(posedge CLK) begin
        FIFO_30[29] <= i_Data_I_In[30*`BIT_DATA +: `BIT_DATA];
        FIFO_31[29] <= FIFO_31[30];
    end

    // Level 31 Logic
    always @(posedge CLK) begin
        FIFO_31[30] <= i_Data_I_In[31*`BIT_DATA +: `BIT_DATA];
    end

endmodule

