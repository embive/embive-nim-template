# Nim Template for Embive
A simple program that runs inside the Embive interpreter.

## Requirements (to build)
- GCC (riscv32-unknown-elf)
    - Download the [RISC-V toolchain](https://github.com/riscv-collab/riscv-gnu-toolchain)
    - Install the dependencies from the README
    - Compile and install it:
        - `$ ./configure --prefix=/opt/riscv --with-arch=rv32imaczicsr_zifencei --with-abi=ilp32`
        - `$ make -j8`
    - Add `/opt/riscv/bin` to your PATH
- Nim (v2.2.2 or greater)
    - Install latest stable release: 
        - `curl https://nim-lang.org/choosenim/init.sh -sSf | sh`

## How to build
- Compile the project
    - `$ nim build project`

## How to run
- Create a new project
    - `$ cargo new embive-project && cd embive-project`
- Add Embive as a dependency
    - `$ cargo add embive`
- Copy the example from Embive's docs/readme.
- Change the code to: `const ELF_FILE: &[u8] = include_bytes!("../app.elf");`
- Copy the generated `app.elf` (inside `out` folder) to your project
- Run it:  
    - `$ cargo run --release`

## Stack
By default, the stack size is set to 2048 bytes (0x800).  
You can change this by modifying the `STACK_SIZE` variable in the [linker script](memory.ld).

## Heap
The heap is set at the end of the memory space allocated by the application (after stack and data).  
As such, the heap size doesn't need to be known at link time, instead being able to grow as large
as the maximum memory available.

## RAM calculation
You can calculate the minimum amount of RAM needed by you application with the following equation:  
- `total_ram = data + bss`

To get the `data` and `bss` sizes, you can run:  
- `$ riscv32-unknown-elf-size out/app.elf`
    - The stack and heap will be reported as part of the bss

The result should be something like this:
```
   text    data     bss     dec     hex filename
    376       0    2060    2436     984 out/app.elf
```

For this result, our minimum RAM size would be:  
- `total_ram = 0 + 2060 = 2060 bytes`
