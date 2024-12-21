.section .text.init.entry, "ax"
.global _entry

_entry:
    /* Initialize global pointer */
    .option push
    .option norelax
    la gp, __global_pointer$
    /* Set interrupt trap */
    la t0, _interrupt_trap
    csrw mtvec, t0
    /* Enable embive interrupt (mie bit 16) */
    la t0, 65536
    csrw mie, t0
    /* Initialize stack and frame pointers */
    la t1, __stack_start
    andi sp, t1, -16
    add s0, sp, zero
    .option pop
    /* Call codeEntry */
    jal ra, codeEntry

    .option push
    .balign 0x4
    .option norelax
    .option norvc
_interrupt_trap:
    /* Save registers */
    addi sp, sp, -16*4
    sw ra, 0*4(sp)
    sw t0, 1*4(sp)
    sw t1, 2*4(sp)
    sw t2, 3*4(sp)
    sw t3, 4*4(sp)
    sw t4, 5*4(sp)
    sw t5, 6*4(sp)
    sw t6, 7*4(sp)
    sw a0, 8*4(sp)
    sw a1, 9*4(sp)
    sw a2, 10*4(sp)
    sw a3, 11*4(sp)
    sw a4, 12*4(sp)
    sw a5, 13*4(sp)
    sw a6, 14*4(sp)
    sw a7, 15*4(sp)
    /* Call interrupt handler */
    jal ra, interruptHandler
    /* Restore registers */
    lw ra, 0*4(sp)
    lw t0, 1*4(sp)
    lw t1, 2*4(sp)
    lw t2, 3*4(sp)
    lw t3, 4*4(sp)
    lw t4, 5*4(sp)
    lw t5, 6*4(sp)
    lw t6, 7*4(sp)
    lw a0, 8*4(sp)
    lw a1, 9*4(sp)
    lw a2, 10*4(sp)
    lw a3, 11*4(sp)
    lw a4, 12*4(sp)
    lw a5, 13*4(sp)
    lw a6, 14*4(sp)
    lw a7, 15*4(sp)
    addi sp, sp, 16*4
    /* Return from trap */
    mret
    .option pop
