/*                                                                              
 * Shared data being modified by two threads [?running on different CPUs?].     
 */                                                                             
                                                                                
                                                                                
#ifndef RESULT                                                                  
#undef  RESULT        /* Shall we print? change #undef into #define here or compile */  
#endif                /* with -DRESULT for printing the assigned values             */                               
                                                                                
#define _GNU_SOURCE   /* required: for clone flags / GNU clone wrapper */       
#include <stdio.h>    /* required: for the added print statements */            
#include <sched.h>    /* required: clone function protype */                    
#include <stdlib.h>   /* required: for return added to function and main */     
#include <sys/mman.h> /* for mmap allocating stack space for the child */       
                                                                                
int main(void) { /* NEW wrapper main() */                                       
                                                                                
/*                                                                              
 * Shared structure between two threads remains unchanged (non optimized)       
 * This is required in order to collect some samples for the L2_LINES_IN event. 
 */                                                                             
struct shared_data_nonalign {                                                   
    unsigned int num_proc1;                                                     
    char padding[28];
    unsigned int num_proc2;                                                     
};                                                                              
                                                                                
/* shared structure between two threads which will be optimized later*/         
struct shared_data_align {                                                      
    unsigned int num_proc1;                                                     
    unsigned int num_proc2;                                                     
};                                                                              
                                                                                
/*                                                                              
 * In the example program below, the parent process creates a clone             
 * thread sharing its memory space. The parent thread running on one CPU        
 * increments the num_proc1 element of the common and common_aln. The cloned    
 * thread running on another CPU increments the value of num_proc2 element of   
 * the common and common_aln structure.                                         
 */                                                                             
/* Declare global data */                                                        
struct shared_data_nonalign common_aln;                                         
                                                                               
/* NEW: It seemed a good idea to initialize data to avoid random outcome */     
common_aln.num_proc1 = 0;                                                       
common_aln.num_proc2 = 0;                                                       
                                                                                
/*Declare local shared data */                                                  
struct shared_data_align common;                                                
                                                                                
/* NEW: See previous */                                                         
common.num_proc1 = 0;                                                           
common.num_proc2 = 0;                                                           
                                                                                
/*                                                                              
 * The routine below is called by the cloned thread, to increment the num_proc2 
 * element of common and common_aln structure in loop.                          
*/                                                                             
int func1(void *com)                                                            
{                                                                               
    /* NEW: clone expects a void pointer for the function argument, so the      
     *      argument was defined as void * and added was a local pointer     
     *      inside the function body, that addresses the void *arg as a         
     *      struct shared_data_align pointer, which effectively functions       
     *      as a cast of the void parameter.                                         
     */                                                                         
    int i, j;                                                                   
    struct shared_data_align *ncom = com;         /* point to void parameter */ 
                                                                                
    /* Increment the value of num_proc2 in loop */                              
    for (j = 0; j < 200; j++)                 /* there are so many ways to   */ 
        for (i = 0; i < 100000; i++) {        /* assign a value to a var...  */ 
            ncom->num_proc2++;                                                  
        }                                                                       
                                                                                
    /* Increment the value of num_proc2 in loop */                              
    for (j = 0; j < 200; j++)                                                   
        for (i = 0; i < 100000; i++) {                                          
            common_aln.num_proc2++;                                             
        }                                           

                                                                                
    return 0;                    /* function of type int must return int */     
}                                                                               
                                                                                
/* NEW: Added mmap to allocate stack space for the child to pass to clone       
 *      The stack parameter for the child is called 'buff' in the example.      
 *                                                                              
 *      From the clone man page:                                                
 *                                                                              
 *      " Since the child and calling process may share memory, it is not       
 *        possible for the child process to execute in the same stack as        
 *        the calling process. The calling process must therefore set up        
 *        memory space for the child stack and pass a pointer to this space     
 *        to clone()"                                                           
 *      Also see the reference to mmap question on stack overflow.                                                               
 */                                                                             
                                                                                
/* Now clone a thread sharing memory space with the parent process */           
                                                                                
int pid, i=0,j=0; /* NEW */                                                     
void *buff;       /* stack */                                                   
                                                                                
/* See http://stackoverflow.com/questions/1083172/\                             
 *  * how-to-mmap-the-stack-for-the-clone-system-call-on-linux */                  
void *start =(void *) 0x0000010000000000;                                       
size_t len =          0x0000000000200000; /* grows with */                      
                                                                                
/* The flags for mmap are tailored to stack allocation */                       
if((buff = mmap(start, len, PROT_WRITE|PROT_READ,                               
                            MAP_PRIVATE|MAP_GROWSDOWN|MAP_FIXED|MAP_ANONYMOUS,  
                             -1,0)) == MAP_FAILED)                              
{                                                                               
    perror("mmap");                                                             
    exit(-1);                                                                   
}

if ((pid = clone(func1, buff+len, CLONE_VM, &common)) < 0)                      
{                                                                               
    perror("clone");                                                            
    exit(1);                                                                    
} else {                                                                        
    printf("Cloned a thread with pid %d\n", pid);                               
}                                                                               
                                                                                
/* Increment the value of num_proc1 in loop */                                  
for (j = 0; j < 200; j++)                                                       
    for(i = 0; i < 100000; i++) {                                               
        common.num_proc1++; /* 200*100000, would be... one moment please...*/   
    }                                                                           
                                                                                
/* Increment the value of num_proc1 in loop */                                  
for (j = 0; j < 200; j++)                                                       
    for(i = 0; i < 100000; i++) {                                               
        common_aln.num_proc1++;                                                 
    }                                                                           
                                                                                
#ifdef RESULT                                                                   
printf("common.num_proc1 is: %d\n", common.num_proc1);                          
printf("common.num_proc2 is: %d\n", common.num_proc2);                          
                                                                                
printf("common_aln.num_proc1 is: %d\n", common_aln.num_proc1);                  
printf("common_aln.num_proc2 is: %d\n", common_aln.num_proc2);                  
#endif                                                                          
                                                                                
printf(">>> 42 <<<\n");     
                                                                                
	return 0;                                                                       
}
