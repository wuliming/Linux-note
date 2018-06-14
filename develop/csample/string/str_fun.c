#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int main(int args, char *argv[])
{
    /* sscanf
     * 1. input is string
     * 2. can get the specified substring
     * 3. * is used to filter the string 
     */
    char *s = "hello : world@";
    char buf[40];
    sscanf(s, "%*s%*s%s", buf);
    printf("%s\n", buf);
    sscanf(s, "%*[^:]%[^@]", buf);
    printf("%s\n", buf);

    /* strncmp(char *a, char *b, size_t n)
     * 0: until '\0' a is same with b
     * >0: a' asscii > b' asscii
     */
    char *a = "ab";
    char *b = "AB";
    int c = 0;
    c = strncmp(a, b, 2);
    printf("ab(%d) - AB(%d) = %d\n", *a, *b, c);

    /* strcat
     * strcat("wlm", "1")  X   for must define variable to add other string
     * strcat(src1,  "1")  O
     * strcat(src1, src2)  O
     *
     */
    char concatenate[40];
    char concatenate_1[20]="wlm";
    memset(concatenate, '\0', sizeof(concatenate));
    strcpy(concatenate, strcat(concatenate_1, "1"));
    printf("%s\n", concatenate);
    
    /* strcpy 
     * 
     */
    char dest[100];
    char *src1;
    src1 = (char *)malloc(sizeof(char) * 10);
    strcpy(src1, "wlm");
    src1[sizeof(src1)-1] = '\0';
    char src2[5]="ll"; 
    memset(dest, '\0', sizeof(dest));
    strcpy(dest, strcat(src1, src2));

    printf("Final copied string : %s\n", dest);
}
