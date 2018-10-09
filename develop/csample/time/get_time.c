#include <stdio.h>
#include <stdlib.h>
#include <sys/times.h>
#include <time.h>
#include <unistd.h>

/* 
1) output is as follow
   elapsed time is 0.08 secs, but user time is only 0.01 sec.
   for it other time is used by grep's IO operations.
   elapsed:   0.08 secs
   parent times
           user CPU:   0.00 secs
           sys CPU:   0.00 secs
   child times
           user CPU:   0.01 secs
           sys CPU:   0.00 secs
2) tms's time is relative time(ticks). can get the real time through _SC_CLK_TCK 
*/
void doit(char *, clock_t);

int main(void)
{
    clock_t  start, end;
    struct tms t_start, t_end;
    start = times(&t_start);
    system("grep the /usr/share/doc/* > /dev/null ");
    end=times(&t_end);

    doit("elapsed", end - start);

    puts("parent times");
    doit("\tuser CPU", t_end.tms_utime);
    doit("\tsys CPU",  t_end.tms_stime);

    puts("child times");
    doit("\tuser CPU", t_end.tms_cutime);
    doit("\tsys CPU", t_end.tms_cstime);

    exit(EXIT_SUCCESS);

}

void doit(char *str, clock_t time)
{
    /* Get clock ticks/second */
    long tps = sysconf(_SC_CLK_TCK);
    printf("%s: %6.2f secs(tps:%ld) \n", str, (float)time/tps, tps);
}
