#include <stdio.h>
#include <unistd.h>

int main() {
  while (1) {
    if (fork()) {
    } else {
      printf("Created a child...");
    }
  }
  return 0;
}