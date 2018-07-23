#include <stdlib.h>
#include <stdio.h>
#include <string.h>

/* 1) stack (zhan) > heap (dui) > static uninitialized BSS > static initialized > text segment
 * 2) stack pointer don't need to free. for it's reclaimed by complier automatically
 * 3) global variable is static segment
 * 4) declared by "staic" is static segment
 * 5) local variable is stack
 * 6) malloc is heap
 * a's addr is 0x60104c						-> static initialized
 * *p1's &p1 addr is 0x601058					-> static uninitialized (BSS)
 * b's addr is 0x7fff3f558a2c					-> stack
 * s[]'s addr is 0x7fff3f558a20					-> stack
 * s[]'s s[0] value/ascii is a/0x61				-> ascii
 * s[]'s &s[0] addr is 0x7fff3f558a20, 0x7fff3f558a21		-> stack
 * abc's addr is 0x400915					-> text segment
 * *p2's &p2 addr is 0x7fff3f558a18				-> stack
 * *p3's &p3 addr is 0x7fff3f558a10				-> stack
 * *p3's p3 addr is 0x400941					-> text segment
 * *p3's &(*p3) addr is 0x400941				-> text segment
 * 123456 addr is 0x400941					-> text setment (p3 is the addr of "123456")
 * c addr is 0x601050						-> static initialized
 * &p1 addr is 0x601058						-> BSS
 * p1 addr is 0x1e0e010						-> heap
 * *p1 addr is 0x61						-> ascii
 * &p2 addr is 0x7fff3f558a18					-> stack
 * p2 addr is 0x1e0e030						-> heap
 * &p1 addr is 0x601058						-> static BSS 
 * p1 addr is 0x1e0e010						-> text segment
 * 123456 addr is 0x400941					-> text setment (p3 is the addr of "123456")
 * *p3's p3 addr is 0x400941
 */
int a = 0;			  				// static global initialized variable area
char *p1;							// static BSS global uninitialized variable area


int main()
{
	printf("a's addr is %p\n", &a);				// 0x60104c
	printf("*p1's &p1 addr is %p\n", &p1);			// 0x601058
	printf("*p1's p1 addr is %p\n", p1);			// *p1's p1 addr is (nil)
 
	//printf("*p1's &p1 addr is %p\n", *p1);		// segment error for hasn't allocate memory 
        int b;               					// stack 
	printf("b's addr is %p\n", &b);				// 0x7fff3f558a2c 

        char s[] = "abc";      					// s: stack  "abc": text segment
	printf("s[]'s addr is %p\n", s);			//

	/* 0x61 is not the address, it's ASCII code */
	printf("s[]'s s[0] value/ascii is %c/%p\n", s[0],s[0]);	// %p's output is "0x61"  -> it's ASCII code.  a <-> 61
	printf("s[]'s &s[0] addr is %p, %p\n", &s[0], &s[1]);	//
	printf("abc's addr is %p\n", &"abc");			//

        char *p2;             					// stack
	printf("*p2's &p2 addr is %p\n", &p2);			// 0x7fff3f558a18
        char *p3 = "123456";  					// p3: stack "123456": text segment
	printf("*p3's &p3 addr is %p\n", &p3);			//
	printf("*p3's p3 addr is %p\n", p3);			//
	printf("*p3's &(*p3) addr is %p\n", &(*p3));		//
	printf("123456 addr is %p\n", &("123456"));		//

        static int c =0;    					// static for initialized so together with a. 
	printf("c addr is %p\n", &c);				//

        p1 = (char *)malloc(10);				// heap
	printf("&p1 addr is %p\n", &p1);			// 0x601058
	printf("p1 addr is %p\n", p1);				// 0x1e0e010 ->  p is the address which is pointed
	*p1 = 'a';
	printf("*p1 addr is %p\n", *p1);			//

        p2 = (char *)malloc(20); 				// heap
	printf("&p2 addr is %p\n", &p2);			// 0x7fff3f558a18
	printf("p2 addr is %p\n", p2);				// 0x1e0e030

        strcpy(p1, "123456");    				// 
	printf("&p1 addr is %p\n", &p1);			//
	printf("p1 addr is %p\n", p1);				// p is the address which is pointed
	printf("123456 addr is %p\n", &("123456"));		//
	printf("*p3's p3 addr is %p\n", p3);			//
	
	free(p1);
	free(p2);
	//free(p3);						// segment error. for it's stack memory. don't need to free. will reclaim by compiler. 

        int ar[3]={1,2,3};	
        int * num;
	//num = (int *)malloc(sizeof(int));
        num = &ar[1];
        printf("%d\n", *num);

        /* follow can work in linux ,but it's not correct
	 *
	 */
        int * num1;
        *num1 = ar[2];	
        printf("%d\n", *num1);
	
        return 0;
}
