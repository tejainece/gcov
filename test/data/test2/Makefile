all: main.o
	gcc main.o -o main.exe

main.o: main.c
	gcc main.c -ftest-coverage -fprofile-arcs -c -o main.o

.PHONY: clean


clean:
	-rm -rf *.o
