/*
 * Copyright (c) 2018  wulm.
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation; either version 2 of the License, or (at your
 * option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
 * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
 * for more details.
 */
#include <dirent.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <linux/perf_event.h>
#include <asm/unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TRACE_SIZE 100 
#define LENGTH 1024
#define NAME_LEN 50

/* group_fd 
 * EX: 4 cpu will have 4 groups
 * the first item of group is the leader fd.
 * you can get the group fds by the leader fd when read() fd.
 *
 *
 */

/* USAGE
 * # gcc -o kvm kvm_trace
 * ./kvm $interval $count
 */
static int trace_count = 0;
//char *trace_name[TRACE_SIZE];

long perf_event_open(struct perf_event_attr *kvm_event, pid_t pid,
                int cpu, int group_fd, unsigned long flags)
{
    int ret;
    ret = syscall(__NR_perf_event_open, kvm_event, pid, cpu, group_fd, flags);
    return ret;
}

int perf_event(int cpus, int *group_fd, char * trace_name[TRACE_SIZE])
{
    int sts = 0;
    struct perf_event_attr pe;
    FILE *pFile = NULL;
    char temp[LENGTH] = {0};
    int fd = 0;
    int ret,  cpu;
    int flag; 
    memset(&pe, 0, sizeof(struct perf_event_attr));
    pe.type = PERF_TYPE_TRACEPOINT;
    pe.size = sizeof(struct perf_event_attr);
    pe.sample_type = PERF_SAMPLE_RAW | PERF_SAMPLE_TIME | PERF_SAMPLE_CPU;
    pe.sample_period = 1;
    pe.read_format = PERF_FORMAT_GROUP; 
    DIR *kvm_dir;
    struct dirent *de;
    int offset = 0;    
    char path[LENGTH];
    int i = 0;

    snprintf(path, sizeof(path),  "/sys/kernel/debug/tracing/events/kvm/");
    path[sizeof(path)-1] = '\0';

    if ((kvm_dir = opendir(path)) == NULL)
        sts=1;

    for(cpu = 0; cpu < cpus ; cpu++) {
        flag = 0;
        group_fd[cpu] = -1;
        while ((de = readdir(kvm_dir)) != NULL) {
            if (offset == 0)
                offset = telldir(kvm_dir);
            if (!strncmp(de->d_name, ".", 1))
                continue;
            if (!strncmp(de->d_name, "enable", 6) || !strncmp(de->d_name, "filter", 6))
                continue;
            for (i = 0; i < trace_count; i ++)
            {
            if (!strcmp(de->d_name, trace_name[i]))
            {
            sprintf(path, "/sys/kernel/debug/tracing/events/kvm/%s/id", de->d_name);
            pFile = fopen(path, "r");
            pe.config = atoi(fgets(temp, sizeof(temp), pFile));
            fclose(pFile);
            fd = perf_event_open(&pe, -1, cpu, group_fd[cpu], 0);	     
	    //printf("path and fd is %s %d %d\n", path, fd, group_fd[cpu]);
            if (fd == -1) {
		printf("perf_event_open error!\n");
	        sts = 1;
            }
            if (flag == 0) {
                group_fd[cpu] = fd;
		//printf("======%d\n", group_fd[cpu]);
                flag = 1;
            }
            if(ioctl(fd, PERF_EVENT_IOC_RESET, 0) == -1 ||
                ioctl(fd, PERF_EVENT_IOC_ENABLE, 0) == -1)
                fprintf(stderr,"ioctl failed 'PERF_EVENT_IOC_ENABLE'.");
            /*if(cpu == 0) {
                 strcpy(trace_name[trace_count], de->d_name);
                 trace_count++;
            }*/
            }
            }
        }
        seekdir(kvm_dir, offset);
    }
    closedir(kvm_dir);
    return sts;
}

int main(int args, char *argv[])
{
    int cpus=0;
    int i, j, sts;
    char       *envpath;
    static int *group_fd;
    long long  **trace_values;
    long long tmp_values[TRACE_SIZE] = {0};
    char * trace_name[TRACE_SIZE];
    char str[100];
    FILE *fp;
    if ((fp = fopen("trace_kvm.conf", "rt")) == NULL)
    {
         printf("can't open file\n");
         exit(1);
    }

    while (fgets(str, sizeof(str), fp) != NULL)
    {
        trace_name[trace_count] = (char *)malloc(sizeof(char));
        str[strlen(str) - 1] = '\0';
        strcpy(trace_name[trace_count], str);
        trace_count ++;
    }
    if ((envpath = getenv("LINUX_NCPUS")))
        cpus = atoi(envpath);
    else
        cpus = sysconf(_SC_NPROCESSORS_CONF);

    printf("cpus is %d\n", cpus);
  
    group_fd = malloc(cpus * sizeof(int));
    sts = perf_event(cpus, group_fd,  trace_name);
    trace_values  = (long long **)malloc(cpus * sizeof(long long *));
    for (i = 0; i < cpus; i ++) {
        trace_values[i] = (long long *)malloc(trace_count * sizeof(long long));
        memset(trace_values[i], 0, trace_count * sizeof(trace_values[i]));
    }
    memset(tmp_values, 0, sizeof(tmp_values));

    /* set monitor interval */
    int interval = atoi(argv[1]);
    /* set run duration */
    int duration = atoi(argv[2]);
    int sec = 0;
    

    while(sec < duration) {
        sleep(interval);
        for(i = 0; i < cpus; i++) {
            if(read(group_fd[i], tmp_values, sizeof(tmp_values)) <= 0)
            {
                fprintf(stderr, "Read fd error.\n");
            }
            for(j = 0; j < trace_count; j++) { 
                trace_values[i][j] = tmp_values[j+1];
            }
            memset(tmp_values, 0, sizeof(tmp_values));
        }
        
        for (i=0; i < cpus; i++)
        {
            if (i == 0)  printf("%30s\t%s%7d\t", "", "cpu", i);
            else if (i == (cpus -1)) printf("%s%7d\n", "cpu", i);
            else         printf("%s%7d\t", "cpu", i);
        }
        for(j = 0; j < trace_count; j++) {
            for (i=0; i < cpus; i++) {
                if (i == 0) 
                    printf("%30s\t %10lld\t", trace_name[j], trace_values[i][j]);
                else if (i == (cpus -1))
                    printf("%10lld\n",trace_values[i][j]);
                else
                    printf("%10lld\t",trace_values[i][j]);
            }
        } 
        sec++;
   }
   //        if(ioctl(fd, PERF_EVENT_IOC_DISABLE, 0) == -1)
   //             fprintf(stderr,"ioctl failed 'PERF_EVENT_IOC_ENABLE'.");
   free(trace_values);
   free(group_fd); 
   return sts;
}
