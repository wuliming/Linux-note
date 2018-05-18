#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <sys/ioctl.h>
#include <linux/perf_event.h>
#include <asm/unistd.h>

#include <time.h>
#include <fcntl.h>
#include <sys/file.h>
#include <sys/time.h>
#include <assert.h>
#include <stdint.h>
#include <sys/syscall.h>
#include <linux/unistd.h>



#define PID_NUM 176139
int Core_id=-1;

static long
perf_event_open(struct perf_event_attr *hw_event, pid_t pid,
                int cpu, int group_fd, unsigned long flags)
{
    int ret;
    ret = syscall(__NR_perf_event_open, hw_event, pid, cpu,
                   group_fd, flags);
    return ret;
}


/* Setup info for perf_event */
struct perf_event_attr attr[2];


int
main(int argc, char **argv)
{
    int pid,core_id,i,rc;
    uint64_t val1[2],val2[2];
    if(argc==1) {
        printf("please add pid number\n");
        return -1;
    }
    for(pid=i=0;argv[1][i]!=0;i++){
        if(argv[1][i]<'0'||argv[1][i]>'9') {
            printf("illegal pid number\n");
            return -1;
        }
        pid=pid*10+argv[1][i]-'0';
    }
    printf("%d\n",pid);
    struct perf_event_attr pe;
    long long count,cycles,instructions;
    double ipc;
    int fd[2];

    core_id=Core_id;
    cycles=instructions=0;
    memset(&pe, 0, sizeof(struct perf_event_attr));

    attr[0].type = PERF_TYPE_HARDWARE;
    attr[0].config = PERF_COUNT_HW_CPU_CYCLES; /* generic PMU event*/
    attr[0].disabled = 0;
    fd[0] = perf_event_open(&attr[0], pid , core_id, -1, 0);
    if (fd[0] < 0) {
            perror("Opening performance counter");
    }

    attr[1].type = PERF_TYPE_HARDWARE;
    attr[1].config = PERF_COUNT_HW_INSTRUCTIONS; /* generic PMU event*/
    attr[1].disabled = 0;
    fd[1] = perf_event_open(&attr[1], pid , core_id, -1, 0);
    if (fd[1] < 0) {
            perror("Opening performance counter");
    }


    /* count cycles,instructions; */
    //asm volatile("nop;"); // pseudo-barrier
    rc = read(fd[0], &val1[0], sizeof(val1[0]));  assert(rc);
    rc = read(fd[1], &val1[1], sizeof(val1[1]));  assert(rc);
    //asm volatile("nop;"); // pseudo-barrier
    printf("round 1:cycles =  %lld instructions=  %lld\n",val1[0],val1[1]);

    //usleep(100000);
    sleep(1);
    //asm volatile("nop;"); // pseudo-barrier
    rc = read(fd[0], &val2[0], sizeof(val2[0]));  assert(rc);
    rc = read(fd[1], &val2[1], sizeof(val2[1]));  assert(rc);
    //asm volatile("nop;"); // pseudo-barrier
    printf("round 2:cycles =  %lld instructions=  %lld\n",val2[0],val2[1]);
    cycles= val2[0]-val1[0];
    instructions= val2[1]-val1[1];
    ipc=(double)instructions/(double)cycles;

    close(fd[0]);
    close(fd[1]);
    printf("cycles =  %lld  instructions =  %lld  IPC=%f\n ",cycles ,instructions,ipc);
    return 0 ;

}

