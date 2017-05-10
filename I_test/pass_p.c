/* pass pointer to the array as an argument */
#include <stdio.h>
 
/* function declaration */
double getAverage(int *arr, int size);
double getAverage1(int *arr, int size, double *avg);
 
int main () {

   /* an int array with 5 elements */
   int balance[5] = {1000, 2, 3, 17, 50};
 
   /* method 1 */
   double avg;
   avg = getAverage( balance, 5 ) ;
   printf("Average value is: %f\n", avg );

   /* method 2 */
   double avg1;
   printf("the p addr of &avg1 is %p\n", &avg1);
   getAverage1( balance, 5, &avg1 ) ;
   printf("Average value is: %f\n", avg1 );

   /* method 3 */
   double *avg2;
   avg2 = malloc(sizeof(double));
   printf("the p addr of &avg2 is %p\n", &avg2);
   printf("the p addr of avg2 is %p\n", avg2);
   getAverage1( balance, 5, avg2 ) ;
   printf("Average value is: %f\n", *avg2 );
   free(avg2);
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
   //printf("the p addr is %p\n", &avg);
}
