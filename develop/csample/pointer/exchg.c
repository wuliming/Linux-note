#include <stdlib.h>
#include <stdio.h>
/* value transfer */
void Exchg1(int x, int y)
{
   int tmp;
   tmp = x;
   x = y;
   y = tmp;
   printf("x = %d, y = %d\n", x, y);
}

/* address transfer */
void Exchg2(int *px, int *py)
{
   int tmp = *px;
   *px = *py;
   *py = tmp;
   printf("*px = %d, *py = %d.\n", *px, *py);
}
/*
 * expected ‘;’, ‘,’ or ‘)’ before ‘&’ token
 * for there is quotation transfer at c. but there is at c++.
 */
/*void Exchg3(int &x, int &y)
{
   int tmp = x;
   x = y;
   y = tmp;
   printf("x = %d,y = %d\n", x, y);
}*/

main()
{
   int a = 4,b = 6;
   Exchg1(a, b);			// output: 6, 4
   printf("a = %d, b = %d\n", a, b);	// output: 4, 6

   a = 4;
   b = 6;
   Exchg2(&a, &b);			// output: 6, 4
   printf("a = %d, b = %d.\n", a, b);	// output: 6, 4

   a = 4;
   b = 6;
   //Exchg3(a, b);
   //printf("a = %d, b = %d\n", a, b);
   return(0);
}
