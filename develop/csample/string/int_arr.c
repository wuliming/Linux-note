#include <stdlib.h>
#include <stdio.h>
#include <string.h>

/*
 * memset need declare #include <string.h> 
 * othewise will export error as follow 
 * " warning: incompatible implicit declaration of built-in function 'memset' [enabled by default]"
 *
 */ 
int main()
{
	int r = 3, c = 4;
	int *arr = (int *)malloc(r * c * sizeof(int));
	int arr1[2];
        //arr1 = (int *)malloc(r * sizeof(int));
	//memset(arr1, 0, sizeof(arr1));

	int i, j, count = 0;
	for (i = 0; i < r; i++)
	for (j = 0; j < c; j++)
		*(arr + i*c + j) = ++count;
	for (i = 0; i < r; i++)
	   // *(arr1 + i) = ++count;  // or as follow
	   arr1[i] = ++count;

	for (i = 0; i < r; i++)
	for (j = 0; j < c; j++)
		printf("%d ", *(arr + i*c + j));
		
	for (i = 0; i < r; i++)
	    //printf("%d ", *(arr1 + i));
	    printf("%d ", arr1[i]);
	printf("\n");
/* Code for further processing and free the 
 * 	dynamically allocated memory */
	free(arr);
//	free(arr1);
	return 0;
}
