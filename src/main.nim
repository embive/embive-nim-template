import embive

var GLOBAL_DATA {.global.}: int = 20
const CONST_DATA: int = 10

# Interrupt handler
# This function is called when an interruption occurs
proc interruptHandler() {.exportc.} =
    # Do something here
    discard

# Main

# Enable interrupts
enableInterrupts()

# System Call 2: Get i32 value at address
# The host will receive the GLOBAL_DATA address, read it from memory and return its value
let result = syscall(2, cast[int](addr(GLOBAL_DATA)), 0, 0, 0, 0, 0, 0)

# Wait for interrupt
wfi()

if result.error == 0:
    # System Call 1: Add two numbers (a0 + a1)
    discard syscall(1, result.value, CONST_DATA, 0, 0, 0, 0, 0)
