#include <stdio.h>  
#include <string.h>  
#include <sys/types.h>  
#include <sys/stat.h>   
#define __USE_GNU 1  
#include <fcntl.h>  
#include <stdint.h>  
  
  
#include <sys/mman.h>  
#include <errno.h>  
  
  
#define READFILE_BUFFER_SIZE 1 * 1024 * 1024  
char fullpath[20]="a.txt";  
  
  
int Deal()  
{  
    int fd = open(fullpath, O_DIRECT|O_CREAT|O_RDWR|O_TRUNC, S_IRUSR|S_IWUSR|S_IRGRP|S_IWGRP|S_IROTH|S_IWOTH);      
    if( fd < 0 ){         
        printf("Fail to open output protocol file: \'%s\'", fullpath);  
        return -1;  
    }  
  
  
    uint32_t bufferLen = (READFILE_BUFFER_SIZE) ;  
    char *buffer = (char *)mmap(0, bufferLen, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0);      
    if ( MAP_FAILED == buffer )  
    {  
        printf("mmap error!errno=%d\n",errno);  
        return -1;  
    }  
    
    printf("mmap first address:%p\n", buffer);  
    uint32_t address=(uint32_t)buffer;  
    printf("address=%u;address%4096=%u\n",address,address%4096); // prove the first adress is align at 4KB  
  
  
    uint32_t pos = 0, len = 0;  
    len = snprintf((char *)(buffer + pos), 128, "*************aA1\n");   
    pos += len;  
  
  
    if( pos ){  
        buffer[pos] = '\0';       
	char c = 'a';   
        printf("pos=%d, buffer=%s, strlen(buffer)=%d\n",pos,buffer, strlen(buffer));  
        //uint32_t wLen = (pos + 511) & ~511U;         
        uint32_t wLen = (c + 511) & ~511U;         
        //uint32_t wLen = (pos + 4095) & ~4095U;         
	printf("wLen=%d\n", wLen);
        //if(write(fd, buffer, wLen) <= 0) {
        if(write(fd, &c, wLen) <= 0) {
		printf("write error\n");
		exit(1);
	}    
        truncate(fullpath, pos);  
    }      
    if( buffer ){  
        munmap(buffer, bufferLen);  
        buffer = NULL;  
    }  
    if( fd > 0 ){     
        close(fd);          
    }  
    return 0;  
}  
  
  
int main()  
{  
    Deal();  
    return 0;  
}  
