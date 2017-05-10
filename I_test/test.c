#include <stdio.h> 
#include <stdlib.h>

void sum(int x,int y,int *z)
{
      *z=x+y;
}

int main()   // declare main as int.
{

    int a=10,b=20,*c;
    c=malloc(sizeof(int));    //allocating memory to pointer c 
    sum(a,b,c);
    printf("sum is %d\n",*c);
    free(c);                  //  freeing allocated memory
    return 0;
}
