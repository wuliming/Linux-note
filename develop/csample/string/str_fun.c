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
}
