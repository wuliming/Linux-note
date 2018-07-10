#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curses.h>

int main(int *argc, int args[])
{
    /* rt	read text
     * wt	write text
     * at	append text at last of file
     * rb	read binary
     * wb	write binary
     * ab	append binary
     * rt+	read/write text file
     * wt+	read/write/generate text file
     * at+	read/write/append text file
     * rb+	read/write binary file
     * wb+	read/write/generate binary file
     * ab+	read/write/append binary file
     */

     /*
      * fgets
      * - dest will have '\n', if you want delete the '\n' can do as fllow
      *   str[strlen(str) - 1] = '\0';
      * - return vale last character is '\0', so don't need add '\0'.
      */
     FILE *fp;
     char str[15];
     char **arr;
     int count = 0;
     int i;
     if((fp=fopen("test.txt","rt"))==NULL)
     {
           printf("Cannot open file strike any key exit!");
           getch();
           exit(1);
     }
     arr = (char **)malloc(sizeof(char *) * 6);
     while( fgets(str, sizeof(str), fp) != NULL ) {
         arr[count] = (char *)malloc(sizeof(char)); 
         str[strlen(str) - 1] = '\0'; 
         strcpy(arr[count], str);
         printf("%s <-%d--> %s, %d\n", str, count, arr[count], sizeof(arr));
         count ++;
     }
     for (i = 0; i < count; i++ )
     {
         printf("%s=\n", arr[i]);
     }
     fclose(fp);
}
