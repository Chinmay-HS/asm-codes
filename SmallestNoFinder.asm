.model small 
.data
array dw 2000h, 1020h, 2030h, 4000h, 6050h
smallno dw 0
msg db 'Smallest number is: $'
newline db 13, 10, '$'

.code
main proc
mov ax, @data
mov ds, ax

; Find smallest number
mov cx, 05
mov si, offset array
mov ax, [si]        
dec cx              

up: 
add si, 2           
cmp ax, [si]        
jbe next            
mov ax, [si]        
next:
loop up

mov smallno, ax     


mov dx, offset msg
mov ah, 09h
int 21h


mov ax, smallno
call display_hex


mov dx, offset newline
mov ah, 09h
int 21h


mov ah, 4ch
int 21h


display_hex proc
push ax
push bx
push cx
push dx

mov bx, ax          
mov cx, 4           

hex_loop:
rol bx, 4           
mov dl, bl          
and dl, 0Fh         
cmp dl, 9           
jbe digit           
add dl, 7           

digit:
add dl, 30h         
mov ah, 02h         
int 21h
loop hex_loop

pop dx
pop cx
pop bx
pop ax
ret
display_hex endp

endp
end main