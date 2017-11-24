
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/time.h>
#include <time.h>
#include <string.h>
 
#define SIZE 10*1024*1024
int main(int argc, char** argv)
{
	 char c = 'a';
         int i;
         char *pmap;
         int fd;
         char *mem;
         struct timeval t1, t2;
         long spend_us;
         fd = open("disk_file", O_RDWR);
         if(fd < 0){
                   perror("open mmap_file");
                   return -1;
         }
         pmap = (char *)mmap(NULL, sizeof(char) * SIZE, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
         if(pmap == MAP_FAILED){
                   perror("mmap");
                   return -1;
         }
         gettimeofday(&t1, NULL);
         for(i = 0; i < SIZE; i++)
         {
                   memcpy(pmap + i, &c, 1);
         }
         gettimeofday(&t2, NULL);
         spend_us = 1000000 * (t2.tv_sec - t1.tv_sec) + (t2.tv_usec - t1.tv_usec);
         printf("write mmap file,spend time:%ld us\n", spend_us);
         close(fd);
         munmap(pmap, sizeof(char) * SIZE);
         mem = (char *)malloc(sizeof(char) * SIZE);
         if(!mem)
         {
                   printf("mem malloc error!\n");
                   return -1;
         }
         gettimeofday(&t1, NULL);
         for(i = 0; i < SIZE; i++)
         {
                   memcpy(mem + i, &c, 1);
         }
         gettimeofday(&t2, NULL);
         spend_us = 1000000 * (t2.tv_sec - t1.tv_sec) + (t2.tv_usec - t1.tv_usec);
         printf("write mem,spend time:%ld us\n", spend_us);
         free(mem);
         return 0;
}
