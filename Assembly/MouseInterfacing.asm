.MODEL SMALL
.STACK
.DATA 
M1 DB 10, 13, "MOUSE IS PRESENT $" 
M2 DB 10, 13, "LEFT $" 
M3 DB 10, 13, "RIGHT $" 

.CODE 
DISP MACRO XX  
MOV AH,09 
LEA DX, XX 
INT 21H 
ENDM 
 
.STARTUP 
MOV AX, 0000              
INT 33H                    
CMP AX, 00 
JE LAST 
DISP M1 
 
MOV AX, 0004              
MOV CX, 0 
MOV DX, 0 
INT 33H 
 
MOV AX, 0007 
MOV CX, 0FFH 
MOV DX, 0FFH 
INT 33H 
 
MOV AX, 0008 
MOV CX, 0000 
MOV DX, 010H 
INT 33H 
 
P:                              
MOV AX, 0001                    
INT 33H 
 
MOV AX, 0003                  
INT 33H 
 
CMP BX, 01H                    
JE NEXT 
JMP NEXT1 
 
NEXT: 
MOV AX, 0011H 
INT 10H 
 
MOV AX, 0003                
INT 33H 
 
MOV AH, 0CH 
INT 10H 
 
 
NEXT1: 
MOV AX, 0001 
INT 33H 
 
MOV AX, 0003 
INT 33H 
 
CMP BX, 02H 
JE LAST 
JMP P 
 
LAST: 
MOV AX, 00 
INT 10H 
 
.EXIT 
END 
