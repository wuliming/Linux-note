/*******************************************************************
 * This tool can bind your program to each cpu
 * 
 * v0.2
 * Written by Xu Gang <xug@cn.fujitsu.com>
 *
 * Todo
 *  - Support run program with parameter
 *  - Support quiet mode
 *  - Support specify cpu# to bind 
 *
 ********************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/sysinfo.h>
#include <sys/mman.h>
#include <unistd.h>
#define  __USE_GNU
#include <sched.h>
#include <ctype.h>
#include <string.h>

/* Create some pretty boolean types and definitions */
typedef int bool;
#define TRUE  1
#define FALSE 0

int NUM_PROCS;

/* Method Declarations */
void usage(char *selfname);	/* Simple generic usage function */
bool bind(int cpuid, int pid);	/* Bind cpu */
bool check(int pid);	/* check cpu bin status */
bool bind_and_run(int numthreads, char *program, int cpubegin);	/* Bind cpu and run new program */

int main(int argc, char **argv)
{
	int return_code = FALSE;

	/* Determine the actual number of processors */
	NUM_PROCS = sysconf(_SC_NPROCESSORS_CONF);
	/*printf("System has %i processor(s).\n", NUM_PROCS); */

	/* These need same defaults, because the values will be used unless overriden */
	/*int num_cpus_to_spin = NUM_PROCS; */
	/* Use only one cpu by default */
	int num_cpus_to_spin = 1;

	char *program_name = "";

	/* Start from first cpu by default */
	int begin_cpu = 0;

	int target_pid = 0;

	/* Check for user specified parameters */
	int option = 0;
	while ((option = getopt(argc, argv, "r:p:n:b:c?")) != -1) {
		switch (option) {

		case 'r':	/* specify program you want to run */
			program_name = optarg;
			if (access(optarg, R_OK) < 0) {
				printf("Open error for %s\n",
				       program_name);
				exit(0);
			}

			if (access(optarg, X_OK) < 0) {
				printf("Excute error for %s\n",
				       program_name);
				exit(0);
			}
			break;

		case 'p':	/* specify PID of process you want to set affinity */
			target_pid = atoi(optarg);
			if (target_pid <= 0) {
				printf("PID must > 0\n");
				exit(0);
			}
			break;

		case 'b':	/* start from cpuid */
			begin_cpu = atoi(optarg);
			if (begin_cpu < 0 || begin_cpu > (NUM_PROCS - num_cpus_to_spin)) {
				printf("Error: wrong CPUID: %d\n",
				       begin_cpu);
				exit(0);
			}
			/*printf("Skip %d cpu\n", begin_cpu); */
			break;

		case 'c':	/* Get cpu status of process */
			if (strlen(program_name) != 0){
				printf("Error: -c option can't use with -r\n");
				exit(0);
			}
			check(target_pid);
			break;

		case 'n':	/* specify num cpus to make busy */
			num_cpus_to_spin = atoi(optarg);
			if (num_cpus_to_spin < 1) {
				printf
				    ("WARNING: Must utilize at least 1 cpu. Spinning "
				     " all %i cpu(s) instead...\n",
				     NUM_PROCS);
				num_cpus_to_spin = 1;
			} else if (num_cpus_to_spin > NUM_PROCS) {
				printf("WARNING: %i cpu(s), are not "
				       "available on this system, spinning all %i cpu(s) "
				       "instead...\n", num_cpus_to_spin,
				       NUM_PROCS);
				num_cpus_to_spin = NUM_PROCS;
			} else {
				/*printf("Maxing computation on %i cpu(s)...\n",
				   num_cpus_to_spin); */
			}
			break;

		case '?':
			usage(argv[0]);
			exit(0);
			break;

		default:
			usage(argv[0]);
			exit(0);
		}
	}

	if (argc == 1) {
		usage(argv[0]);
		exit(0);
	}
	
	/* Must specify -r or -p argument */
	if (strlen(program_name) == 0 && target_pid == 0) {
		usage(argv[0]);
		exit(0);
	}

	if (target_pid > 0) {
		/* Bind running process to cpu*/
		bind(begin_cpu, target_pid);
	}
	else{
		/* Bind cpu and run new program */
		bind_and_run(num_cpus_to_spin, program_name, begin_cpu);
	}

	return return_code;
}


/* This method simply prints the usage information for this program */
void usage(char *selfname)
{
	printf
	    ("Usage: %s <-r PROGRAM_TO_RUN [-p PID_OF_PROCESS]> [-n NUM_MULTIPROCESS] [-b BIND_ON_CPUID] [-c]\n", selfname);
	printf("  -r  run program\n");
	printf("  -n  use with -r, set num of multiprocess\n");
	printf("  -p  specify the PID of process\n");
	printf("  -b  specify cpuid to bind on, cpu index start from 0\n");
	printf("      if you want to bind to first cpu, use \"-b 0\" \n");
	printf("  -c  use with -p, check cpuid info of process\n");
	printf("\nExample:\n");
	printf("  %s -r /path/file -n 3 -b 0\n", selfname);
	printf("  Run /path/file 3 times and bind them on cpu0(the first cpu), cpu1, cpu2\n\n");
	printf("  %s -p 3212 -b 1\n", selfname);
	printf("  Bind process that pid is 3212 on cpu1(the second cpu)\n\n");
        printf("  %s -p 3212 -c\n", selfname);
        printf("  Check cpuid status of process\n");

	return;
}


bool bind(int cpuid, int pid)
{
	int ret = TRUE;
	cpu_set_t mask;

	/* CPU_ZERO initializes all the bits in the mask to zero. */
	CPU_ZERO(&mask);

	/* CPU_SET sets only the bit corresponding to cpu. */
	CPU_SET(cpuid, &mask);

	/* sched_setaffinity returns 0 in success */
	if (sched_setaffinity(pid, sizeof(mask), &mask) == -1) {
		printf("WARNING: Could not set CPU Affinity, continuing...\n");
		ret = FALSE;
	}

	return ret;
}

bool check(int pid)
{
	int ret = TRUE, i;
	cpu_set_t mycpuid;

	if (sched_getaffinity(pid, sizeof(mycpuid), &mycpuid) == -1) {
		printf("WARNING: Could not get CPU Affinity, continuing...");
		ret = FALSE;
	}

	for (i = 0; i < NUM_PROCS; i++)
	{
		if (CPU_ISSET(i, &mycpuid))
			printf("Process %d is running on processor : %d\n", pid, i);
	}

	return ret;
}

/* This method creates the threads and sets the affinity. */
bool bind_and_run(int numthreads, char *program, int cpubegin)
{
	int ret = TRUE;
	int created_thread = 0;

	/* We need a thread for each cpu we have... */
	while (created_thread < numthreads - 1) {
		int mypid = fork();

		if (mypid == 0) {	/* Child process */
			/*printf("\tCreating Child Thread: #%i\n", created_thread); */
			break;
		}

		else {		/* Only parent executes this */

			/* Continue looping until we spawned enough threads! */
			    ;
			created_thread++;
		}
	}

	/* NOTE: All threads execute code from here down! */

	bind(created_thread + cpubegin, 0);

	int sys_ret = system(program);

	return ret;
}
