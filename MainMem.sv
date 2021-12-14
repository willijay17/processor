//////////////////////////////////////////////////////
// Jaylon Williams
// Memory Module Code referenced from Mark Welker
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

module MainMemory(Clk, MemDataOut, ExeDataOut, address, nRead,nWrite, nReset);


input logic [255:0] ExeDataOut; // Data bus from Execution Module Output
input logic nRead,nWrite, nReset, Clk;
input logic [15:0] address;
output logic [255:0] MemDataOut; // Data bus to the Execution Engine 

logic [255:0]MainMemory[9]; // this is the physical memory

always @(negedge nReset)
begin
	MainMemory[0] = 256'h0004_0004_000c_0022_0007_0006_000b_0009_0009_0002_0008_000d_0002_000f_0010_0005;
	MainMemory[1] = 256'h0017_002d_0043_0016_0004_0006_0007_0001_0012_0038_000d_000c_0009_0005_0007_0002;
	MainMemory[2] = 256'h0;
	MainMemory[3] = 256'h0;
	MainMemory[4] = 256'h0;
	MainMemory[5] = 256'h0;
	MainMemory[6] = 256'h0;
	MainMemory[7] = 256'h0;
	MainMemory[8] = 256'h0;
	MemDataOut = 0;
end

always @(posedge Clk)
begin
if(address[15:12] == MainMemEn) // talking to Main memory
	begin
		if (~nRead)
			MemDataOut <= MainMemory[address[11:0]]; // data will remain on dataout until it is changed.
			
		if(~nWrite)
		   MainMemory[address[11:0]] = ExeDataOut;
	end
end	

endmodule


