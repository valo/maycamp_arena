#include <iostream>
#include <sstream>
#include <vector>
#include <string>
#include <algorithm>
using namespace std;

int main(){
	string line;
	while(getline(cin, line)){
		istringstream si(line);
		vector<int> a;
		int t;
		while(si >> t) a.push_back(t);
		sort(a.begin(), a.end());
		cout << unique(a.begin(), a.end()) - a.begin() << "\n";
	}
	return 0;
}
