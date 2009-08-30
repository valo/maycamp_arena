#include <bitset>
#include "../header.h"

struct Human{
	hyper h, l;
	
	Human(){
		h = l = 0;
	}
	
	bool operator<(Human const& o) const{
		if(h != o.h) return h < o.h;
		return l < o.l;
	}
	
	bool operator==(Human const& o) const{
		return h == o.h && l == o.l;
	}
	
	bool Set(int p){
		if(p < 64) l |= 1 << p;
		else h |= 1 << p - 64;
	}
};

int main(){
	int P, T, C;
	while(cin >> P >> T >> C){
		vector<Human> a(P);
		REP(i, C) {
			int p, t;
			cin >> p >> t;
			a[--p].Set(--t);
		}
		sort(a.begin(), a.end());
		a.erase(unique(a.begin(), a.end()), a.end());
		cout << a.size() << endl;
	}
	return 0;
}
