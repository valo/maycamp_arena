#include <cstdio>

int proc(int n) {
  return proc(n + 1) + proc(n + 2);
}

int main() {
  printf("%d\n", proc(1));
  return 0;
}

