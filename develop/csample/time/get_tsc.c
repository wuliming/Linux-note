#include <stdio.h>

unsigned long long native_read_tsc(void)
{
        unsigned long long val;
        asm volatile("rdtsc":"=A"(val));
        return val;
}

int main()
{
        unsigned long long val;
	unsigned long long val2;

        val =native_read_tsc();
        sleep(2);
        val2 =native_read_tsc();

        //printf ("%lld\t%lld\n", val2, val);
        //printf ("%lld\t%lld\n", val2-val, (val2-val)/1000000);
        printf ("%lld\n",  (val2-val)/1000000);

        return (0);
}

