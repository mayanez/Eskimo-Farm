ifneq (${KERNELRELEASE},)

# KERNELRELEASE defined: we are being compiled as part of the Kernel
        obj-m := vga_led.o audio_hw.o

else

# We are being compiled as a module: use the Kernel build system

	KERNEL_SOURCE := /home/develop/linux-socfpga
        PWD := $(shell pwd)


default: module

module:
	${MAKE} ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -C ${KERNEL_SOURCE} SUBDIRS=${PWD} modules

clean:
	${MAKE} ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -C ${KERNEL_SOURCE} SUBDIRS=${PWD} clean
	${RM} hello main

#Compile from FPGA
usbkeyboard.o: usbkeyboard.c usbkeyboard.h

main: main.c game.h vga_led.h usbkeyboard.h audio_hw.h
	gcc main.c game.h vga_led.h usbkeyboard.c usbkeyboard.h audio_hw.h -lusb-1.0 -pthread -o main

socfpga.dtb : socfpga.dtb
	dtc -O dtb -o socfpga.dtb socfpga.dts

endif 
