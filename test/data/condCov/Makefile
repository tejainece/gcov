CC=gcc

all: main.o cond.o
	${CC} main.o cond.o -ftest-coverage -fprofile-arcs -o main.exe

main.o: main.c
	${CC} main.c -c -o main.o

cond.o: cond.c
	${CC} cond.c -ftest-coverage -fprofile-arcs -S -o cond.asm
	${CC} cond.c -ftest-coverage -fprofile-arcs -c -o cond.o

.PHONY: clean


clean:
	-rm -rf *.o main.exe
