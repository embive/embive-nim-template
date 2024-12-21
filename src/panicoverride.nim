proc rawoutput*(s: string) = discard

proc panic*(s: string) = 
    ## Panics will simply exit the interpreter (ebreak)
    ## Here we could also make a system call to send the panic info to the host
    asm "ebreak"
