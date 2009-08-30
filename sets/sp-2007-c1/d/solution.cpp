#include <bitset>
#include <iostream>
#include <fstream>
#include <sstream>

#include <algorithm>
#include <vector>
#include <deque>
#include <list>
#include <set>
#include <map>
#include <string>
#include <queue>
#include <stack>

#include <cassert>
#include <cstdio>
#include <cstdlib>
#include <cmath>
#include <ctime>
using namespace std;

#define REP(i, n) for(int i = 0; i < int(n); ++i)
#define DOWN(i, n) for(int i = int(n) - 1; i >= 0; --i)
#define FOR(i, b, e) for(int i = int(b); i < int(e); ++i)
#define ONEREP(i, n) for(int i = 1; i <= int(n); ++i)
#define FROMTO(i, f, t) for(int i = int(f); i <= int(t); ++i)

#define FORALL(i, c) for(typeof((c).begin()) i=(c).begin(); i!=(c).end(); ++i)

#define endl "\n"
#define DEB(x) cerr << "at:" << __LINE__ << "\t" << #x << ":" << (x) << endl << flush
#define DEBT(x) cerr << #x << ":" << (x) << "\t" << flush
#define TRACE cerr << "at:" << __LINE__ << endl << flush

#define ARR_ITER(arr) arr, arr + sizeof(arr) / sizeof(arr[0])
#define ALL(c) (c).begin(), (c).end()

#define ZEROARR(a) memset(a, 0, sizeof(a))



const int INF = 102345678;
const double EPS = 0.0000000001;


template <typename T> T Sqr(T t){return t * t;}

#undef hyper
typedef long long hyper;

hyper Rand(hyper m){
	hyper res = 0;
	REP(i, 6) {
		res <<= 10;
		res ^= rand();
	}
	res &= ~((hyper)1 << 63);
	return res % m; 
}

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
