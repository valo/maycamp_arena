#include <stdio.h>

char dyn[32*1024*1024];

struct Posit {
	int cnt[6];
	
	int encode() const {
		return ((cnt[0]-1) << 20) |
			((cnt[1]-1) << 15) | ((cnt[2]-1) << 10) |
			((cnt[3]-1) << 5) | (cnt[4]-1);
	}
};

bool CanWin(const Posit& p) {
	int x = p.encode();
	if (dyn[x]) return dyn[x] == 1;
	for (int i = 0; i < 6; i++) for (int j = 0; j < 6; j++) {
		if (p.cnt[i] > p.cnt[j]) {
			Posit new_p = p;
			for (;;) {
				new_p.cnt[i]--; new_p.cnt[j]++;
				if (new_p.cnt[i] < new_p.cnt[j]) break;
				if (CanWin(new_p) == false) {
//					printf("%d %d %d %d %d %d. %d -> %d\n",
//						new_p.cnt[0], new_p.cnt[1], new_p.cnt[2],
//						new_p.cnt[3], new_p.cnt[4], new_p.cnt[5],
//						i, j);
					dyn[x] = 1;
					return true;
				}
			}
		}
	}
	dyn[x] = -1;
	return false;
}

int main(void) {
	dyn[(9 << 20) | (9 << 15) | (9 << 10) | (9 << 5) | 9] = -1;
	
	int n;
	scanf("%d", &n);
	for (int i = 0; i < n; i++) {
		Posit p;
		for (int j = 0; j < 6; j++) {
			scanf("%d", &p.cnt[j]);
		}
		if (CanWin(p)) {
			printf("YES\n");
		} else {
			printf("NO\n");
		}
	}
	return 0;
}

/*
10
10 10 10 10 10 10
12 8 10 10 10 10
11 10 9 10 10 10
11 7 11 12 12 7
12 9 9 10 10 10
13 8 9 13 9 8
13 9 9 9 10 10
12 9 11 9 9 10
11 11 9 9 10 10
32 8 5 5 5 5
 * */
 
