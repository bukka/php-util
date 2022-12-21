#include <stdio.h>
#include <unistd.h>

int main()
{
    int old_stderr;
    dup2(old_stderr, 2);
    close(2);
    while (1) {
        sleep(1);
    }
}