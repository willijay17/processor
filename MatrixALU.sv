//////////////////////////////////////////////////////
// Jaylon Williams
// Matrix Module Code
// Fall 2021
// case statements for matrix operations referenced from the internet
// but code structure and setup is original.
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
parameter MMult 	 = 8'h00;
parameter Madd 		 = 8'h01;
parameter Msub 		 = 8'h02;
parameter Mtranspose = 8'h03;
parameter MScale 	 = 8'h04;
parameter MScaleImm  = 8'h05;

module MatrixAlu(Clk,MatrixDataOut,ExeDataOut, address, opcode, nRead, nWrite, nReset);
    input logic nRead, nWrite, nReset, Clk;
    input logic [255:0] ExeDataOut;
    input logic [15:0] address;
	input logic [7:0] opcode;
    output logic [255:0] MatrixDataOut;

    logic [255:0] result;
    logic [255:0] source1;    
    logic [255:0] source2;    

    always @ (negedge nReset) begin
        MatrixDataOut = 0;
		result = 0;
        source1 = 0;
        source2 = 0;

    end


    always @ (posedge Clk) begin
       
		if(address[15:12] == MatrixAluEn) 
		begin
			if(~nWrite) begin
                if(source1 == 0) 
					source1 = ExeDataOut;

                else
                source2 = ExeDataOut;   

 
            end

			if(~nRead) 
			begin
		
			case(opcode)

					MMult: begin
                        /* Dot Product of the matrices
                        --     --         --     --         --                                                     --
                        | 1 2 3 |         | A B C |         | (1*A)+(2*D)+(3*G) (1*B)+(2*E)+(3*F) (1*C)+(2*F)+(3*I) |
                        | 4 5 6 |    *    | D E F |    =    | (4*A)+(5*D)+(6*G) (4*B)+(5*E)+(6*F) (4*C)+(5*F)+(6*I) |
                        | 7 8 9 |         | G H I |         | (7*A)+(8*D)+(9*G) (7*B)+(8*E)+(9*F) (7*C)+(8*F)+(9*I) |
                        --     --         --     --         --                                                     --
                        */

                        //Row 1
                        result [15:0]    = source1[15:0] * source2 [15:0]   +  source1[31:16] * source2 [79:64]    +  source1[47:32] * source2 [143:128]  +   source1[63:48] * source2[207:192];
                        result [31:16]   = source1[15:0] * source2 [31:16]  +  source1[31:16] * source2 [95:80]    +  source1[47:32] * source2 [159:144]  +   source1[63:48] * source2[223:208];
                        result [47:32]   = source1[15:0] * source2 [47:32]  +  source1[31:16] * source2 [111:96]   +  source1[47:32] * source2 [175:160]  +   source1[63:48] * source2[239:224];
                        result [63:48]   = source1[15:0] * source2 [63:48]  +  source1[31:16] * source2 [127:112]  +  source1[47:32] * source2 [191:176]  +   source1[63:48] * source2[255:240];
						
                        //Row 2           
                        result [79:64]   = source1[79:64] * source2 [15:0]   +  source1[95:80] * source2 [79:64]    +  source1[111:96] * source2 [143:128]  +  source1[127:112] * source2[207:192];
                        result [95:80]   = source1[79:64] * source2 [31:16]  +  source1[95:80] * source2 [95:80]    +  source1[111:96] * source2 [159:144]  +  source1[127:112] * source2[223:208];
                        result [111:96]  = source1[79:64] * source2 [47:32]  +  source1[95:80] * source2 [111:96]   +  source1[111:96] * source2 [175:160]  +  source1[127:112] * source2[239:224];
                        result [127:112] = source1[79:64] * source2 [63:48]  +  source1[95:80] * source2 [127:112]  +  source1[111:96] * source2 [191:176]  +  source1[127:112] * source2[255:240];
									
                        //Row 3          
                        result [143:128] = source1[143:128] * source2 [15:0]   +  source1[159:144] * source2 [79:64]    +  source1[175:160] * source2[143:128]  +  source1[191:176] * source2[207:192];
                        result [159:144] = source1[143:128] * source2 [31:16]  +  source1[159:144] * source2 [95:80]    +  source1[175:160] * source2[159:144]  +  source1[191:176] * source2[223:208];
                        result [175:160] = source1[143:128] * source2 [47:32]  +  source1[159:144] * source2 [111:96]   +  source1[175:160] * source2[175:160]  +  source1[191:176] * source2[239:224];
                        result [191:176] = source1[143:128] * source2 [63:48]  +  source1[159:144] * source2 [127:112]  +  source1[175:160] * source2[191:176]  +  source1[191:176] * source2[255:240];
																																							  
                        //Row 4                                                                                                                                            
                        result [207:192] = source1[207:192] * source2 [15:0]   +  source1[223:208] * source2 [79:64]    +  source1[239:224] * source2[143:128]  +  source1[255:240] * source2[207:192];
                        result [223:208] = source1[207:192] * source2 [31:16]  +  source1[223:208] * source2 [95:80]    +  source1[239:224] * source2[159:144]  +  source1[255:240] * source2[223:208];
                        result [239:224] = source1[207:192] * source2 [47:32]  +  source1[223:208] * source2 [111:96]   +  source1[239:224] * source2[175:160]  +  source1[255:240] * source2[239:224];
                        result [255:240] = source1[207:192] * source2 [63:48]  +  source1[223:208] * source2 [127:112]  +  source1[239:224] * source2[191:176]  +  source1[255:240] * source2[255:240];
                    
                        MatrixDataOut = result;
		                result = 0;
                        source1 = 0;
                        source2 = 0;

                    end

                    Madd: begin
                        //Destination = SRC1 + SRC2

                        /*
                        --     --         --     --         --           --
                        | 1 2 3 |         | A B C |         | 1+A 2+B 3+C |
                        | 4 5 6 |    +    | D E F |    =    | 4+D 5+E 6+F | 
                        | 7 8 9 |         | G H I |         | 7+G 8+H 9+I |
                        --     --         --     --         --           --
                        */
                        
                        //Row 1
                        result [15:0]  = source1[15:0]  + source2 [15:0];
                        result [31:16] = source1[31:16] + source2 [31:16];
                        result [47:32] = source1[47:32] + source2 [47:32];
                        result [63:48] = source1[63:48] + source2 [63:48];

                        //Row 2
                        result [79:64]   = source1[79:64]   + source2[79:64];
                        result [95:80]   = source1[95:80]   + source2[95:80];
                        result [111:96]  = source1[111:96]  + source2[111:96];
                        result [127:112] = source1[127:112] + source2[127:112];

                        //Row 3
                        result [143:128] = source1[143:128] + source2[143:128];
                        result [159:144] = source1[159:144] + source2[159:144];
                        result [175:160] = source1[175:160] + source2[175:160];
                        result [191:176] = source1[191:176] + source2[191:176];

                        //Row 4
                        result [207:192] = source1[207:192] + source2[207:192];
                        result [223:208] = source1[223:208] + source2[223:208];
                        result [239:224] = source1[239:224] + source2[239:224];
                        result [255:240] = source1[255:240] + source2[255:240];

                        MatrixDataOut = result;
		                result = 0;
                        source1 = 0;
                        source2 = 0;
                        
                        
                    end
                     
                    Msub: begin
                        //Destination = SRC1 - SRC2

                        /*
                        --     --         --     --         --           --
                        | 1 2 3 |         | A B C |         | 1-A 2-B 3-C |
                        | 4 5 6 |    -    | D E F |    =    | 4-D 5-E 6-F | 
                        | 7 8 9 |         | G H I |         | 7-G 8-H 9-I |
                        --     --         --     --         --           --
                        */ 

                        //Row 1
                        result [15:0]     =   source1[15:0]    -  source2 [15:0];
                        result [31:16]    =   source1[31:16]   -  source2 [31:16];
                        result [47:32]    =   source1[47:32]   -  source2 [47:32];
                        result [63:48]    =   source1[63:48]   -  source2 [63:48];
																  
                        //Row 2                                  
                        result [79:64]    =  source1[79:64]    -  source2 [79:64];
                        result [95:80]    =  source1[95:80]    -  source2 [95:80];
                        result [111:96]   =  source1[111:96]   -  source2 [111:96];
                        result [127:112]  =  source1[127:112]  -  source2 [127:112];
																  
                        //Row 3                                  
                        result [143:128]  =  source1[143:128]  -  source2 [143:128];
                        result [159:144]  =  source1[159:144]  -  source2 [159:144];
                        result [175:160]  =  source1[175:160]  -  source2 [175:160];
                        result [191:176]  =  source1[191:176]  -  source2 [191:176];
																 
                        //Row 4                                 
                        result [207:192]  =  source1[207:192]  -  source2 [207:192];
                        result [223:208]  =  source1[223:208]  -  source2 [223:208];
                        result [239:224]  =  source1[239:224]  -  source2 [239:224];
                        result [255:240]  =  source1[255:240]  -  source2 [255:240];
                        
                        MatrixDataOut = result;
		                result = 0;
                        source1 = 0;
                        source2 = 0;
                    end

                    Mtranspose: begin
                        /* Transposing the matrix
                        --     --             --     --
                        | 1 2 3 |             | 1 4 7 |
                        | 4 5 6 |     -->     | 2 5 8 |
                        | 7 8 9 |             | 3 6 9 |
                        --     --             --     --
                        */

                        //Row 1
                        result [15:0]    = source1[15:0];
                        result [31:16]   = source1[79:64];
                        result [47:32]   = source1[143:128];
                        result [63:48]   = source1[207:192];
										 
                        //Row 2            
                        result [79:64]   = source1[31:16];
                        result [95:80]   = source1[95:80];
                        result [111:96]  = source1[159:144];
                        result [127:112] = source1[223:208];
										
                        //Row 3          
                        result [143:128] = source1[47:32];
                        result [159:144] = source1[111:96];
                        result [175:160] = source1[175:160];
                        result [191:176] = source1[239:224];
										
                        //Row 4         
                        result [207:192] = source1[63:48];
                        result [223:208] = source1[127:112];
                        result [239:224] = source1[191:176];
                        result [255:240] = source1[255:240];

                        MatrixDataOut = result;
		                result = 0;
                        source1 = 0;
                        source2 = 0;

                    end
        

                    MScale: begin
                        result [15:0]  = source1[15:0]  * source2; //[15:0];
                        result [31:16] = source1[31:16] * source2; //[31:16];
                        result [47:32] = source1[47:32] * source2; //[47:32];
                        result [63:48] = source1[63:48] * source2; //[63:48];

                        //Row 2
                        result [79:64]   = source1[79:64]   * source2; //[79:64];
                        result [95:80]   = source1[95:80]   * source2; //[95:80];
                        result [111:96]  = source1[111:96]  * source2; //[111:96];
                        result [127:112] = source1[127:112] * source2; //[127:112];
															
                        //Row 3                              
                        result [143:128] = source1[143:128] * source2; //[143:128];
                        result [159:144] = source1[159:144] * source2; //[159:144];
                        result [175:160] = source1[175:160] * source2; //[175:160];
                        result [191:176] = source1[191:176] * source2; //[191:176];
															
                        //Row 4                           
                        result [207:192] = source1[207:192] * source2; //[207:192];
                        result [223:208] = source1[223:208] * source2; //[223:208];
                        result [239:224] = source1[239:224] * source2; //[239:224];
                        result [255:240] = source1[255:240] * source2; //[255:240];

                        MatrixDataOut = result;
		                result = 0;
                        source1 = 0;
                        source2 = 0;
                        opcode = 0;

                        
                        
                    end
                     
                    MScaleImm: begin
                        result [15:0]  = source1[15:0]  * source2; //[15:0];
                        result [31:16] = source1[31:16] * source2; //[31:16];
                        result [47:32] = source1[47:32] * source2; //[47:32];
                        result [63:48] = source1[63:48] * source2; //[63:48];

                        //Row 2
                        result [79:64]   = source1[79:64]   * source2; //[79:64];
                        result [95:80]   = source1[95:80]   * source2; //[95:80];
                        result [111:96]  = source1[111:96]  * source2; //[111:96];
                        result [127:112] = source1[127:112] * source2; //[127:112];
										   
                        //Row 3            
                        result [143:128] = source1[143:128] * source2; //[143:128];
                        result [159:144] = source1[159:144] * source2; //[159:144];
                        result [175:160] = source1[175:160] * source2; //[175:160];
                        result [191:176] = source1[191:176] * source2; //[191:176];
															
                        //Row 4                              
                        result [207:192] = source1[207:192] * source2; //[207:192];
                        result [223:208] = source1[223:208] * source2; //[223:208];
                        result [239:224] = source1[239:224] * source2; //[239:224];
                        result [255:240] = source1[255:240] * source2; //[255:240];

                        MatrixDataOut = result;
		                result = 0;
                        source1 = 0;
                        source2 = 0;
                        
                    end

                endcase
            end
		end
	end
endmodule
