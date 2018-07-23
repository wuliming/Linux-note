/* pass pointer to the array as an argument */
#include <stdio.h>
#include <stdlib.h>
 
/* function declaration */
double getAverage(int *arr, int size);
double getAverage1(int *arr, int size, double *avg);
double getAverage2(int *arr, int size, double **avg);
/* output as follow
# ./transfer
Average value is: 214.400000
the p addr of &avg1 is 0x7ffece740da8
Average value is: 214.400000
the p addr of &avg2 is 0x7ffece740da0
the p addr of avg2 is 0x1c61010
Average value is: 214.400000

*/ 
int main () {

   /* an int array with 5 elements */
   static int balance[5] = {1000, 2, 3, 17, 50};
 
   /* function 1 */
   printf("------------function 1 -----------\n");
   double avg;
   avg = getAverage(balance, 5 ) ;
   printf("Average value is: %f\n", avg );

   /* function 2 */
   printf("------------function 2 -----------\n");
   double avg1;
   printf("the p addr of &avg1 is %p\n", &avg1);
   getAverage1( balance, 5, &avg1 ) ;
   printf("Average value is: %f\n", avg1 );

   printf("------------function 3 -----------\n");
   /* function 3 */
   double *avg2;
   avg2 = (double *)malloc(sizeof(double));
   printf("the p addr of &avg2 is %p\n", &avg2);
   printf("the p addr of avg2 is %p\n", avg2);
   getAverage1( balance, 5, avg2 ) ;
   printf("Average value is: %f\n", *avg2 );
   free(avg2);

   /* function 4 */
   printf("------------function 4 -----------\n");
   double *avg3;
   printf("the p addr of &avg3 is %p\n", &avg3);
   getAverage2( balance, 5, &avg3 ) ;
   printf("the p addr of &avg3 is %p\n", &avg3);
   printf("Average3 value is: %f\n", *avg3 );
   free(avg3);
   return 0;
}

double getAverage(int *arr, int size) {

   int  i, sum = 0;       
   double avg;          
 
   for (i = 0; i < size; ++i) {
      sum += arr[i];
   }
 
   avg = (double)sum / size;
   return avg;
}

double getAverage1(int *arr, int size, double *avg) {

   int  i, sum = 0;       
 
   for (i = 0; i < size; ++i) {
      sum += arr[i];
   }
 
   *avg = (double)sum / size;
   printf("the p addr is %p\n", &avg);
   printf("the *avg addr is %f\n", *avg);
}

double getAverage2(int *arr, int size, double **avg) {

   int  i, sum = 0;       
   *avg = (double *)malloc(sizeof(double ));
   for (i = 0; i < size; ++i) {
      sum += arr[i];
   }
 
   **avg = (double)sum / size;
   printf("the &avg and addr is %p %p\n", &avg, avg);
   printf("the **avg addr is %f\n", **avg);
}
