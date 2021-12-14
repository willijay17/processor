
// Jaylon Williams
// HDL 4321 Fall 2021
// HDL Final Project Top Module
// *Disclaimer*
// Due to timing issues with my execution module databus I decided to cheat a little
// and pass the opcode as a 
// Main memory MUST be allocated in the mainmemory module as per teh next line.
//  logic [255:0]MainMemory[12]; // this is the physical memory
//
module top ();

logic [255:0] InstructDataOut;
logic [255:0] MemDataOut;
logic [255:0] ExeDataOut;
logic [255:0] IntDataOut;
logic [255:0] MatrixDataOut;
logic nRead,nWrite,nReset,Clk;
logic [15:0] address;
logic [7:0] opcode;


InstructionMemory  U1(Clk,InstructDataOut, address, nRead,nReset);

MainMemory  U2(Clk,MemDataOut,ExeDataOut, address, nRead,nWrite, nReset);

Execution  U3(Clk,InstructDataOut,MemDataOut,MatrixDataOut,IntDataOut,ExeDataOut, address, opcode, nRead,nWrite, nReset);

MatrixAlu  U4(Clk,MatrixDataOut,ExeDataOut, address, opcode, nRead, nWrite, nReset);

IntegerAlu  U5(Clk,IntDataOut,ExeDataOut, address, opcode, nRead,nWrite, nReset);

TestMatrix  UTest(Clk,nReset);



endmodule


	
	

