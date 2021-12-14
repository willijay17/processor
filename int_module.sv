//////////////////////////////////////////////////////
// Jaylon Williams
// Int Module Code
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

//Parameters to tell module what operation it is doing
parameter IntAlu     = 5;
parameter IntAdd 	 = 8'h10;  
parameter IntSub 	 = 8'h11;  
parameter IntMult	 = 8'h12;  
parameter IntDiv 	 = 8'h13;  

module IntegerAlu(Clk, IntDataOut, ExeDataOut, address, opcode, nRead, nWrite, nReset);

input logic Clk, nRead, nWrite, nReset;
input logic [15:0]address;
input logic [7:0]opcode;
input logic [255:0] ExeDataOut;
output logic [255:0] IntDataOut;

logic [63:0] Int1;
logic [63:0] Int2;


always @ (posedge Clk or negedge nReset) //initialize variables at reset
begin
	if (~nReset)
	begin
			IntDataOut = 0;
			Int1 = 0;
			Int2 = 0;
	end
end


always @ (posedge Clk)
begin
		if (address[15:12] == IntAlu) 
		begin
			if (~nWrite) //during nWrite set registers to correct values
			begin
				Int1 = ExeDataOut[63:0];
				Int2 = ExeDataOut[127:64];
			end
			
			if (~nRead) //at nRead low, perform integer operation and then reset registers to 0
			begin
				if (opcode == IntAdd)
				begin
					IntDataOut[63:0] = Int1 + Int2;
					Int1 = 0;
					Int2 = 0;
				end
	
				else if (opcode == IntSub)
				begin
					IntDataOut[63:0] = Int1 - Int2;
					Int1 = 0;
					Int2 = 0;
				end
	
				else if (opcode == IntMult)
				begin
					IntDataOut[63:0] = Int1 * Int2;
					Int1 = 0;
					Int2 = 0;
				end
	
				else if (opcode == IntDiv)
				begin
					IntDataOut[63:0] = Int1 / Int2;
					Int1 = 0;
					Int2 = 0;
				end
			end
		end
end
endmodule

	