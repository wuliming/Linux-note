#include<stdio.h>
#include<stdlib.h>

extern void endless();
int main()
{
	int i = 0, j = 0;
	for (; i < 10000000; i++ )
	{
           j++;
     	}
	endless();
	return 0;
}
