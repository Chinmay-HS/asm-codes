#include <stdio.h>
#include <conio.h>

void main()
{
    int n, i, num, sum = 0;

    printf("Enter how many numbers you want to add: ");
    scanf("%d", &n);

    for(i = 1; i <= n; i++)
    {
        printf("Enter number %d: ", i);
        scanf("%d", &num);

        asm {
            mov ax, sum   ; move current sum to AX
            add ax, num   ; add current input number
            mov sum, ax   ; store result back in sum
        }
    }

    printf("\nSum of %d numbers is: %d", n, sum);

    getch();
}
