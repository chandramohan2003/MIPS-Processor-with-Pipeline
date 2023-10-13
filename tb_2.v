// Load a word stored in memory location 120, add 45 to it, and store the resul in memory location 121. 4
// The steps:
// Initialize register R1 with the memory address 120.
// Load the contents of memory location 120 into register R2.
// Add 45 to register R2.
// Store the result in memory location 121.

`include "mips32_with_pipeline.v"
module test_mips32_2;
    reg clk1, clk2;
    integer k;

    pipe_MIPS32 mips (clk1, clk2);
    initial
        begin
            clk1= 0; clk2 = 0;
            repeat (20)
            begin
            #5 clk1 = 1; #5 clk1 = 0; // two phase clock
            #5 clk2 = 1; #5 clk2 = 0;
            end
        end
    
    initial
        begin
            for (k=0; k<31; k++) 
                mips.Reg [k] = k;
                mips.Mem[0] = 32'h28010078; // ADDI R1, RO, 120
                mips.Mem[1]= 32'h0c631800;// OR R3, R3, R3
                mips.Mem[2]= 32'h20220000; // LW R2,0 (R1)
                mips.Mem[3]= 32'h0c631800;//OR 3, R3, R3
                mips.Mem[4]= 32'h2842002d;// ADDI R2, R2, 45
                mips.Mem [5] = 32'h0c631800;// OR  R3, R3, R3
                mips.Mem[6] = 32'h24220001; // SW  R2, 1 (R1)
                mips.Mem [7] = 32'hfc000000; // HLT
                mips. Mem [120] = 85;

                mips.HALTED = 0;
                mips.PC = 0;
                mips.TAKEN_BRANCH = 0;
                #300
                $display ("Mem[120]: %4d \nMem[121]: %4d",mips.Mem[120],mips.Mem[121]);
        end

          initial
            begin
                $dumpfile ("mips_2.vcd");
                $dumpvars (0, test_mips32_2); 
                #300 $finish;
            end
    endmodule