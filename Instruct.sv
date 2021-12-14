//////////////////////////////////////////////////////
// Jaylon Williams
// Instruction Module Code referenced from Mark Welker
// Fall 2021
//
//
//////////////////////////////////////////////////////

//Parameters to tell which module execution engine is talking to
parameter MainMemEn    = 0;
parameter InstrMemEn   = 1;
parameter MatrixAluEn  = 2;
parameter IntegerAluEn = 3;
parameter ExecuteEn    = 4;


//////////////////////////////
//Moved stop to third instruction for this example
/////////////////////////////////////////////////
// instruction: OPcode :: dest :: src1 :: src2 Each section is 8 bits.
//Stop::FFh::00::00::00
//MMult::00h::Reg/mem::Reg/mem::Reg/mem
//Madd::01h::Reg/mem::Reg/mem::Reg/mem
//Msub::02h::Reg/mem::Reg/mem::Reg/mem
//Mtranspose::03h::Reg/mem::Reg/mem::Reg/mem
//MScale::04h::Reg/mem::Reg/mem::Reg/mem
//MScaleImm::05h:Reg/mem::Reg/mem::Immediate
//IntAdd::10h::Reg/mem::Reg/mem::Reg/mem
//IntSub::11h::Reg/mem::Reg/mem::Reg/mem
//IntMult::12h::Reg/mem::Reg/mem::Reg/mem
//IntDiv::13h::Reg/mem::Reg/mem::Reg/mem

//Instructions being set for instruct module
// add the data at location 0 to the data at location 1 and place result in location 2
parameter Instruct1 = 32'h 01_02_00_01; // add first matrix to second matrix store in memory
parameter Instruct2 = 32'h 10_10_09_08; // add 16 bit numbers in location 8 to 9 store in temp register
parameter Instruct3 = 32'h 02_03_02_00; //Subtract the first matrix from the result in step 1 and store the result somewhere else in memory. 
parameter Instruct4 = 32'h 03_04_02_00;//Transpose the result from step 1 store in memory
parameter Instruct5 = 32'h 04_05_03_10;//Scale the result in step 3 by the result from step 2 store in a matrix register
parameter Instruct6 = 32'h 00_06_04_03; //Multiply the result from step 4 by the result in step 3, store in memory.

parameter Instruct7 = 32'h 12_0a_01_00;//Multiply the integer value in memory location 0 to location 1. Store it in memory location 0x0A
parameter Instruct8 = 32'h 11_11_0a_01;//Subtract the integer value in memory location 01 from memory location 0x0A and store it in a register
parameter Instruct9 = 32'h 13_0b_0a_11;//Divide Memory location 0x0A by the register in step 8 and store it in location 0x0B
parameter Instruct10 = 32'h FF_00_00_00; // stop


module InstructionMemory(Clk, InstructDataOut, address, nRead,nReset);
// NOTE the lack of datain and write. This is because this is a ROM model

input logic nRead, nReset, Clk;
input logic [15:0] address;

output logic [255:0] InstructDataOut; // Sends 8 32 bit instructions at a time

  logic [255:0]InstructMemory[1:0]; // this is the physical memory

// This memory is designed to be driven into a data multiplexor. 

always @(posedge Clk)
begin
  if(address[15:12] == InstrMemEn) // talking to Instruction IntstrMemEn
	begin
		if(~nRead)
			InstructDataOut = InstructMemory[address[11:0]]; // data will reamin on dataout until it is changed.
	end
end // from negedge nRead	

always @(negedge nReset)
begin

	InstructDataOut = 0;
//	set in the default instructions 
	InstructMemory[0] = {Instruct1,Instruct2,Instruct3,Instruct4,Instruct5,Instruct6,Instruct7,Instruct8};  	
	InstructMemory[1] = {Instruct10,Instruct9};	 
	

	
end 

endmodule


