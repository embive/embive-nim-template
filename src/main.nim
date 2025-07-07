import embive
import std/volatile

let CONST_DATA: int = 20
var GLOBAL_DATA {.global.}: int = 0

# Interrupt handler
# This function is called when an interruption occurs
proc interruptHandler(value: int) {.exportc.} =
    # Set GLOBAL_DATA to the received value
    volatileStore(addr(GLOBAL_DATA), value)

# Main

# Enable interrupts
enableInterrupts()

# System Call 2: Get i32 value at address
# The host will receive the CONST_DATA address, read it from memory and return its value
let result = syscall(2, cast[int](addr(CONST_DATA)), 0, 0, 0, 0, 0, 0)

# Wait for interrupt
wfi()

if result.error == 0:
    # System Call 1: Add two numbers (a0 + a1)
    discard syscall(1, result.value, volatileLoad(addr(GLOBAL_DATA)), 0, 0, 0, 0, 0)
