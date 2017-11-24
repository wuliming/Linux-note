#include <stdio.h>
#include <stdlib.h>
void oper(int *arr);
int main()
{	
	static int *arr;
	arr = malloc(4 * sizeof(int));
	arr[3]=2i;
	oper(arr);
	printf("%d \n", arr[3]);
	free(arr);
}

void oper(int *arr)
{
	arr[3]=4;
}
