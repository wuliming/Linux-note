#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <sys/resource.h>
#include <sys/ioctl.h>
#include <linux/perf_event.h>
#include <asm/unistd.h>
#include <linux/hw_breakpoint.h>

long perf_event_open(struct perf_event_attr *kvm_event, pid_t pid,
                int cpu, int group_fd, unsigned long flags)
{
    int ret;
    ret = syscall(__NR_perf_event_open, kvm_event, pid, cpu,
                   group_fd, flags);
    return ret;
}
int main(int args, char *argv[])
{
    struct perf_event_attr pe;
    struct rlimit rlptr;
    long long count[2];
    long long values[87] = {0};
    int i, j, flag, number, k, ret;
    int group_fd[2];
    int fd[2];
    //char *filters[] = {"exit_reason==43","exit_reason==30","exit_reason==54","exit_reason==18","exit_reason==20","exit_reason==40","exit_reason==39","exit_reason==14","exit_reason==29","exit_reason==25","exit_reason==21","exit_reason==22","exit_reason==0","exit_reason==10","exit_reason==16","exit_reason==55","exit_reason==32","exit_reason==7","exit_reason==33","exit_reason==8","exit_reason==31","exit_reason==41","exit_reason==23","exit_reason==19","exit_reason==15","exit_reason==44","exit_reason==2","exit_reason==26","exit_reason==12","exit_reason==27","exit_reason==36","exit_reason==24","exit_reason==48","exit_reason==9","exit_reason==49","exit_reason==1","exit_reason==28"};
    memset(&pe, 0, sizeof(struct perf_event_attr));
    pe.type = PERF_TYPE_TRACEPOINT;
    pe.size = sizeof(struct perf_event_attr);
    pe.sample_type = PERF_SAMPLE_RAW | PERF_SAMPLE_TIME | PERF_SAMPLE_CPU;
    pe.sample_period = 1;
    //pe.read_format = PERF_FORMAT_GROUP; 
    //rlptr.rlim_cur = 2000;
    //rlptr.rlim_max = 2000;
    setrlimit(RLIMIT_NOFILE, &rlptr);
    printf("===\n");
    pe.config = 1443;
    fd[0] = perf_event_open(&pe, -1, 0, -1, 0);
	printf("fd is %d\n", fd[0]);
    fd[1] = perf_event_open(&pe, -1, 1, -1, 0);
	printf("fd1 is %d\n", fd[1]);

    if (fd[0] == -1 || fd[1] == -1) 
    {
       fprintf(stderr, "Error opening leader %d\n", pe.config);
       exit(EXIT_FAILURE);
    }
    //ret = ioctl(fd[0], 0x00002400, 0);
    //ret = ioctl(fd[1], 0x00002400, 0);
    ioctl(fd[0], PERF_EVENT_IOC_RESET, 0);
    ioctl(fd[1], PERF_EVENT_IOC_RESET, 0);
    ioctl(fd[0], PERF_EVENT_IOC_ENABLE, 0);
    ioctl(fd[1], PERF_EVENT_IOC_ENABLE, 0);
    if( ret == -1 )
        fprintf(stderr,"ioctl failed ret = %d\n", ret);

    printf("--------\n");
    printf("-----duration is %s-----\n", argv[1]);
    int duration = atoi(argv[1]);
    int sec=0;
    while(sec < duration)
    {
        sleep(1);
        //ioctl(fd, 0x00002401, 0);
        //ioctl(fd, PERF_EVENT_IOC_DISABLE, 0);
        read(fd[0], &count[0], sizeof(count[0]));
        read(fd[1], &count[1], sizeof(count[1]));
        printf("number is %10lld\6 %10lld\n", count[0], count[1] );
        sec++;
    }
        ioctl(fd[0], PERF_EVENT_IOC_DISABLE, 0);
        ioctl(fd[1], PERF_EVENT_IOC_DISABLE, 0);
    return 0;
}
