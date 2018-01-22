KVERS = $(shell uname -r)

# Kernel modules
# This tell kbuild that there is one object in that directory named foo.o. 
# foo.o will be build from foo.c or foo.S.
# If foo.o shall be built as a module, the variable obj-m is used. 
# Therefore the following pattern is often used:
obj-m += proc.o  # m means module, y means built-in 

# Specify flags for the module compilation.
#EXTRA_CFLAGS=-g -O0

build: kernel_modules

kernel_modules:
	make -C /lib/modules/$(KVERS)/build M=$(CURDIR) modules

clean:
	make -C /lib/modules/$(KVERS)/build M=$(CURDIR) clean
