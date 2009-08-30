#include <stdio.h>

#include <algorithm>
#include <map>

using namespace std;

int N;

struct Funct {
	int A, B;

	int next(long long x) {
		return (int)((A*x + B)%N);
	}
};

Funct compose(const Funct& f1, const Funct& f2) {
	Funct r;
	r.A = ((long long)f1.A * (long long)f2.A) % N;
	r.B = ((long long)f1.B * (long long)f2.A + f2.B) % N;
	return r;
}

void CHECK_EQ(int a, int b) {
	if (a != b) {
		printf("expected %d, found %d", a, b);
	}
}

void compose_unittest() {
	Funct f1; f1.A = 5436; f1.B = 4324;
	Funct f2 = compose(f1, f1);
	Funct f3 = compose(f1, f2);
	for (int i = 0; i < 100; i++) {
		CHECK_EQ(f1.next(f1.next(i)), f2.next(i));
		CHECK_EQ(f1.next(f2.next(i)), f3.next(i));
	}
}

int MuchAfter(Funct f, int x) {
	for (int i = 0; i < 32; i++) {
		f = compose(f, f);
	}
	return f.next(x);
}

int period(Funct f, int muchx) {
	map<int, int> firstx;
	
	int cur = muchx;
	firstx[cur] = 0;
	for (int i = 1; i < 8192; i++) {
		cur = f.next(cur);
		firstx[cur] = i;
		if (cur == muchx) {
			return i;
		}
	}
	Funct f13 = f;
	for (int i = 0; i < 13; i++) {
		f13 = compose(f13, f13);
	}
	cur = muchx;
	int index = 0;
	for (;;) {
		cur = f13.next(cur); index += 8192;
		
		if (firstx.find(cur) != firstx.end()) {
			return index - firstx[cur];
		}
	}
}

void period_unittest(Funct f, int muchx, int result) {
	Funct r; r.A = 1; r.B = 0;  // id
	while (result != 0) {
		if (result % 2) {
			r = compose(r ,f);
		}
		result /= 2;
		f = compose(f, f);
	}
	CHECK_EQ(muchx, r.next(muchx));
}

int main(void) {
	//A = 5436;
	//B = 4324;
	//N = 6453;
	for (;;) {
		Funct ff;
		int x;
		scanf("%d %d %d %d", &ff.A, &ff.B, &N, &x);
		if (N == 0) break;
		//compose_unittest();
		int result = period(ff, MuchAfter(ff, x));
		printf("%d\n", result);
		//period_unittest(ff, MuchAfter(ff, x), result);
	}
	

	return 0;
}

// 5436 4324 6453 5

/*
2 2 5 2
5436 4324 6453 5
4324234 324543 1000000000 5
543535 324543 1000000000 5
43435424 324543 1000000000 5
43435424 324543 1000000000 6
43435424 324543 1000000000 7
43435424 324543 1000000000 8
43435424 324543 1000000000 9
43435424 324543 1000000000 10
0 0 0 0

 * */
 


