#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#define MAX_THREAD 3000
int main()
{
    int status,i,pid;
    for(i=0; i<MAX_THREAD; i++)
    {
	 status=fork();
	 if(status==0||status==-1)
	 {
     		break;
	 }
    } 
    if(status==-1)
    {   
	printf("ERROR\n");
	exit(-1); 
    }
    else if(status==0)  // child process
    {
	 sleep(100);
    }
    else // parent process
    {
    }
    return 0;
}
