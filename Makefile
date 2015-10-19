#
# To build with a different compiler / on a different platform, use
#     make PLATFORM=xxx
#
# where xxx is
#     icc = Intel compilers
#     gcc = GNU compilers
#     clang = Clang compiler (OS X default)
#
# Or create a Makefile.in.xxx of your own!
#

PLATFORM=icc
include Makefile.in.$(PLATFORM)

.PHONY: exe clean realclean


# === Executables

exe: path.x

path.x: path.o mt19937p.o
	$(CC) -fopenmp $(CFLAGS) $^ -o $@

path.o: path.c
	$(CC) -c -fopenmp $(CFLAGS) $< 

path-mpi.x: path-mpi.o mt19937p.o
	$(MPICC) $(CFLAGS) $^ -o $@

path-mpi.o: path-mpi.c
	$(MPICC) -c $(CFLAGS) $< 

%.o: %.c
	$(CC) -c $(CFLAGS) $< 


# === Documentation

main.pdf: path.md
	pandoc $^ -o $@

path.md: path.c
	ldoc -o $@ $^


# === Cleanup and tarball

clean:
	rm -f *.o 
	rm -f main.aux main.log main.out

realclean: clean
	rm -f path.x path-mpi.x path.md main.pdf