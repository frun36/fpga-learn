# SAP-1
This is my first FPGA project - an implementation of a CPU, based on the SAP-1.

The development was greatly assisted by [this blog post](https://austinmorlan.com/posts/fpga_computer_sap1/), with some enhancements of the architecture inspired by [Ben Eater's videos](https://www.youtube.com/playlist?list=PLowKtXNTBypGqImE405J2565dvjafglHU).

The current instruction set is:
- `NOP = 0` - no operation
- `LDA = 1` - load content of memory at specified address to register A
- `ADD = 2` - add value from register B to A
- `SUB = 3` - add value from register B from A
- `STA = 4` - store A at specified address in memory
- `LDI = 5` - load specified value (4b) to A
- `JMP = 6` - jumps to specified address
- `OUT = E` - store A in OUT register (display)
- `HLT = F` - halts the processor
