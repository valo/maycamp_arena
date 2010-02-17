#include <cstdlib>
using namespace std;

int main(){
	*((int*)0) = 5;
	system("sleep 60");
	return 0;
}
