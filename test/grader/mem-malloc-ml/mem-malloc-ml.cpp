#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main() {
  int *arr = (int*)malloc(1024 * 512 * sizeof(int));
  memset(arr, 0, 1024 * 512 * sizeof(int));
  arr[0] = 0;
  arr[1] = 1;
  for (int i = 2;i < 512;i++) {
    arr[i] = arr[i - 1] + arr[i - 2];
  }
  
  printf("%d", arr[511]);
  return 0;
}
