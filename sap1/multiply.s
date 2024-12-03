PROGRAM:
    LDA     $VAL
#BEGIN
    STA     $RES
    LDA     $CTR
    SUB     $ONE
    STA     $CTR
    JZ      #END
    LDA     $RES
    ADD     VAL
    JMP     #BEGIN
#END
    LDA     $RES
    OUT
    HLT     

DATA:
    $ONE    C   1
    $RES    D   0
    $VAL    E   8
    $CTR    F   7