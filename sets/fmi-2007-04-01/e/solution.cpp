#include <stdio.h>
#include <vector>

using namespace std;

#define TESTMODE

long long fact(int n) {
	if (n == 1) return 1;
	return n * fact(n - 1);
}

int n;
vector<int> curr;
long long result;

#ifdef TESTMODE

long long verify_eval() {
	long long cnt = fact(n);
	for (size_t i = 0; i < curr.size(); i++) {
		cnt /= fact(curr[i]);
	}
	return cnt;
}

#endif

int gcd(int a, int b) {
	if (b == 0) return a;
	return gcd(b, a%b);
}

long long meval() {
	vector<int> fn;
	for (int i = 2; i <= n; i++) fn.push_back(i);
	for (size_t ci = 0; ci < curr.size(); ci++) {
		int cn = curr[ci];
		for (int i = 2; i <= cn; i++) {
			int dn = i;
			for (size_t p = 0; dn > 1; p++) {
				int g = gcd(dn, fn[p]);
				dn /= g;
				fn[p] /= g;
			}
		}
	}

	long long r = 1;
	for (size_t i = 0; i < fn.size(); i++) {
#ifdef TESTMODE
		long long pr = r;
#endif
		r = r * static_cast<long long>(fn[i]);
#ifdef TESTMODE
		if (r < pr) printf("OVERFLOW %lld vs %lld\n", r, pr);
#endif
	}
#ifdef TESTMODE
	if (n <= 20 && verify_eval() != r) {  // TEST
		printf("ERROR %lld vs %lld\n", verify_eval(), r); 
	}
#endif
	return r;
}

void solve(int mn, int mx) {
#ifdef TESTMODE
   long long pr = result;
#endif
	if (mx == 0) result += meval();
#ifdef TESTMODE
	if (result < pr) printf("OVERFLOW %lld vs %lld\n", result, pr);
#endif
	for (int i = mn; i <= mx; i++) {
		curr.push_back(i);
		solve(i + 1, mx - i);
		curr.pop_back();
	}
}

int main(void) {
	int ncases;
	scanf("%d", &ncases);
	while (ncases--) {
		scanf("%d", &n);
		result = 0; curr.clear();
		solve(1, n);
#ifdef TESTMODE
		if (curr.size() != 0) printf("ERROR\n");
#endif
		printf("%lld\n", result);
	} 
	return 0;
}
