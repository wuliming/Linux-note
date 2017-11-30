all::	cpulimit while1

cpulimit:	cpulimit.c
	gcc -o cpulimit cpulimit.c -lrt -Wall 

while1:	while1.c
	gcc -o while1 while1.c

clean:
	rm -f *~ cpulimit while1
