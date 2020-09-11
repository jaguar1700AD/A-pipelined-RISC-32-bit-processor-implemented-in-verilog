The 5 stage pipeline of the processor implements a subset of the instruction set of the MIPS-32 processor \
Pipeline data hazards are assumed to be taken care of by the compiler - by inserting dummy instructions whenever needed \
Control hazards are taken care of by the hardware by negating the previous instructions in the pipeline when a branch is chosen \
Structural hazards are avoided by assuming separate memories for data and instructions

The assembly code to be executed is written in the file - test_program.txt \
The Assembler.py file assembles it to machine language code - test_program_bin \
To run a simulation using iverilog, just execute the script execute.sh \
For using a compiler other than iverilog, modify the script accordingly

A sample assembly language program, that counts down from 28 to 0, is present in test_program.txt \
It contains "NO_OP" instructions, wherever necessary, to avoid pipeline data hazards
