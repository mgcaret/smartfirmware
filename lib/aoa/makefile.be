#CC = gcc
# optional COMPFLAGS: -D_DJGPP_SOURCE -DGETTIMEOFDAY -DBLOCKKERN
COMPFLAGS = -DBeBox -DMTSAFE -DGETTIMEOFDAY \
	-nosyspath -O7 -DPPC603=1 -Hcpplvl=3 -I./
CC 			= mwcc
LD 			= mwld
LIBS		= -nodefaults /boot/system/lib/libbe.so /boot/develop/libraries/libdll.a


INCLUDES = -I- -I../cgt
CFLAGS = $(COMPFLAGS) $(INCLUDES)
#RUNLOGOBJS_AOA  = runlogc.o stopwch.o stopwcha.o
RUNLOGOBJS_AOA = runlogc.o
RUNLOGOBJS = $(RUNLOGOBJS_AOA) memalign.o
GCOBJS = gcbase.o gcms.o gcext.o gclist.o

OBJS = aoa.o
OBJS_I = aoa_i.o
HDRS = gcext.h
FILES = makefile.dos makefile.bsd makefile.sol makefile.mpw tkhist \
	$(HDRS) aoa.c memtest.cc memt.c memt2.c \
	hist.cc munge.cc runlogc.c memalign.c tables.cc \
	stopwch.h stopwch.cc stopwcha.s example.cc \
	aoa.h gcbase.h gcbase.c gcms.c gcext.c gclist.c gctest.c
LIB = libaoa.a
LIB_I = libaoa_i.a
#GCLIB = libaoagc.a
#LIBS = ../cgt/libcgt.a
TARGET = /cgt

#LIB = $(OBJS)
#LIB_I = $(OBJS_I)
GCLIB = $(GCOBJS)

all:	$(LIB) $(LIB_I) $(GCLIB) $(HDRS) memtest memt memt2 \
	gctest example munge hist \
	runloga runlogf runlogi runloggc runloggnu
#	runloga runlogbsd runlogf runlogi runloggc \
#	runlogwf runlogwg runloggnu runloggnu+ runlogg++ runlogcsri runlogqf

gctest: gctest.o $(GCLIB) $(LIB)
	$(CC) $(CFLAGS) -o gctest gctest.o $(GCLIB) $(LIB) $(LIBS)
gctest.o: gctest.c gcext.h

example: example.o $(GCLIB) $(LIB)
	$(CC) $(CFLAGS) -o example example.o $(GCLIB) $(LIB) $(LIBS)
example.o: example.cc gcext.h

#$(GCLIB): $(GCOBJS)
#	rm -f $(GCLIB)
#	ar r $(GCLIB) $(GCOBJS)
#	if [ -x /usr/bin/ranlib ]; then ranlib $(GCLIB); else ar rs $(GCLIB); fi

gcbase.o: gcbase.c aoa.h gcbase.h
gcms.o: gcms.c aoa.h gcbase.h gcext.h
gcext.o: gcext.c aoa.h gcbase.h gcext.h
gclist.o: gclist.c aoa.h gcbase.h gcext.h

export:	$(LIB) $(LIB_I) $(GCLIB) $(HDRS)
	cp $(LIB) $(LIB_I) $(GCLIB) $(TARGET)/lib 
	cp $(HDRS) $(TARGET)/include

$(LIB):	$(OBJS)
	rm -f $(LIB)
	$(LD) -sym full -xml -o $(LIB) $(OBJS)
#	ar r $(LIB) $(OBJS)
#	if [ -x /usr/bin/ranlib ]; then ranlib $(LIB); else ar rs $(LIB); fi

$(LIB_I):	$(OBJS_I)
	rm -f $(LIB_I)
	$(LD) -sym full -xml -o $(LIB_I) $(OBJS_I)
#	ar r $(LIB_I) $(OBJS_I)
#	if [ -x /usr/bin/ranlib ]; then ranlib $(LIB_I); else ar rs $(LIB_I); fi

memtest:	memtest.o $(LIB)
	$(CC) $(CFLAGS) -o memtest memtest.o $(LIB) $(LIBS)

memt:	memt.o $(LIB)
	$(CC) $(CFLAGS) -o memt memt.o $(LIB) $(LIBS)

memt2:	memt2.o $(LIB)
	$(CC) $(CFLAGS) -o memt2 memt2.o $(LIB) $(LIBS)

munge:	munge.o
	$(CC) $(CFLAGS) -o munge munge.o $(LIBS)

hist:	hist.o
	$(CC) $(CFLAGS) -o hist hist.o $(LIBS)

runloga:	$(RUNLOGOBJS_AOA) $(LIB)
	$(CC) $(CFLAGS) -o runloga $(RUNLOGOBJS_AOA) $(LIB) $(LIBS)
#	aout2exe runloga

runlogbsd:	$(RUNLOGOBJS)
	$(CC) $(CFLAGS) -o runlogbsd $(RUNLOGOBJS)

runlogf:	$(RUNLOGOBJS)
#	$(CC) $(CFLAGS) -o runlogf $(RUNLOGOBJS) ../fmalloc/libfmalloc.a ../cgt/libcgt.a
	$(CC) $(CFLAGS) -o runlogf $(RUNLOGOBJS) ../fmalloc/fmalloc.o

runloggnu:	$(RUNLOGOBJS)
	$(CC) $(CFLAGS) -o runloggnu $(RUNLOGOBJS)
#	$(CC) $(CFLAGS) -o runloggnu $(RUNLOGOBJS) -lgnumalloc

runloggnu+:	$(RUNLOGOBJS)
	$(CC) $(CFLAGS) -o runloggnu+ $(RUNLOGOBJS) -lgnu+malloc

runlogg++:	$(RUNLOGOBJS)
	$(CC) $(CFLAGS) -o runlogg++ $(RUNLOGOBJS_AOA) -lg++malloc

runlogcsri:	$(RUNLOGOBJS)
	$(CC) $(CFLAGS) -o runlogcsri $(RUNLOGOBJS) -lcsrimalloc

runlogqf:	$(RUNLOGOBJS)
	$(CC) $(CFLAGS) -o runlogqf $(RUNLOGOBJS_AOA) -lqfmalloc

runloggc:	$(RUNLOGOBJS)
	$(CC) $(CFLAGS) -o runloggc $(RUNLOGOBJS) -lgc

runlogi:	$(RUNLOGOBJS_AOA) aoa_i.o
	$(CC) $(CFLAGS) -o runlogi $(RUNLOGOBJS_AOA) aoa_i.o $(LIBS)

runlogwf:	$(RUNLOGOBJS)
	$(CC) $(CFLAGS) -o runlogwf $(RUNLOGOBJS) ../wfmalloc/libwfmalloc.a ../cgt/libcgt.a

runlogwg:	$(RUNLOGOBJS)
	$(CC) $(CFLAGS) -o runlogwg $(RUNLOGOBJS) ../wgmalloc/libwgmalloc.a ../cgt/libcgt.a

aoa_i.o:	aoa.c
	$(CC) $(CFLAGS) -DINSTRUMENT -c -o aoa_i.o aoa.c

aoa.o:	aoa.c aoa.h
memtest.o:	memtest.cc
memt.o:	memt.c
memt2.o:	memt2.c
stopwch.o:	stopwch.cc

ct.o: ct.c

ct: ct.o
	$(CC) $(CFLAGS) -o ct ct.o

cta: ct.o $(LIB)
	$(CC) $(CFLAGS) -o cta ct.o $(LIB)

cti: ct.o $(LIB_I)
	$(CC) $(CFLAGS) -o cti ct.o $(LIB_I)

cu.o: cu.c

cu: cu.o
	$(CC) $(CFLAGS) -o cu cu.o

cua: cu.o $(LIB_I)
	$(CC) $(CFLAGS) -o cua cu.o $(LIB_I)

stopwcha.o:	stopwcha.s
	as -o stopwcha.o stopwcha.s

clean:
	rm -f *.o *.a aoa_i.c test memt memt2 memtest gctest \
	runlog? hist munge tags

.SUFFIXES:	.c .cc .o

.c.o:
	$(CC) -c $(CFLAGS) $<

.cc.o:
	$(CC) -c $(CFLAGS) $<

tar:
	gtar -zcf aoa.tgz $(FILES)
#	tar -cf - $(FILES) | compress -b14 >aoa.trx

tarall:
	gtar -zcf aoa.tgz $(FILES) RCS
#	tar -cf - $(FILES) RCS | compress -b14 >aoa.trz

files:
	@echo $(FILES)

difflist:
	@for f in $(FILES); do rcsdiff -q $$f >/dev/null || echo $$f; done
