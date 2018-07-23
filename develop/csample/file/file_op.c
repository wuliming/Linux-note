#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curses.h>

/* compile method
 * gcc -o op file_op.c -l curses
 *
 *
 */
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
      * - can filter the blank line by "if(strncmp(str, "\n", 1) == 0) continue;" 
      */
     FILE *fp;
     char str[25];
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
     char trace_path[200]="";
     while( fgets(str, sizeof(str), fp) != NULL ) {
         if(strncmp(str, "#", 1) == 0)  continue;
         if(strncmp(str, "[", 1) == 0)  continue;
         if(strncmp(str, "\n", 1) == 0 ||
         strncmp(str, " ", 1) == 0  ||
         strncmp(str, "\t", 1) == 0) continue;
	
         if (sscanf(str, "PATH=%s", trace_path) != 0) {
             printf("trace_path is %s\n", str);
             continue;
         }
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
