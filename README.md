# Nim Template for Embive
A simple program that runs inside the Embive interpreter.

## Requirements (to build)
- GCC (riscv32-unknown-elf)
    - Download the [RISC-V toolchain](https://github.com/riscv-collab/riscv-gnu-toolchain)
    - Install the dependencies from the README
    - Compile and install it:
        - `$ ./configure --prefix=/opt/riscv --with-arch=rv32imzicsr_zifencei --with-abi=ilp32`
        - `$ make -j8`
    - Add `/opt/riscv/bin` to your PATH
- Nim (development branch)
    - Clone Nim repository: 
        - `$ git clone https://github.com/nim-lang/Nim && cd nim`
    - Build Nim:
        - `$ ./build_all.sh`
    - Add the generated bin folder to your PATH

## How to build
- Compile the project
    - `$ nim build project`

## How to run
- Create a new project
    - `$ cargo new embive-project && cd embive-project`
- Add Embive as a dependency
    - `$ cargo add embive --features m_extension`
- Copy the example from Embive's docs/readme.
- Swap the line `let code = ...` to `let code = include_bytes!("../app.bin");`
- Copy the generated `app.bin` to your project
- Run it:  
    - `$ cargo run --release`

## Stack Size
By default, the stack size is set to 1024 bytes (0x400).  
You can change this by modifying the `STACK_SIZE` variable in the [linker script](memory.ld).  
The stack size should always be a multiple of 16 bytes.

## Heap Size
By default, the heap size is set to 1024 bytes (0x400).  
You can change this by modifying the `HEAP_SIZE` variable in the [linker script](memory.ld).  
The heap end address will always be aligned to 16 bytes.

## RAM calculation
You can calculate the minimum amount of RAM needed by you application with the following equation:  
- `total_ram = data + bss`

To get the `data` and `bss` sizes, you can run:  
- `$ riscv32-unknown-elf-size app.elf`
    - The stack and heap will be reported as part of the bss

The result should be something like this:
```
   text    data     bss     dec     hex filename
    440       4    2060    2504     9c8 out/app.elf
```

For this result, our minimum RAM size would be:  
- `total_ram = 4 + 2060 = 2064 bytes`
