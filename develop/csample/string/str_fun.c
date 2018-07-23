#include <stdlib.h>
#include <stdio.h>
#include <string.h>
/* output
 * world@
 * : world
 * ab(97) - AB(65) = 32
 * wlm1
 * Final copied string : wlmll
 * cpu 2 cpu 2
 */
int main(int args, char *argv[])
{
    /* sscanf
     * 1. input is string
     * 2. can get the specified substring
     * 3. * is used to filter the string 
     */
    char *s = "hello : world@";
    char buf[40];
    char *buf1 = "wlm";
    // filter the first and second string, get third string
    sscanf(s, "%*s%*s%s", buf); 
    printf("%s\n", buf);
    sscanf(s, "%*[^:]%[^@]", buf);
    printf("%s\n", buf);
    // filter the first string, get the second string
    sscanf(s, "%*s%s", buf);
    printf("%s\n", buf);
    sscanf(s, "hello :%s", buf);
    printf("%s\n", buf);
    //sscanf(s, "hello :%s", &buf1);  <- error segment
    //printf("%s\n", buf1);

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

    /* 
     * pmsprintf
     */
    char *pm;
    char pm1[6];
    pm = (char *)malloc(sizeof(char));
    int cpu = 2;
    sprintf(pm, "cpu %d", cpu);
    sprintf(pm1, "cpu %d", cpu);
    printf("%s %s \n", pm, pm1);
}
