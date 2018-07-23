#include<stdio.h>
#include<stdlib.h>

void set(char *buf)
{
   buf[0]=99;
}
int main(){
char **a;
int i, j;
int m=4;
int n=10;
a = (char **)malloc(sizeof(char *) * m);
for(i=0; i<m; i++)
{
	a[i] = (char *)malloc(sizeof(char) * n);
}

printf("%d\n", sizeof(a));
printf("%d\n", sizeof(a[0]));
for(i=0; i<m; i++)
{
   set(a[i]);
     printf(",,,%d\n", a[i][0]);

   /*for(j=0; j<n; j++)
   { 
     a[i][j] =10;
     printf(",,,%d\n", a[i][j]);
   }*/
}
for(i=0; i<m; i++)
{
	free(a[i]);
}
free(a);
}
