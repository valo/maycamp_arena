#include <stdio.h>

int main() {
    FILE* f = fopen("/etc/passwd", "rt");
    char line[256];

    while (fgets(line, 256, f)) {
        printf("%s", line);
    }
    fclose(f);
    return 0;
}
