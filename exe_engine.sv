//Jaylon Williams
//Execution engine gets instructions from Instruction Memory
//8 instructions at a time
//Code modeled from code created by Mark Welker
// 
// Address is big enough to hold decode
// Each module must decode address to know when it is in use
// address bits [11:0] are for actual address location

//Parameters to tell which module execution engine is talking to
parameter MainMemEn    = 0;
parameter InstrMemEn   = 1;
parameter MatrixAluEn  = 2;
parameter IntegerAluEn = 3;
parameter ExecuteEn    = 4;

//Parameters to tell module what operation it is doing
parameter STOP 	    	= 8'hFF;  
parameter MMult			= 8'h00;  
parameter MAdd 			= 8'h01;  
parameter MSub			= 8'h02;  
parameter MTranspose    = 8'h03;  
parameter MScale	 	= 8'h04;  
parameter MScaleImm 	= 8'h05;  
parameter IntAdd 		= 8'h10;  
parameter IntSub 		= 8'h11;  
parameter IntMult 		= 8'h12;  
parameter IntDiv 		= 8'h13;  



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


module Execution(Clk,InstructDataOut,MemDataOut,MatrixDataOut, IntDataOut, ExeDataOut, address, opcode, nRead,nWrite, nReset);

	input logic Clk, nReset; 
	input logic [255:0]MatrixDataOut;
	input logic [255:0]InstructDataOut;
	input logic [255:0]MemDataOut;
	input logic [255:0]IntDataOut;
	output logic [255:0]ExeDataOut;
	output logic [15:0]address;
	output logic [7:0]opcode;
	output logic nRead, nWrite;
	
	//creating registers to store instructions from instruct data out
	logic [31:0]Instructions[7:0];
	logic [7:0]destination, source1Address, source2Address; // all 8 bit registers
	logic [31:0]CurrentInstruction;
	logic [3:0]counter, InstrCounter;
	logic [255:0]sourceData1; //register stores source1 data
	logic [255:0]sourceData2; //register stores source2 data
	
	enum {retrieve_instruct, seperate_instruct_Data,read_instruct_Data,decode_instruct, retrieve_data, load_data, load_data_2, load_result, Finish_Move}Next_State, Current_State;
	
	always @ (negedge nReset)
		begin
			counter = 0; 
			InstrCounter = 0;
			Current_State = retrieve_instruct;
			address[15:12] = InstrMemEn;
			address[11:0] = counter;
			nRead = 0;
			nWrite = 1;
		end	
		
	always @ (posedge Clk)
	begin 
		begin
		if (nReset)
		begin
		case (Current_State)
			retrieve_instruct : begin //Retreives instructions in sets of 8 at a time
				nRead = 0;
				address[15:12] = InstrMemEn;
				address[11:0] = counter;
				Next_State = seperate_instruct_Data;
			end
			
			seperate_instruct_Data : begin //seperates 8 instructions into single instructions
				Instructions[0] = InstructDataOut[31:0];
				Instructions[1] = InstructDataOut[63:32];
				Instructions[2] = InstructDataOut[95:64];
				Instructions[3] = InstructDataOut[127:96];
				Instructions[4] = InstructDataOut[159:128];
				Instructions[5] = InstructDataOut[191:160];
				Instructions[6] = InstructDataOut[223:192];
				Instructions[7] = InstructDataOut[255:224];
				Next_State = read_instruct_Data;
			end
			
			read_instruct_Data : begin	//navigates through and keeps track of each instruction	
				if (InstrCounter < 8)
				begin
					nRead = 0;
					CurrentInstruction = Instructions[InstrCounter];
					opcode = CurrentInstruction[31:24];
					destination = CurrentInstruction[23:16];
					source1Address = CurrentInstruction[15:8];
					source2Address = CurrentInstruction[7:0];
					Next_State = decode_instruct;
				end
				else
				begin
					InstrCounter = 0;
					counter++;
					Next_State = retrieve_instruct;
				end
			end
			
			decode_instruct : begin
			
				if(opcode == STOP) 
				begin			//If opcode is 8'hFF, program stops
					$stop;
				end

				else
				begin
					address[15:12] = MainMemEn;
					address[11:0] = source1Address;
				end
				
				Next_State = retrieve_data;
				
			end			
			
			retrieve_data : begin //retrieve source1 and put it on a register and hold source 2 info to do matrix math with
				
				sourceData1 = MemDataOut;
				address[11:0] = source2Address;
				Next_State = load_data;
				
			end
				
			load_data : begin
			
				sourceData2 = MemDataOut;
				
				if(opcode == 8'h00 || opcode == 8'h01 || opcode == 8'h02 || opcode == 8'h03 || opcode == 8'h04 || opcode == 8'h05) 
				begin
					ExeDataOut = sourceData1;
					Next_State = load_data_2;
				end				

	
				else 
				begin
					ExeDataOut[63:0] = sourceData1[63:0];
					Next_State = load_data_2;
				end
			end														
			
			load_data_2	: begin //
				
				if(opcode == 8'h00 || opcode == 8'h01 || opcode == 8'h02 || opcode == 8'h03 || opcode == 8'h04 || opcode == 8'h05) 
				begin
					if (opcode == 8'h05)
					begin
					
						ExeDataOut[7:0] = source2Address;
						address[15:12] = MatrixAluEn;
						nRead = 1;
						nWrite = 0;
						Next_State = load_result;
					end
					
					else
					begin
						ExeDataOut = sourceData2;
						address[15:12] = MatrixAluEn;
						nRead = 1;
						nWrite = 0;
						Next_State = load_result;
					end
				end				

	
				else 
				begin
					ExeDataOut[127:64] = sourceData2[63:0];
					nRead = 1;
					nWrite = 0;
					Next_State = load_result;
				end
				
			end
			
			load_result : begin //takes output from ALU and stores it in Main Mem location
				
				if(opcode == 8'h00 || opcode == 8'h01 || opcode == 8'h02 || opcode == 8'h03 || opcode == 8'h04 || opcode == 8'h05) 
				begin
					ExeDataOut = MatrixDataOut;
					address[15:12] = MainMemEn;
					address[11:0] = destination;
					Next_State = Finish_Move;
				end				

				else 
				begin
					ExeDataOut[63:0] = IntDataOut[63:0];
					address[15:12] = MainMemEn;
					address[11:0] = destination;
					Next_State = Finish_Move;
				end
				
				Next_State = Finish_Move;
			end
			
			Finish_Move : begin //reset state machine
				ExeDataOut = MatrixDataOut;
				nRead = 1; 
				nWrite = 1;
				address = 0; 
				ExeDataOut = 0;
				InstrCounter++;
				Next_State = read_instruct_Data;
			end
		endcase
		Current_State = Next_State;
	end
	
	end
	
	end
	
	endmodule
