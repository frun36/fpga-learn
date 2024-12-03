PROGRAM:
    LDA     F
    ADD     E
    STA     E
    JC      A
    OUT
    ADD     F
    STA     F
    JC      A
    OUT
    JMP     1
    HLT

DATA:
    E       0
    F       1