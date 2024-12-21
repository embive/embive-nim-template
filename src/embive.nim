{.compile: "embive.c".}

type 
    SyscallResult* {.bycopy.} = object
        error*: cint
        value*: cint

proc wfi*() {.importc}
proc ebreak*() {.importc, noreturn.}
proc enableInterrupts*() {.importc: "enable_interrupts".}
proc disableInterrupts*() {.importc: "disable_interrupts".}

proc syscall*(nr: cint, a0: cint, a1: cint, a2: cint, a3: cint, a4: cint, a5: cint, a6: cint): SyscallResult {.importc.}
proc main(argc: cint, args: cstringArray, env: cstringArray): int {.importc.} # Nim main function

var
    sbss {.importc: "__bss_target_start".}: cint
    ebss {.importc: "__bss_target_end".}: cint
    sdata {.importc: "__data_target_start".}: cint
    edata {.importc: "__data_target_end".}: cint
    sidata {.importc: "__data_source_start".}: cint

proc codeEntry() {.exportc.} =
    var offset {.volatile.}: uint = 0
    # Initialize bss section
    while cast[uint](sbss.addr) + offset < cast[uint](ebss.addr):
        cast[ptr int](cast[pointer](cast[uint](sbss.addr) + offset))[] = 0
        offset += cast[uint](sizeof(int))

    offset = 0
    # Initialize data section
    while cast[uint](sdata.addr) + offset < cast[uint](edata.addr):
        cast[ptr int](cast[pointer](cast[uint](sdata.addr) + offset))[] = cast[ptr int](cast[pointer](cast[uint](sidata.addr) + offset))[]
        offset += cast[uint](sizeof(int))
    
    # Call Nim main function
    discard main(0, nil, nil)

    # Exit the interpreter
    ebreak()
