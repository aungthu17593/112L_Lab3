`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/07/2018 10:10:33 PM
// Design Name: 
// Module Name: Controller
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

module Controller(
    
    //Input
    input logic [6:0] Opcode, //7-bit opcode field from the instruction
    
    //Outputs
    output logic ALUSrc2,//0: The second ALU operand comes from the second register file output (Read data 2); 
                         //1: The second ALU operand is the sign-extended, lower 16 bits of the instruction.
    output logic MemtoReg, //0: The value fed to the register Write data input comes from the ALU or ImmGen.
                           //1: The value fed to the register Write data input comes from the data memory.
    output logic RegWrite, //The register on the Write register input is written with the value on the Write data input 
    output logic MemRead,  //Data memory contents designated by the address input are put on the Read data output
    output logic MemWrite, //Data memory contents designated by the address input are replaced by the value on the Write data input.
    output logic Branch,   //0: branch is not taken; 1: branch is taken
    output logic ALUSrc1, //0: The first ALU operand comes from the first register file output (Read data 2); 
                          //1: The first ALU operand is the zero-extended PC. 
    output logic Jump,    //0: If not jump instruction.
                          //1: If jump instruction.
    output logic [1:0] ALUOp
);

//    localparam R_TYPE = 7'b0110011;
//    localparam LW     = 7'b0000011;
//    localparam SW     = 7'b0100011;
//    localparam BR     = 7'b1100011;
//    localparam RTypeI = 7'b0010011; //addi,ori,andi
    
    logic [6:0] R_TYPE, LW, SW, RTypeI, BR, LUI, AUIPC, JAL, JALR;
    
    assign  R_TYPE = 7'b0110011; //sll,slt,sltu,srl,sra;
    assign  RTypeI = 7'b0010011; //addi,ori,andi; sllti,sltiu; slli,srli,srai; 
    assign  LW     = 7'b0000011;
    assign  SW     = 7'b0100011;
  	assign  BR     = 7'b1100011; //beq,bne,blt,bge,bltu,bgeu;
    assign  LUI    = 7'b0110111;
    assign  AUIPC  = 7'b0010111;
    assign  JAL    = 7'b1101111;
    assign  JALR   = 7'b1100111;

  assign ALUSrc1  = (Opcode==JAL || Opcode==AUIPC);
  assign ALUSrc2  = (Opcode==LW || Opcode==SW || Opcode==RTypeI || Opcode==LUI || Opcode==AUIPC || Opcode==JAL || Opcode==JALR);
  assign MemtoReg = (Opcode==LW);
  assign RegWrite = (Opcode==R_TYPE || Opcode == RTypeI || Opcode==LW || Opcode==JAL || Opcode==JALR);
  assign MemRead  = (Opcode==LW);
  assign MemWrite = (Opcode==SW);
  assign Branch   = (Opcode==BR);
  assign Jump     = (Opcode==JAL || Opcode==JALR);
  assign ALUOp[0] = (Opcode==BR || Opcode==JAL || Opcode==JALR || Opcode==LUI || Opcode==AUIPC);
  assign ALUOp[1] = (Opcode==RTypeI || Opcode==R_TYPE || Opcode==JAL || Opcode==JALR || Opcode==LUI || Opcode==AUIPC);

endmodule
