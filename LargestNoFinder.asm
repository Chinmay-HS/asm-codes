.model small   
.data
array db 04h,05h,02h,09h,01h
largeno db 0 

.code
mov ax, @data
mov ds, ax

mov cl, 05
mov si, offset array
mov al, [si]
dec cl

up:
    inc si
    cmp al, [si]
    jnc next
    mov al,[si]
    next:
        loop up
        mov largeno, al
        
add al, 30h
mov dl, al 
mov ah, 02h
int 21h
    
mov ah, 4ch
int 21h
ends
end