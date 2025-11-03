#include <stdio.h>
#include <conio.h>

void main()
{
    int num, square, cube;

    printf("Enter a number: ");
    scanf("%d", &num);

    // Calculate square using assembly
    asm {
        mov ax, num     //; move number into AX
        mov bx, ax      //; copy AX to BX
        imul bx         //; AX = AX * BX (square)
        mov square, ax  //; store result in square
    }

    // Calculate cube using assembly
    asm {
        mov ax, num     //; move number into AX
        mov bx, ax      //; copy AX to BX
        imul bx         //; AX = AX * BX (square)
        mov cx, ax      //; store AX (square) in CX
        mov ax, num     //; reload AX with original number
        imul cx         //; AX = AX * CX (cube)
        mov cube, ax    //; store result in cube
    }

    printf("Square is: %d\n", square);
    printf("Cube is: %d\n", cube);

    getch();
}
