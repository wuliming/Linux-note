#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>

int
main (int argc, char *argv[])
{
        if (argc != 2)
                exit (0);

        size_t mb = strtoul(argv[1],NULL,0);

        size_t nbytes = mb * 0x100000;
        char *ptr = (char *) malloc(nbytes);
        if (ptr == NULL){
                perror("malloc");
                exit (EXIT_FAILURE);
        }

        size_t i;
        const size_t stride = sysconf(_SC_PAGE_SIZE);
        for (i = 0;i < nbytes; i+= stride) {
                ptr[i] = 0;
        }

        printf("allocated %d mb\n", mb);
        pause();
        return 0;
}
