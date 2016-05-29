all:
	gcc main.o empty.o -o main.exe

main.o: main.c
	gcc main.c -c -o main.o

empty.o: empty.c
	gcc empty.c -ftest-coverage -fprofile-arcs -c -o empty.o

.PHONY: clean


clean:
	-rm -rf *.o
