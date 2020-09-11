module test_bench;
	reg clk;

	mips DUT(clk);

	integer i;

	// Initialize instruction memory, data memory, register banks and pc
	initial
	begin
		for (i = 0; i < 32; i = i + 1) DUT.register_bank[i] = 0;
		for(i = 0; i < 1023; i = i + 1) DUT.data_memory[i] = i;

		$readmemb("test_program_bin", DUT.instruction_memory);

		DUT.pc0 = 0;
		DUT.halt = 0;
	end

	initial
	begin
		clk = 0;
		#10000 $finish;
	end

	always
	begin
		#5 clk = ~clk;
	end

	initial
	begin
		$monitor($time, " Opcodes: %b %b %b %b Branch: %b Reg: %d %d %d %d ", DUT.instr_buff1[31:26], DUT.opcode2, DUT.opcode3, DUT.opcode4, DUT.branch_taken, DUT.register_bank[1], DUT.register_bank[2], DUT.register_bank[3], DUT.register_bank[5]);
		$dumpfile("mips.vcd"); 
		$dumpvars(0, test_bench);
	end

endmodule 