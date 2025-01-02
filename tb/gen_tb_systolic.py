import numpy as np

def generate_random_matrix(rows, cols, bit_width=8):
    """Generates a matrix with random signed integers within 8-bit range."""
    return np.random.randint(-2**(bit_width-1), 2**(bit_width-1), size=(rows, cols), dtype=np.int8)

def matmul_and_psum(input_matrix, weight_matrix):
    """Computes matrix multiplication and returns the result for psum verification."""
    return np.matmul(input_matrix, weight_matrix)

def generate_verilog_tb(input_matrix, weight_matrix, psum_matrix):
    rows_in, cols_in = input_matrix.shape
    rows_w, cols_w = weight_matrix.shape
    
    tb_code = "`timescale 1ns / 1ps\n`include \"./param.v\"\n\nmodule tb_generated;\n\n"
    tb_code += "reg CLK, RSTb;\n"
    tb_code += f"wire [`BIT_INSTR-1:0] i_Instr_In;\n"
    tb_code += f"wire [`BIT_PSUM-1:0] o_Data;\n"
    tb_code += f"wire o_Flag_Finish, o_Valid;\n\n"

    tb_code += "top top (\n"
    tb_code += "    .CLK(CLK), .RSTb(RSTb),\n"
    tb_code += "    .i_Instr_In(i_Instr_In),\n"
    tb_code += "    .o_Flag_Finish_Out(o_Flag_Finish),\n"
    tb_code += "    .o_Valid_WB_Out(o_Valid),\n"
    tb_code += "    .o_Data_WB_Out(o_Data)\n"
    tb_code += ");\n\n"

    tb_code += "always #20 CLK = ~CLK;\n\n"
    tb_code += "initial begin\n    CLK = 0; RSTb = 1;\n"
    tb_code += "    repeat(1) @(negedge CLK); RSTb = 0;\n"
    tb_code += "    repeat(5) @(negedge CLK); RSTb = 1;\n"
    tb_code += "    repeat(1000) @(negedge CLK);\n    $finish;\nend\n\n"

    tb_code += "// Instruction Buffer Initialization\n"
    tb_code += "initial begin\n"
    instr_num = 0

    # Generate ISA instructions for input data loading
    for i, value in enumerate(input_matrix.flatten()):
        tb_code += f"    Instr[{instr_num}] <= {{`OPVALID, `OPCODE_LDSRAM, {i}, {value}}};\n"
        instr_num += 1

    # Generate ISA instructions for weight data loading
    for j, value in enumerate(weight_matrix.flatten()):
        tb_code += f"    Instr[{instr_num}] <= {{`OPVALID, `OPCODE_LDSRAM, {j}, {value}}};\n"
        instr_num += 1

    # Execute and Writeback ISA instructions
    tb_code += f"    Instr[{instr_num}] <= {{`OPVALID, `OPCODE_EX, 20'd0, 8'd0}};\n"
    instr_num += 1
    tb_code += f"    Instr[{instr_num}] <= {{`OPVALID, `OPCODE_WBPSRAM, 6'd0, 14'd0, 8'd0}};\n"
    
    tb_code += "end\nendmodule\n"
    
    return tb_code

def main():
    rows_in = int(input("Enter the number of rows for the input matrix: "))
    cols_in = int(input("Enter the number of columns for the input matrix / rows for weight matrix: "))
    cols_w = int(input("Enter the number of columns for the weight matrix: "))

    input_matrix = generate_random_matrix(rows_in, cols_in)
    weight_matrix = generate_random_matrix(cols_in, cols_w)
    psum_matrix = matmul_and_psum(input_matrix, weight_matrix)

    verilog_tb_code = generate_verilog_tb(input_matrix, weight_matrix, psum_matrix)
    
    with open("generated_tb.sv", "w") as file:
        file.write(verilog_tb_code)
    print("Verilog Testbench generated as 'generated_tb.sv'.")

if __name__ == "__main__":
    main()
