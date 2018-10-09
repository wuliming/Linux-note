#include <stdlib.h>
#include <stdio.h>

int main(int *argc, char argv[])
{
    char *envpath, *cpu, *pcp;
    envpath = getenv("XFS_STATSPATH");
    cpu = getenv("LINUX_NCPUS");
    pcp = getenv("pcp");
    printf("%s %s %s\n", envpath, cpu, pcp);
}
