module mips(input clk);
	// Convention: The number ahead of a reg denotes the pipeline stage that that reg belonges to
	// Pipeline Stages: 0, 1, 2, 3, 4

	reg null1, null2, null3, null4, halt; // null denotes whether an instruction should be treated as null; halt denotes whether the pipeline should be halted

	reg [31:0] pc0, instr_buff1, npc1, npc2;
	reg [31:0] a2, b2, b3, imm_data2; 
	reg [5:0] opcode2, opcode3, opcode4;
	reg [31:0] alu_out3, alu_out4, cond3;
	reg [31:0] lmd4;
	reg [4:0] rd2, rd3, rd4;

	reg [31:0] instruction_memory [0:1023];
	reg [31:0] data_memory [0:1023];
	reg [31:0] register_bank [0:31];

	// Define instruction types
	parameter ADD = 6'b100001, SUB = 6'b100010, AND = 6'b100100, OR = 6'b101000, SLT = 6'b110000, MUL = 6'b100000, HLT = 6'b111111;
	parameter LW = 6'b000011, SW = 6'b000110, ADDI = 6'b001110, SUBI = 6'b001101, SLTI = 6'b010000, BNEQZ = 6'b000111, BEQZ = 6'b011110;
	parameter NO_OP = 6'b000000;

	wire branch_taken;
	assign branch_taken = (opcode3 == BEQZ && cond3 == 1) || (opcode3 == BNEQZ && cond3 == 0);

	// Stage 0: Instruction Fetch
	always @(posedge clk)
	begin
		if (!halt)
		begin
			if (instr_buff1[31:26] == HLT || opcode2 == HLT || opcode3 == HLT || opcode4 == HLT) 
				null1 <= 1'b1;
			else
			begin
				instr_buff1 <= instruction_memory[pc0];
				if (branch_taken) pc0 <= alu_out3;
				else pc0 <= pc0 + 1;
				npc1 <= pc0 + 1;
			end
		end
	end

	// Stage 1: Instruction Decode
	always @(posedge clk)
	begin
		if (!halt)
		begin
			if (null1) 
				null2 <= null1;
			else if (branch_taken || instr_buff1[31:26] == NO_OP) 
				null2 <= 1'b1;
			else
			begin
				opcode2 <= instr_buff1[31:26];
				if (instr_buff1[31] == 0) rd2 <= instr_buff1[20:16] else rd2 <= instr_buff1[15:11];
				a2 <= register_bank[instr_buff1[25:21]];
				b2 <= register_bank[instr_buff1[20:16]];
				imm_data2 <= {{16 {instr_buff1[15]}}, {instr_buff1[15:0]}};
				npc2 <= npc1;
				null2 <= null1;
			end
		end
	end

	// Stage 2: Execute
	always @(posedge clk)
	begin
		if (!halt)
		begin
			if (null2)
				null3 <= null2;
			else
			begin
				case (opcode2)
					ADD: alu_out3 <= a2 + b2;
					SUB: alu_out3 <= a2 - b2;
					AND: alu_out3 <= a2 & b2;
					OR: alu_out3 <= a2 | b2;
					SLT: alu_out3 <= a2 < b2;
					MUL: alu_out3 <= a2 * b2;
					LW: alu_out3 <= a2 + imm_data2;
					SW: alu_out3 <= a2 + imm_data2;
					ADDI: alu_out3 <= a2 + imm_data2;
					SUBI: alu_out3 <= a2 - imm_data2;
					SLTI: alu_out3 <= a2 < imm_data2;
					BNEQZ: begin alu_out3 <= npc2 + imm_data2; cond3 <= (a2 == 0); end
					BEQZ: begin alu_out3 <= npc2 + imm_data2; cond3 <= (a2 == 0); end
				endcase
				null3 <= null2;
				opcode3 <= opcode2;
				b3 <= b2;
				rd3 <= rd2;
			end
		end
	end

	// Stage 3: Memory Stage
	always @(posedge clk)
	begin
		if (!halt)
		begin
			if (null3)
				null4 <= null3;
			else
			begin
				case (opcode3)
					LW: lmd4 <= data_memory[alu_out3];
					SW: data_memory[alu_out3] <= b3;
				endcase
				null4 <= null3;
				alu_out4 <= alu_out3;
				rd4 <= rd3;
			end
		end
	end

	// Stage 4: Write Back Stage
	always @(posedge clk)
	begin
		if (!halt)
		begin
			if (!null4)
			begin
				case (opcode4)
					ADD: register_bank[rd4] <= alu_out4;
					SUB: register_bank[rd4] <= alu_out4;
					AND: register_bank[rd4] <= alu_out4;
					OR: register_bank[rd4] <= alu_out4;
					SLT: register_bank[rd4] <= alu_out4;
					MUL: register_bank[rd4] <= alu_out4;
					LW: register_bank[rd4] <= lmd4;
					ADDI: register_bank[rd4] <= alu_out4;
					SUBI: register_bank[rd4] <= alu_out4;
					SLTI: register_bank[rd4] <= alu_out4;
				endcase
				if (opcode4 == HLT) halt <= 1'b1;
			end
		end
	end

endmodule