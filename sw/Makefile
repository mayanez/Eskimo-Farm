ifneq (${KERNELRELEASE},)

# KERNELRELEASE defined: we are being compiled as part of the Kernel
        obj-m := vga_led.o

else

# We are being compiled as a module: use the Kernel build system

	KERNEL_SOURCE := /home/develop/linux-socfpga
        PWD := $(shell pwd)


default: module hello main

module:
	${MAKE} ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -C ${KERNEL_SOURCE} SUBDIRS=${PWD} modules

clean:
	${MAKE} ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -C ${KERNEL_SOURCE} SUBDIRS=${PWD} clean
	${RM} hello main

hello: hello.c
	arm-linux-gnueabihf-gcc hello.c -o hello

main: main.c game.h vga_led.h 
	arm-linux-gnueabihf-gcc main.c -o main

socfpga.dtb : socfpga.dtb
	dtc -O dtb -o socfpga.dtb socfpga.dts

endif 
