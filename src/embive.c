typedef struct {
    int error;
    int value;
} SyscallResult_t;

// Wait For Interrupt
//
// Ask the host to put the interpreter to sleep until an interruption occurs
// May return without any interruption.
void wfi(void)
{
    __asm__ volatile ("wfi");
}

// Exit the interpreter
void ebreak(void)
{
    __asm__ volatile ("ebreak");
}

// Enable Interrupts
//
// Set the `mstatus.MIE` bit to 1
void enable_interrupts(void)
{
    __asm__ volatile ("csrsi mstatus, 8");
}

// Disable Interrupts
//
// Set the `mstatus.MIE` bit to 0
void disable_interrupts(void)
{
    __asm__ volatile ("csrci mstatus, 8");
}

// System Call. Must be implemented by the host.
//
/// Parameters:
// - nr: System call number
// - a0..a6: Arguments
//
// Returns:
// - SyscallResult_t:
//   - error: Error code (0 if successful)
//   - value: Return value
SyscallResult_t syscall(int nr, int a0, int a1, int a2, int a3, int a4, int a5, int a6) {
    SyscallResult_t ret;

    register long ra0 asm("a0") = a0;
    register long ra1 asm("a1") = a1;
    register long ra2 asm("a2") = a2;
    register long ra3 asm("a3") = a3;
    register long ra4 asm("a4") = a4;
    register long ra5 asm("a5") = a5;
    register long ra6 asm("a6") = a6;
    register long ra7 asm("a7") = nr;

    __asm__ volatile ("ecall"
        : "+r"(ra0), "+r"(ra1)
        : "r"(ra2), "r"(ra3), "r"(ra4), "r"(ra5), "r"(ra6), "r"(ra7));
    
    ret.error = ra0;
    ret.value = ra1;

    return ret;
}
