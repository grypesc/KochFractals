prog : main.o fun.o
	cc -m32 -o prog main.o fun.o 
main.o : main.c
	cc -m32 -c main.c
fun.o : fun.s
	nasm -f elf32 fun.s

