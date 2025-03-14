# MIPS32 Single Cycle
# Detailed Description

This project aims to implement some of the operations within the ISA supported by the MIPS32 microprocessor structure in Vivado using VHDL, on a Xilinx Basys 3 FPGA. It supports a multitude of operations, including R-type operations (arithmetic/logic operations between 2 registers), I-type operations (arithmetic/branch/conditional-jump operations between a register and a fixed constant), and J-type operations (unconditional jumps to the instruction indexed by a specified constant). One may write their own instruction ROM, but one thing to keep in mind is that MIPS assembly notation is [not] supported within the ROM, but a 1 to 1 correspondence was provided between each assembly instruction and a corresponding binary sequence (i.e. machine code). All of the binary correspondents can be found in the associated Excel table (Control Signals.xlsx). An example program ROM was also provided (Example ROM.txt). 4 out of the 5 stages of the MIPS pipeline were implemented, namely IF.vhd (Instruction Fetch - this stage is also the one where the instruction ROM is to be inserted), ID.vhd (Instruction Decode), EX.vhd (Instruction Execution Unit), and WB.vhd (Write Back). All of the inputted / outputted data will be displayed on the board's SSD (Seven Segment display), which is also coded within a SSD.vhd file. For synchronization purposes, a monopulse generator was also implemented (MPG.vhd). The main program which blends all of these together is the "test_env.vhd" file. This is the file whose bitstream will be generated implemented on the board.

# Hardware Requirements:
- [ ] The **Xilinx Basys 3 Board** for testing the MIPS32 implementation.
- [ ] A **USB cable** for powering the board.

# Software Requirements:
- [ ] The **Xilinx Vivado IDE** for **VHDL** coding.
