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
}
