#include <stdio.h>
#include <conio.h>

void main()
{
    int n, a = 0, b = 1, c, i;

    printf("Enter number of terms: ");
    scanf("%d", &n);

    printf("Fibonacci Series: ");

    printf("%d %d ", a, b);  // print first two terms

    for(i = 3; i <= n; i++)
    {
        asm {
            mov ax, a     ; AX = a
            mov bx, b     ; BX = b
            add ax, bx    ; AX = a + b
            mov c, ax     ; store result in c
        }

        printf("%d ", c);

        // update a and b for next iteration
        asm {
            mov ax, b     ; AX = b
            mov a, ax     ; a = b
            mov bx, c     ; BX = c
            mov b, bx     ; b = c
        }
    }

    getch();
    clrscr();
}
