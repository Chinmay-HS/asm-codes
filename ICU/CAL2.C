#include <stdio.h>
#include <conio.h>

void main()
{
    int a, b, choice, result;

    while(1) // infinite loop until user chooses Exit
    {
        printf("\n\n---- Calculator Menu ----");
        printf("\n1. Addition");
        printf("\n2. Subtraction");
        printf("\n3. Multiplication");
        printf("\n4. Division");
        printf("\n5. Exit");
        printf("\nEnter your choice: ");
        scanf("%d", &choice);

        if(choice == 5)
        {
            printf("\nExiting the calculator... Goodbye!");
            break;
        }

        printf("Enter first number: ");
        scanf("%d", &a);
        printf("Enter second number: ");
        scanf("%d", &b);

        switch(choice)
        {
            case 1:
                asm {
                    mov ax, a
                    add ax, b
                    mov result, ax
                }
                printf("Result = %d", result);
                break;

            case 2:
                asm {
                    mov ax, a
                    sub ax, b
                    mov result, ax
                }
                printf("Result = %d", result);
                break;

            case 3:
                asm {
                    mov ax, a
                    mov bx, b
                    imul bx
                    mov result, ax
                }
                printf("Result = %d", result);
                break;

            case 4:
                if(b == 0)
                    printf("Error: Division by zero not allowed!");
                else {
                    asm {
                        mov ax, a
                        mov bx, b
			cwd        //  ; extend AX into DX for division
			idiv bx    //  ; AX = AX / BX
                        mov result, ax
                    }
                    printf("Result = %d", result);
                }
                break;

            default:
                printf("Invalid choice! Please try again.");
        }
    }

    getch();
}
