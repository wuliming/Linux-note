#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]) {
        
	unsigned long nSizeInChar = atoi(argv[1]);
        int type;
        if (argv[2] == NULL)  type = 0;
        else type = atoi(argv[2]);
        long size = 0;
        long loop;
	printf("need allocated MEM(KB) is : %d\n", nSizeInChar);
        switch(type) {
        case 1:
	loop = (int) (nSizeInChar/4);
        size = 4096;
        break;
        case 2:
	loop = (int) (nSizeInChar/1024);
        size = 1048576;
        break;
        case 3:
	loop = (int) (nSizeInChar/1024/2);
        size = 1048576 * 2;
        break;
        case 4:
	loop = (int) (nSizeInChar/1024/4);
        size = 1048576 * 4;
        break;
        case 5:
	loop = (int) (nSizeInChar/1024/1024);
        size = 1073741824;
        break;
        }
	printf("loop times is : %d\n", loop);
	printf("allocate size is : %d Byte\n", size);
	
	//char *pMemData[loop];
	long i=0;
	for (i = 0; i < loop; i++)
	{
            char *pMemData;
            pMemData = (char *)malloc(sizeof(char) * size);
            memset(pMemData , 0x41 , size);
            if (argv[3] != NULL) usleep(atoi(argv[3]));
	}
	while (1)
	{
		sleep(10000);
	}

	return 0;
}

