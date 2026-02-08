FC ?= lfortran

all: test

mod.o: mod.f90
	$(FC) -c mod.f90 -o mod.o

libmod.a: mod.o
	ar rcs libmod.a mod.o

main.o: main.f90 libmod.a
	$(FC) -c main.f90 -o main.o

test: main.o libmod.a
	$(FC) main.o -L. -lmod -o test

clean:
	rm -f *.o *.mod *.a test

.PHONY: all clean
