.model small
.stack
.data

M1 DB 10,13, "Enter string 1: $"
M2 DB 10,13, "Length of string 1: $"
M3 DB 10,13, "Display String 1: $"

M4 DB 10,13, "Enter string 2: $"
M5 DB 10,13, "Length of string 2: $"
M6 DB 10,13, "Display String 2: $"

MEQ DB 10,13, "Strings are equal$"
MNE DB 10,13, "Strings are not equal$"

STR1 DB 50,?,50 DUP(?)
STR2 DB 50,?,50 DUP(?)
L1 DB ?
L2 DB ?


.CODE
    DISP MACRO XX
        MOV AH, 09
        LEA DX, XX
        INT 21H
    ENDM

.STARTUP
    DISP M1 ;ENTER STRING 1
    MOV AH, 0AH ; Take input of the whole string together
    LEA DX, STR1
    INT 21H

    DISP M2 ;Length of the string 1
    LEA SI, STR1+1
    MOV CL,[SI]
    MOV L1,CL;
    ADD CL, 30H
    MOV DL, CL
    MOV AH, 02
    INT 21H

    DISP M3 ;Display string 1
    LEA SI, STR1+2
    MOV CL, L1
    
BACK1:
        MOV DL,[SI]
        MOV AH, 02
        INT 21H
        INC SI
        DEC CL
        JNZ BACK1

    DISP M4 ;ENTER STRING 2
    MOV AH, 0AH ; Take input of the whole string together
    LEA DX, STR2
    INT 21H

    DISP M5 ;Length of the string 2
    LEA SI, STR2+1
    MOV CL,[SI]
    MOV L2,CL;
    ADD CL, 30H
    MOV DL, CL
    MOV AH, 02
    INT 21H

    DISP M6 ;Display string 2
    LEA SI, STR2+2
    MOV CL, L2
    
BACK2:
        MOV DL,[SI]
        MOV AH, 02
        INT 21H
        INC SI
        DEC CL
        JNZ BACK2

MOV AL, L1
CMP AL, L2
JNE NOTEQUAL ; Lenght mismatch

LEA SI, STR1+2
LEA DI, STR2+2
MOV CL, L1

CMP_LOOP:
    MOV AL, [SI]
    CMP AL, [DI]
    JNE NOTEQUAL
    INC SI
    INC DI
    DEC CL
    JNZ CMP_LOOP

    ; If reached here => Equal
    DISP MEQ
    JMP EXIT

NOTEQUAL:
    DISP MNE

EXIT:
.EXIT
END