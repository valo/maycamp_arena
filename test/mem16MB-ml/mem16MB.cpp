#include <iostream>
#include <cstring>
using namespace std;

int foo[4500000];

int main () {
  int a;
  int b;
  memset(foo, 0, sizeof(foo));
  cin >> a >> b;
  cout << (a + b) << endl;
  return 0;
}
