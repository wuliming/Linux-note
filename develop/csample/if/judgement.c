#include <stdio.h>
#include <stdlib.h>

/*
 * 1. switch
 *    switch(A)
 *      case B:
 *        ...
 *        break;
 *   A: must be interger variable
 *   B: must be integer constant 
 *   - ERROR: a label can only be part of a statement and a declaration is not a statement
 *     for statement is after case, so will show this error. 
 *     you must move it before case.
 */
int main(int args, char * argv[])
{
    switch (atoi(argv[1])) {
        int i = 0;
        for (i = 0; i < 3; i ++) {
        case 1:
            printf("===\n");
        break;
        }
    }
}
