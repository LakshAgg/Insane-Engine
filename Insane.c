#include "Insane.h"

char ** to_be_freed = NULL;
int to_be_freed_count = 0;

int get_int(char * p)
{
    printf("%s", p);
    int rv = 0;
    scanf("%i", &rv);
    return rv;
}
float get_float(char * p)
{
    printf("%s", p);
    float rv = 0;
    scanf("%f", &rv);
    return rv;
}
double get_double(char * p)
{
    printf("%s", p);
    double rv = 0;
    scanf("%lf", &rv);
    return rv;
}

char * get_string(char *p)
{
    printf("%s", p);
    char *rv = malloc(sizeof(char));
    if (rv == NULL)
    {
        return "";
    }

    int length = 1;

    int buff = 0;
    buff = getchar();
    while (!(buff == EOF || buff == '\n'))
    {
        rv[length - 1] = buff;
        length++;
        rv = realloc(rv, length * sizeof(char));
        buff = getchar();
    }

    rv[length - 1] = 0;
    to_be_freed_count++;
    if (to_be_freed == NULL)
    {
        to_be_freed = malloc(sizeof(char *) * to_be_freed_count);
    }
    else
    {
        to_be_freed = realloc(to_be_freed, sizeof(char*) * to_be_freed_count);
    }
    to_be_freed[to_be_freed_count - 1] = rv;
    return rv;
}

void clean()
{
    for (int i = 0; i < to_be_freed_count; i++)
    {
        free(to_be_freed[i]);
    }
    free(to_be_freed);
}

#if defined (_MSC_VER) // MSVC
    #pragma section(".CRT$XCU",read)
    #define INITIALIZER_(FUNC,PREFIX) \
        static void FUNC(void); \
        __declspec(allocate(".CRT$XCU")) void (*FUNC##_)(void) = FUNC; \
        __pragma(comment(linker,"/include:" PREFIX #FUNC "_")) \
        static void FUNC(void)
    #ifdef _WIN64
        #define INITIALIZER(FUNC) INITIALIZER_(FUNC,"")
    #else
        #define INITIALIZER(FUNC) INITIALIZER_(FUNC,"_")
    #endif
#elif defined (__GNUC__) // GCC, Clang, MinGW
    #define INITIALIZER(FUNC) \
        static void FUNC(void) __attribute__((constructor)); \
        static void FUNC(void)
#else
    #error OOPS\
        Something Unexpected happened
#endif

INITIALIZER(setup)
{
    atexit(clean);
}