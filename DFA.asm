name "dfa_demo"
org 100h

jmp start

; ========================
; DFA_A_Mnem Procedure
; ========================
DFA_A_Mnem proc near
    cmp     byte ptr es:[di], 'A'
    jne     Fail
    cmp     byte ptr es:[di+1], 'A'
    je      DoAA
    cmp     byte ptr es:[di+1], 'D'
    je      DoAD
    cmp     byte ptr es:[di+1], 'N'
    je      DoAN
Fail:   clc
        ret

DoAN:   cmp     byte ptr es:[di+2], 'D'
        jne     Fail
Succeed:add     di, 3
        stc
        ret

DoAD:   cmp     byte ptr es:[di+2], 'D'
        je      Succeed
        cmp     byte ptr es:[di+2], 'C'
        je      Succeed
        clc
        ret

DoAA:   cmp     byte ptr es:[di+2], 'A'
        je      Succeed
        cmp     byte ptr es:[di+2], 'D'
        je      Succeed
        cmp     byte ptr es:[di+2], 'M'
        je      Succeed
        cmp     byte ptr es:[di+2], 'S'
        je      Succeed
        clc
        ret
DFA_A_Mnem endp

; ========================
; DATA
; ========================
msg_prompt db "Enter mnemonic (3 letters): $"
msg_success db 0Dh,0Ah, "Valid mnemonic!",0Dh,0Ah,"$"
msg_fail    db 0Dh,0Ah, "Invalid mnemonic!",0Dh,0Ah,"$"
input_buf   db 20 dup('$')    ; buffer for input

; ========================
; CODE
; ========================
start:
    mov ax, cs
    mov ds, ax
    mov es, ax

    ; show prompt
    mov ah, 09h
    mov dx, offset msg_prompt
    int 21h

    ; read 3 chars
    mov si, offset input_buf
    mov cx, 3
read_loop:
    mov ah, 01h
    int 21h            ; read char into AL
    mov [si], al
    inc si
    loop read_loop

    ; point DI to input string
    lea di, input_buf

    ; call DFA
    call DFA_A_Mnem

    ; check carry flag
    jc success
    jmp fail

success:
    mov ah, 09h
    mov dx, offset msg_success
    int 21h
    jmp done

fail2:
    mov ah, 09h
    mov dx, offset msg_fail
    int 21h

done:
    mov ah, 4Ch
    int 21h
