#include <stdio.h>
#include <stdlib.h>

int main(int *args, int argv[])
{
    int cluster = 10;
    int item = 1001;
    int out = 0;
    printf("%d\n", ((cluster)&0xfff));
    printf("%d\n", ((cluster)&0xfff<<10));
    printf("%d\n", ((item)&0x3ff));

    out = ((((cluster)&0xfff)<<10)|((item)&0x3ff));
    printf("%d\n", out);

}
