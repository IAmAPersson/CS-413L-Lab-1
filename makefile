ASM=as
LNK=gcc

lab1: source.s
	$(ASM) -o lab1.o source.s
	$(LNK) -o lab1 lab1.o
