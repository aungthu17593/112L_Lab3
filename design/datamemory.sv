`timescale 1ns / 1ps

module datamemory#(
    parameter DM_ADDRESS = 9 ,
    parameter DATA_W = 32
    )(
    input logic clk,
	input logic MemRead , // comes from control unit
    input logic MemWrite , // Comes from control unit
    input logic [2:0]Funct3, // funct3 from instruction
    input logic [DM_ADDRESS -1:0] a , // Read / Write address - 9 LSB bits of the ALU output
    input logic [DATA_W-1:0] wd , // Write Data
    output logic [DATA_W-1:0] rd // Read Data
    );
    
    `ifdef __SIM__
        logic [3:0] [DATA_W/4-1:0] mem [(2**DM_ADDRESS)-1:0];
        
        always_comb 
        begin
            if(MemRead) begin
                case(Funct3) 
                    3'b000:
                        rd = {mem[a][0][3] ? 28'b1 : 28'b0 , mem[a][0]};
                    3'b001:
                        rd = {mem[a][3][3] ? 16'b1 : 16'b0 , mem[a][3:0]};
                    3'b010:
                        rd = mem[a];
                    3'b100:
                        rd = {28'b0 , mem[a][0]};
                    3'b101:
                        rd = {16'b0 , mem[a][3:0]};
                    default:    
                        rd = 'b0;
                endcase
            end
        end
        
        always @(posedge clk) begin
            if (MemWrite) begin
                case(Funct3) 
                    3'b000:
                        mem[a][0] = wd[3:0];
                    3'b001:
                        mem[a][3:0] = wd[15:0];
                    3'b010:
                        mem[a] = wd;
                    default:
                        mem[a] = mem[a];
                endcase
            end
        end
    
    `else
        logic we;
        assign we = MemWrite;
    
        SRAM1RW512x32 RAM (
            .A       ( a[8:0] ),
            .CE      ( 1'b1   ),
            .WEB     ( ~we    ),
            .OEB     ( we     ),
            .CSB     ( 1'b0   ),
            .I       ( wd     ),
            .O       ( rd     )
            );

    `endif

endmodule

