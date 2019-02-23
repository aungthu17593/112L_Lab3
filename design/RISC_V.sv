`timescale 1ns / 1ps

module riscv #(
    parameter DATA_W = 32)
    (input logic clk, reset, // clock and reset signals
    output logic [31:0] WB_Data// The ALU_Result
    );

logic [6:0] opcode;
logic ALUSrc2, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUSrc1, Jump;

logic [1:0] ALUop;
logic [6:0] Funct7;
logic [2:0] Funct3;
logic [3:0] Operation;

    Controller c(opcode, ALUSrc2, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUSrc1, Jump, ALUop);
    
    ALUController ac(ALUop, Funct7, Funct3, Operation);

    Datapath dp(clk, reset, RegWrite , MemtoReg, ALUSrc2, MemWrite, MemRead, Branch, ALUSrc1, Jump, Operation, opcode, Funct7, Funct3, WB_Data);
        
endmodule
