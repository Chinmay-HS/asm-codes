#include <stdio.h>
#include <conio.h>

void main()
{
    int num, i, fact = 1;

    printf("Enter a number: ");
    scanf("%d", &num);

    for(i = 1; i <= num; i++)
    {
        asm {
	    mov ax, fact //  ; load fact
	    mov bx, i     // ; load i
	    imul bx       // ; ax = ax * bx
	    mov fact, ax  // ; store back result
	}
    }

    printf("Factorial of %d is: %d", num, fact);

    getch();
}

