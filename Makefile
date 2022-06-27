# The default filename (without extension) is "main" and the ".asm" extension is used for assembly files.
# The user is encouraged to override these (either through the command line or directly within the makefile)
# The NASM assembler has been used along with the ld linker available by default on most linux distributions

ASSEMBLE		= nasm
ASSEMBLY_EXT	= asm
ASSEMBLE_FLAGS	= "-felf64"

LINK			= ld
# LINK_FLAGS		=

FILENAME		= main

default: assemble link

clean:
	rm -f build/$(FILENAME).o
	rm -f build/$(FILENAME)

assemble:
	$(ASSEMBLE) $(ASSEMBLE_FLAGS) $(FILENAME).$(ASSEMBLY_EXT) -o build/$(FILENAME).o

link:
	$(LINK) build/$(FILENAME).o -o build/$(FILENAME)
