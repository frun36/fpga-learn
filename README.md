# SAP-1
This is my first FPGA project - an implementation of a CPU, based on the SAP-1.

The development was greatly assisted by [this blog post](https://austinmorlan.com/posts/fpga_computer_sap1/), with some enhancements of the architecture inspired by [Ben Eater's videos](https://www.youtube.com/playlist?list=PLowKtXNTBypGqImE405J2565dvjafglHU).

The current instruction set is:
- `LDA = 0` - load content of memory at specified address to register A
- `ADD = 1` - add value from register B to A
- `SUB = 2` - add value from register B from A
- `STA = 3` - stores A at specified address in memory
- `JMP = 4` - jumps to specified address
- `HLT = F` - halts the processor
