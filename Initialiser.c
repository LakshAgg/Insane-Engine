#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
#include <stdlib.h>
#include <unistd.h>

char * concat(char *First, char *Second);

void CreateOthers(char *dir, char *path);

void free_all();

char ** alloc;
int allocs = 0;

int main(int pCount, char *pArgs[]){
    alloc = malloc(0);
    if(pCount != 2){
        printf("USAGE: GameName \n");
        return 1;
    }

    char *b = malloc(255);
    char *fileLocation = concat(getcwd(b, 255), pArgs[1]);
    free(b);

    char *loc = malloc(255);
    printf("Enter the home directory.\n");
    scanf("%s", loc);
    char *tmp = concat(loc, "Insane-Engine");
    free(loc);
    loc = tmp;

    FILE *Config = fopen(concat(loc, "/Config.txt"), "r");
    char *p = malloc(255);
    if (Config == NULL){
        printf("Kindly run configuration file. \n Or make sure the home directory preceeds with a \"/\" sign.\n");
        return 1;
    }
    fscanf(Config, "%s", p);
    fclose(Config);

    mkdir(pArgs[1], 0777);

    tmp = concat(fileLocation, "main.lua");
    FILE *f = fopen(tmp, "w");
    if (f == NULL)
    {
        printf("Something went wrong. If u see it too many times, kindly report to the developer.\n");
        return 1;
    }
    char *data = "require(\"Engine/Engine\")";

    for(int i = 0, l = strlen(data); i < l; i++){
        fwrite(&data[i], sizeof(char), 1, f);
    }

    fclose(f);

    fileLocation = concat(fileLocation, "Engine");
    mkdir(fileLocation, 0777);
    mkdir(concat(fileLocation, "SceneManagement"), 0777);
    mkdir(concat(fileLocation, "GameObjects"), 0777);
    mkdir(concat(fileLocation, "knife"), 0777);
    mkdir(concat(fileLocation, "Anim"), 0777);

    CreateOthers(fileLocation, p);
    free_all();
    free(p);
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

char *files[] = {"Meta.lua", "push.lua", "Engine.lua", "Dependencies.lua", "class.lua", 
    "SceneManagement/Scene.lua", "SceneManagement/SceneManager.lua",
    "GameObjects/GameObject.lua", "GameObjects/UI.lua", 
    "Anim/animation.lua", "Anim/Animator.lua",
    "knife/base.lua", "knife/behavior.lua", "knife/bind.lua", "knife/chain.lua", "knife/convoke.lua", "knife/event.lua", "knife/gun.lua", 
    "knife/memoize.lua", "knife/serialize.lua", "knife/system.lua", "knife/test.lua", "knife/timer.lua",
    "Util.lua"
};

void CreateOthers(char *dir, char *path){
    for (int i = 0; i < 24; i++)
    {
        char *file = concat(dir, files[i]);
        printf("%s\n", file);
        FILE *f = fopen(concat(path, files[i]), "r");
        FILE *dest = fopen(file, "w");
        if (f == NULL){
            printf("Something went wrong.\n");
            if (dest != NULL){
                fclose(dest);
            }
            return;
        }
        if (dest == NULL){
            fclose(f);
            printf("Failed to Copy files.\n");
            return;
        }

        char buffer;
        while(fread(&buffer, sizeof(char), 1, f)){
            fwrite(&buffer, sizeof(char), 1, dest);
        }
        fclose(f);
        fclose(dest);
    }
    printf("\n\n\nAll went well, now you can configure your game settings by modifying Engine/Meta.lua\n");
}