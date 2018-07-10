/* this sample can insert one struct instance
 * into struct list
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    int id;
    char name[10];
} info;


static info list[] = {
    {1, "wlm"},
    {2, "wlm1"},
    {3, "wlm2"},
};

static info *list1;
info *tab;
info *pinfo;

int main(int *argc, int args[])
{
    info *inf ;
    int i = 0;
    int num = (sizeof(list)/sizeof(list[0]));

    tab = (info *)malloc(sizeof(info) * 9);  /* 3 + 1 + 5 = 9 elements */
    memcpy(tab, list, sizeof(list));

    /* add one item at last of struct list */
    pinfo = &tab[num];
    inf = (info *)malloc(sizeof(info));
    inf->id = 4;
    strcpy(inf->name, "wlm3");

    memcpy(pinfo, inf, sizeof(info));
    for (i=0; i<4; i++)
    {
        printf("%s\n", tab[i].name); 
    }


    /* add multi items at last of struct list */
    pinfo += 1; 
    char tmp[10];
    list1 = (info *)malloc(sizeof(info) * 5);
     
    for(i=0; i<5; i++)
    {
         char str[4] = "wlm";
         list1[i].id = 5 + i;
         sprintf(tmp, "%d", (5 + i));
         tmp[sizeof(tmp)-1] = '\0';
         strcpy(list1[i].name, strcat(str, tmp)); /* strcat will return the string start address */
         memcpy(pinfo, &list1[i], sizeof(list1[i]));
         pinfo += 1;
    }
    printf("==================\n");
    for (i=0; i<9; i++)
    {
        printf("%s\n", tab[i].name); 
    }
    printf("==================\n");
    for (i=0; i<9; i++)
    {
        printf("%s\n", pinfo[i].name); 
    }
}
