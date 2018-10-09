OBJS = himenoBMTxps.o

CC = gcc
RM = /bin/rm
PROG = bmt

#CFLAGS = -O3 -DLARGE
CFLAGS = -O3 -DMIDDLE
LDFLAGS = ${CFLAGS}

all : ${PROG}
	gcc -o bindcpu bindcpu.c

${PROG} : ${OBJS}
	${CC} -o $@ ${OBJS} ${LDFLAGS}

.c.o :
	${CC} -c ${CFLAGS} $<

clean :
	${RM} -f ${PROG} ${OBJS} core
	rm -f bindcpu

