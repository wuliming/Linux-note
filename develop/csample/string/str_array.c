#include<stdio.h>
#include<stdlib.h>
#include<string.h>

void set_str(char **str)
// or void set_str(char *str[4])
{ 
   int i=0;
   char *p = "XXXXX";
   for(i; i<4; i++)
    strcpy(str[i], p);	// don't use str[i] = point, maybe lost in process.
}

int main(void)
{
    /*
     *1. if you don't want to define the maxlenth of string, can do as follow.
     * char * test[5] = {"1111", "2222", "3333", "4444", "5555ddddd"};
     * test[5] the '5' is the number of elements
     * the point is the point of context
     *
     *2. define the 2 dimension
     * char str[3][20] = {"aaa", "xxxxxx", "pppp"};
     * 3 is the count fo elements
     * 20 is the maxlenth of the element
     * can't puts(str[0][1]). for str[0][1] is char.
     * just can printf("%c\n", str[0][1]. 
     * so you had better to use *str[3] to define string array.
     *
     *3. when int can reference 
     * https://www.geeksforgeeks.org/dynamically-allocate-2d-array-c/
     * -------------------------------------------
     * fix strcpy/malloc/strlen incompatible 
     * #include <string.h>
     */
    char * test[5] = {"1111", "2222", "3333", "4444", "5555"};
    char * (*p)[5] = &test;
    puts(test[0]);
    puts(p[0][0]);
    printf("%s\n", p[0][1]);

    /*
     * 1. when set_str, don't use str[i] = $point, maybe lost.
     */
    int i=0;
    char * string[4];
    for(i; i<4; i++)
    {
        string[i] = (char *)malloc(sizeof(char));
    }
    set_str(string);
    puts(string[1]);
    puts(string[0]);
    puts(string[2]);
    puts(string[3]);
    
    char * array[6];
    for(i=0; i<6; i++)
    {
        array[i] = (char *)malloc(sizeof(char));
    }
    strcpy(array[5], "pppp");
    puts(array[5]);

    char str[3][3] = {"aaa", "bbb", "ccc"};
    char str1[][3] = {"111", "222", "333"};
    puts(str[0]);  /* output is aaabbbccc */
    puts(str1[0]); /* output is 111222333 */
    //puts(str[0][2]);  segment error.
    //printf("%s\n",  &str[0][0]);
    printf("%c\n",  &str[0][0]);
   
    /* insert data into 2 dimension array
     * first must allocate the memory for pointed dimension
     */
    printf("insert data into 2 dimension array. first must allocate the memory for pointed dimension.\n");
    char *twodim_arr[5];
    for(i=0; i<5; i++)
    {
        twodim_arr[i] = (char *)malloc(sizeof(char));
    }
    char tmp1[5];
    //memset(twodim_arr, '\0', sizeof(twodim_arr));
    for(i=0; i<(sizeof(twodim_arr)/sizeof(twodim_arr[0])); i++)
    //for(i=0; i<5; i++)
    {
        char tmp[10]="wlm";
        sprintf(tmp1, "%d", i); 
        twodim_arr[i]=strcat(tmp, tmp1);
        printf("%s\n", twodim_arr[i]);
    } 

    /* define dynamic 2 dimension array 
     * strcpy(dynamic[i],strcat(dyn, tmp1));	O
     * dynamic[i] = strcat(dyn, tmp1);		X (forbidden absolutely) 
     * */
    printf("define dynamic 2 dimension array by **dynamic,\n \
 you need to allocate memory for 2 dimensino.\n");
    char **dynamic;
    
    dynamic = (char **)malloc(sizeof(char*) * 5);
    for(i=0; i<5; i++)
    {
        char dyn[10]="dynamic";
        //dynamic = (char **)malloc(sizeof(char*) * 10);
        dynamic[i] = (char *)malloc(sizeof(char));
        sprintf(tmp1, "%d", i);
        strncpy(dynamic[i], strcat(dyn, tmp1), sizeof(dynamic[i] - 1));
        printf("dyn is: %s\n", dynamic[i]);
    }
    
    for(i=0; i<5; i++)
    {
        printf("dyn is: %s\n", dynamic[i]);
        free(dynamic[i]);
    }
    free(dynamic);

    /* support string point initialization as follow */
    char *str_t = "/var/lib";
    printf("%s\n", str_t);
}
