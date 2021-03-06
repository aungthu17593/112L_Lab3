`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/07/2018 10:10:33 PM
// Design Name: 
// Module Name: ALUController
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ALUController(
    
    //Inputs
    input logic [1:0] ALUOp,  //7-bit opcode field from the instruction
    input logic [6:0] Funct7, // bits 25 to 31 of the instruction
    input logic [2:0] Funct3, // bits 12 to 14 of the instruction
    
    //Output
    output logic [3:0] Operation //operation selection for ALU
);
 
 assign Operation[0] = (ALUOp==2'b10 && (Funct3==3'b110 || Funct3==3'b100 || Funct3==3'b001)) || // OR & ORI, XOR & XORI, SLLI & SLL
                       (ALUOp==2'b10 && Funct3==3'b011) || // SLTIU & SLTU
                       (ALUOp==2'b10 && Funct3==3'b101 && Funct7==7'b0100000) || // SRAI & SRA
                       (ALUOp==2'b01 && (Funct3==3'b001 || Funct3==3'b101 || Funct3==3'b111)); // BNE, BGE, BGEU

 assign Operation[1] = (ALUOp==2'b10 && (Funct3==3'b000 || Funct3==3'b100 || Funct3==3'b001)) || // ADD & ADDI & SUB, XOR & XORI, SLLI & SLL
                       (ALUOp==2'b00) || // Load and save
                       (ALUOp==2'b01 && (Funct3==3'b000 || Funct3==3'b001 || Funct3==3'b110 || Funct3==3'b111)) || // BEQ, BNE, BLTU, BGEU
                       (ALUOp==2'b11); // JAL, JALR, LUI, AUIPC

 assign Operation[2] = (ALUOp==2'b10 && Funct3==3'b000 && Funct7==7'b0100000) || // SUB
                       (ALUOp==2'b10 && (Funct3==3'b010 || Funct3==3'b011 || Funct3==3'b001)) || // SLTI & SLT, SLTIU & SLTU, SLLI & SLL
                       (ALUOp==2'b01 && (Funct3==3'b100 || Funct3==3'b101 || Funct3==3'b110 || Funct3==3'b111)); // BLT, BGE, BLTU, BGEU
 
 assign Operation[3] = (ALUOp==2'b10 && Funct3==3'b101) || //SRLI & SRL, SRAI & SRA
                       (ALUOp==2'b01); // Branch
endmodule
