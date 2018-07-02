prog : main.o fun.o
	cc -m64 -o prog main.o fun.o 
main.o : main.c
	cc -c -m64 main.c
fun.o : fun.s
	nasm -f elf64 fun.s

