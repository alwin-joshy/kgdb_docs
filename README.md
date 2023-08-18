# seL4 GDB documentation (DRAFT)

## Description:

This guide documents how to use the kernel gdb stub that has been implemented for the seL4 microkernel. You might find this useful for debugging user-level applications on real hardware.

## Requirements:

* A version of the kernel with the changes found [here](https://github.com/alwin-joshy/seL4/tree/gdb_stub), built with `-DKernelDebugBuild=ON -DKernelPrinting=ON -DKernelGdb=ON`

* An odroidc2 (or other aarch64 board --- untested)

* `aarch64-none-elf-gdb`

* readwrite connection to the debug serial port used by seL4 for your board.

## Entering KGDB

The main handler loop for kgdb is found in the function `kgdb_handler()` in `src/kgdb/kgdb.c`

The handler is invoked by default when an irrecoverable fault occurs in a user-level process (in `src/kernel/faulthandler.c.`). You can extend this by invoking the handler in other parts of the kernel code. 

The kgdb handler can also be entered from userspace by using the `seL4_SysDebugEnterKGDB` system call. When this is called from a user-space application, the execution of the system is halted while the gdb stub waits for a connection. 

## Setting up a connection

Set up your desired entry point for the gdb stub, whether this is in the aforementioned kernel fault handler or some specific point in a user-level application. Run the system on the target machine and wait for it to halt. When the gdb stub has been entered, you will see a message in the serial output that looks something like `Waiting for GDB connection...` From this point, you GDB should have exclusive access to the serial port unless you have some kind of multiplexing setup. 

To connect to the board, run `aarch64-none-elf-gdb /path/to/binary/` on the host machine with the binary of the application you are trying to debug. Then, configure the baud rate as required e.g. `set serial baud 115200`, and if desired, enable additional logging information using the `set debug remote 1` command. Finally, connect to the target's serial port by using a command such as `target remote /dev/cu.usbserial-0177E4AD`.

## Notes

* The GDB stub currently only supports serial communication. We are planning to implement a network based communication protocol for seL4CP based systems.

* The GDB stub is set up for debugging userspace applications, **NOT** the kernel. The registerset that it reads is that of the user prior to entering the kernel, not the current register state.

* The GDB stub has only been tested for the HardKernel odroidc2 platform, but should also work for other aarch64 boards.

* The GDB stub is still in development phase and may currently break other configurations.

* The GDB stub currently supports:
	* Software breakpoints
	* Hardware breakpoints
	* Single stepping
	* Memory read/write

* The GDB stub is still under development for systems with multiple concurrently running threads. 

