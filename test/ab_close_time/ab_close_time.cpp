#include <iostream>
#include <ctime>
using namespace std;

int main(){
	int a, b;
  clock_t start = clock();
	while(cin >> a >> b){
		cout << a + b << endl;
	}
	
  while ((clock() - start) < 0.9 * CLOCKS_PER_SEC);
	return 0;
}
