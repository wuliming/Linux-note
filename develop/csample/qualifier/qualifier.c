#include <stdio.h>
#include <stdlib.h>

/*
 * - array[X]
 *   X must be constant value, can't define as variable
 * - static
 * - const
 *   const value can't not be reassigned value, otherwise error as follow
 *   error: assignment of read-only variable 'count'
 */
static count = 3;
int value[count];
int main(int *argc, int args[])
{
    count = 5;
    int i = 0;
    for (i = 0; i < count; i++)
    {
       value[i] = i;
       printf("%d \n", value[i]);
    }
}
