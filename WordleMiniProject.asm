.MODEL SMALL
.STACK 100H

.DATA
    ; Game data
    SECRET_WORD     DB 'OCEAN'      ; The word to guess (no $ here)
    GUESS_WORD      DB 6 DUP(0)     ; User's guess buffer
    ATTEMPTS        DB 0             ; Current attempt number
    MAX_ATTEMPTS    DB 6             ; Maximum attempts allowed
    
    ; Display messages
    TITLE_MSG       DB 'WORD PUZZLE GAME - Guess the 5-letter word!', 0DH, 0AH, '$'
    PROMPT_MSG      DB 'Enter your 5-letter guess: $'
    WIN_MSG         DB 0DH, 0AH, 'Congratulations! You won!', 0DH, 0AH, '$'
    LOSE_MSG        DB 0DH, 0AH, 'Game Over! The word was: $'
    ATTEMPT_MSG     DB 0DH, 0AH, 'Attempt $'
    OF_MSG          DB ' of $'
    NEWLINE         DB 0DH, 0AH, '$'
    FEEDBACK_MSG    DB 'Your guess: $'
    
    ; Color codes for feedback
    GREEN_COLOR     EQU 2AH         ; Green background, black text
    YELLOW_COLOR    EQU 6EH         ; Yellow background, black text  
    RED_COLOR       EQU 4FH         ; Red background, white text
    NORMAL_COLOR    EQU 07H         ; Normal white on black

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    ; Set initial video mode
    MOV AH, 0
    MOV AL, 3           ; 80x25 color text mode
    INT 10H
    
    ; Display title
    MOV AH, 9
    LEA DX, TITLE_MSG
    INT 21H

GAME_LOOP:
    ; Check if max attempts reached
    MOV AL, ATTEMPTS
    CMP AL, MAX_ATTEMPTS
    JAE GAME_OVER
    
    ; Display current attempt number
    CALL DISPLAY_ATTEMPT_NUMBER
    
    ; Get user input
    CALL GET_USER_INPUT
    
    ; Display feedback
    CALL DISPLAY_FEEDBACK
    
    ; Check the guess
    CALL CHECK_GUESS
    
    ; Check if won
    CMP AL, 1
    JE GAME_WON
    
    ; Increment attempts
    INC ATTEMPTS
    
    ; Continue game loop
    JMP GAME_LOOP

GAME_WON:
    MOV AH, 9
    LEA DX, WIN_MSG
    INT 21H
    JMP END_GAME

GAME_OVER:
    MOV AH, 9
    LEA DX, LOSE_MSG
    INT 21H
    
    ; Display the secret word
    MOV CX, 5
    LEA SI, SECRET_WORD
    DISPLAY_SECRET:
        MOV DL, [SI]
        MOV AH, 2
        INT 21H
        INC SI
        LOOP DISPLAY_SECRET
    
    MOV AH, 9
    LEA DX, NEWLINE
    INT 21H

END_GAME:
    ; Wait for any key
    MOV AH, 9
    MOV DX, OFFSET NEWLINE
    ADD DX, 2           ; Skip CR LF, point to "Press any key..."
    ; Actually, let's just add a simple message
    MOV AH, 0           ; Wait for key
    INT 16H
    
    ; Exit program
    MOV AH, 4CH
    INT 21H

MAIN ENDP

; Display current attempt number
DISPLAY_ATTEMPT_NUMBER PROC
    MOV AH, 9
    LEA DX, ATTEMPT_MSG
    INT 21H
    
    MOV AL, ATTEMPTS
    INC AL              ; Display attempts starting from 1
    ADD AL, '0'         ; Convert to ASCII
    MOV DL, AL
    MOV AH, 2
    INT 21H
    
    MOV AH, 9
    LEA DX, OF_MSG
    INT 21H
    
    MOV AL, MAX_ATTEMPTS
    ADD AL, '0'
    MOV DL, AL
    MOV AH, 2
    INT 21H
    
    MOV AH, 9
    LEA DX, NEWLINE
    INT 21H
    RET
DISPLAY_ATTEMPT_NUMBER ENDP

; Get user input procedure - fixed version
GET_USER_INPUT PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH SI
    
    ; Clear the guess buffer first
    LEA SI, GUESS_WORD
    MOV CX, 6
    CLEAR_BUFFER:
        MOV BYTE PTR [SI], 0
        INC SI
        LOOP CLEAR_BUFFER
    
    ; Display prompt
    MOV AH, 9
    LEA DX, PROMPT_MSG
    INT 21H
    
    ; Get exactly 5 characters
    LEA SI, GUESS_WORD
    MOV CX, 5
    
    INPUT_LOOP:
        ; Get character without echo first
        MOV AH, 8           ; Get character without echo
        INT 21H
        
        ; Check if it's a letter
        CMP AL, 'A'
        JL INPUT_LOOP       ; If less than 'A', get another char
        CMP AL, 'Z'
        JLE VALID_UPPER     ; If A-Z, it's valid
        
        CMP AL, 'a'
        JL INPUT_LOOP       ; If between Z and a, invalid
        CMP AL, 'z'
        JG INPUT_LOOP       ; If greater than z, invalid
        
        ; Convert lowercase to uppercase
        SUB AL, 32
        
    VALID_UPPER:
        ; Store the character
        MOV [SI], AL
        
        ; Echo the character
        MOV DL, AL
        MOV AH, 2
        INT 21H
        
        ; Move to next position
        INC SI
        LOOP INPUT_LOOP
    
    ; Add newline after input
    MOV AH, 9
    LEA DX, NEWLINE
    INT 21H
    
    POP SI
    POP CX
    POP BX
    POP AX
    RET
GET_USER_INPUT ENDP

; Display feedback with colors
DISPLAY_FEEDBACK PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    
    MOV AH, 9
    LEA DX, FEEDBACK_MSG
    INT 21H
    
    ; Process each character
    LEA SI, GUESS_WORD
    MOV CX, 5
    
    FEEDBACK_LOOP:
        PUSH CX
        PUSH SI
        
        ; Get current guess character
        MOV AL, [SI]
        
        ; Determine color based on position and correctness
        CALL GET_CHAR_COLOR
        
        ; Set text attribute
        MOV AH, 09H         ; Write character and attribute
        MOV BH, 0           ; Page 0
        MOV BL, AL          ; Color returned from GET_CHAR_COLOR
        MOV AL, [SI]        ; Character to display
        MOV CX, 1           ; Display 1 character
        INT 10H
        
        ; Move cursor forward
        MOV AH, 03H         ; Get cursor position
        MOV BH, 0
        INT 10H
        INC DL              ; Move cursor right
        MOV AH, 02H         ; Set cursor position
        INT 10H
        
        POP SI
        POP CX
        INC SI
        LOOP FEEDBACK_LOOP
    
    ; Reset to normal color and add newline
    MOV AH, 09H
    MOV AL, ' '
    MOV BH, 0
    MOV BL, NORMAL_COLOR
    MOV CX, 1
    INT 10H
    
    MOV AH, 9
    LEA DX, NEWLINE
    INT 21H
    
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
DISPLAY_FEEDBACK ENDP

; Get color for character based on correctness
; Input: SI points to current character in guess
; Output: AL contains color attribute
GET_CHAR_COLOR PROC
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH DI
    PUSH SI
    
    ; Calculate position in guess (0-4)
    MOV BX, SI
    SUB BX, OFFSET GUESS_WORD
    
    ; Check if character is in correct position
    LEA DI, SECRET_WORD
    ADD DI, BX
    MOV AL, [SI]        ; Guess character
    MOV AH, [DI]        ; Secret character at same position
    
    CMP AL, AH
    JE CORRECT_POSITION
    
    ; Check if character exists elsewhere in secret word
    LEA DI, SECRET_WORD
    MOV CX, 5
    
    SEARCH_SECRET:
        CMP AL, [DI]
        JE WRONG_POSITION
        INC DI
        LOOP SEARCH_SECRET
    
    ; Character not found - wrong letter
    MOV AL, RED_COLOR
    JMP COLOR_END
    
CORRECT_POSITION:
    MOV AL, GREEN_COLOR
    JMP COLOR_END
    
WRONG_POSITION:
    MOV AL, YELLOW_COLOR
    
COLOR_END:
    POP SI
    POP DI
    POP DX
    POP CX
    POP BX
    RET
GET_CHAR_COLOR ENDP

; Check if guess is correct
CHECK_GUESS PROC
    PUSH BX
    PUSH CX
    PUSH SI
    PUSH DI
    
    LEA SI, GUESS_WORD
    LEA DI, SECRET_WORD
    MOV CX, 5
    MOV BX, 0           ; Correct counter
    
    CHECK_LOOP:
        MOV AL, [SI]
        MOV AH, [DI]
        CMP AL, AH
        JNE NOT_MATCH
        INC BX
        
    NOT_MATCH:
        INC SI
        INC DI
        LOOP CHECK_LOOP
    
    ; Check if all 5 characters match
    CMP BX, 5
    JE ALL_CORRECT
    MOV AL, 0           ; Not all correct
    JMP CHECK_END
    
ALL_CORRECT:
    MOV AL, 1           ; All correct
    
CHECK_END:
    POP DI
    POP SI
    POP CX
    POP BX
    RET
CHECK_GUESS ENDP

END MAIN