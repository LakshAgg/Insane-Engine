#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <unistd.h>
#include <string.h>

char * concat(char *First, char *Second);

void free_all();

char ** alloc;
int allocs = 0;

int main(void)
{
    alloc = malloc(8);

    char *loc = malloc(255);
    printf("Enter the home directory. (Where the location of this directory will be saved, can be anything but choose wisely)\n");
    scanf("%s", loc);
    char *tmp = concat(loc, "Insane-Engine");
    free(loc);
    loc = tmp;
    if (mkdir(loc, 0777) == -1){
        printf("OOPS!\nCould not initialise, make sure that there is no directory name \"Insane-Engine\" in the directory or choose some other directory.\n");
        return 1;
    }
    FILE *f = fopen(concat(loc, "Config.txt"), "w");
    if (f == NULL){
        printf("Something went wrong.");
        return 1;
    }
    loc = malloc(255);
    getcwd(loc, 255);
    fprintf(f, "%s", loc);
    free(loc);

    fclose(f);
    free_all();
}

char * concat(char *First, char *Second){
    if (First == NULL || Second == NULL){
        return "";
    }
    int fl = strlen(First);
    int sl = strlen(Second);
    char *result = malloc(fl + sl + 3);

    int i = 0;
    for (i = 0; i < fl; i++)
    {
        result[i] = First[i];
    }
    result[fl] = '/';
    i += 1;
    for (int b = i; i < fl + sl + 1; i++)
    {
        result[i] = Second[i - b];
    }
    result[fl + sl + 1] = 0;

    alloc = realloc(alloc, 8 * (allocs + 1));
    alloc[allocs] = result;
    allocs = allocs + 1;
    return result;
}

void free_all(){
    for (int i = 0; i < allocs; i++){
        free(alloc[i]);
    }
    free(alloc);
}