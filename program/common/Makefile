# Makefile example that can be used with common RISC-V toolchain
#
# Stanislav Zhelnio, 2020
#

# default target to run when make is called without args
help:
	$(info make help     - show this message)
	$(info make clean    - delete folder with simulation data)
	$(info make rars     - run RISC-V CPU simulator)
	$(info make build    - create .hex program image (default))
	@true

# common targets

# make clean
#  delete all compilation products & folder with simulation data
clean:
	rm -rf sim
	rm -f *.elf *.dis *.mem *.hex

# make rars
#  java -jar ../common/rars1_4.jar
#  * run rars1_4.jar application using java machine
RARS = java -jar ../common/rars1_4.jar
rars:
	$(RARS)

#########################################################
# software build

# embedded toolchain is prefered
CROSS_COMPILE ?= riscv64-unknown-elf-

CC = $(CROSS_COMPILE)gcc
OD = $(CROSS_COMPILE)objdump
OC = $(CROSS_COMPILE)objcopy

build: program.dis program.hex

#compile program
#  Makefile automatic variables:
#    $@ - The file name of the target of the rule (program.elf)
#    $^ - The names of all the prerequisites (main.S)
#  riscv64-unknown-elf-gcc    - run gcc compiler
#    -o program.elf           - output file
#    main.S                   - input file
#    -O0                      - disable optimization
#    -march=rv32i             - target architecture RISC-V, instruction set rv32i
#    -mabi=ilp32              - integer ABI (int, long, and pointers are all 32-bits long. 
#                               long long is a 64-bit type, char is 8-bit, and short is 16-bit)
#                               Details: https://www.sifive.com/blog/all-aboard-part-1-compiler-args
#    -nostdlib                - Do not use the standard system startup files or libraries when linking
#    -T ../common/program.ld  - Use program.ld as the linker script
program.elf: main.S
	$(CC) -o $@ $^ -O0 -march=rv32iv -mabi=ilp32 -nostdlib -T ../common/program.ld

#disassemble program
#  Makefile automatic variables:
#    $@ - The file name of the target of the rule (program.dis)
#    $< - The name of the first prerequisite (program.elf)
#  riscv64-unknown-elf-objdump - display information from object files
#    -M no-aliases             - disassembler-options; Print the 'raw' instruction 
#                                mnemonic instead of some pseudo instruction mnemonic
#    -D                        - disassemble the contents of all sections
#    program.elf               - input file
#    > program.dis             - redirect output to program.dis
program.dis: program.elf
	$(OD) -M no-aliases -D $< > $@

# dump program to memory image HEX file
#  Makefile automatic variables:
#    $@ - The file name of the target of the rule (program.dis)
#    $< - The name of the first prerequisite (program.elf)
# riscv64-unknown-elf-objcopy - copy and translate object files
#    program.elf              - input file
#    -O verilog               - output format
#    program.mem              - output file
program.mem: program.elf
	$(OC) $< -O verilog $@

# convert 8-bit hex dump to 32-bit hex-dump
# can be skipped if *-objcopy supports '--verilog-data-width' option
program.hex: program.mem
	../common/hex32.py $< $@
	sed -i '1d' $@

