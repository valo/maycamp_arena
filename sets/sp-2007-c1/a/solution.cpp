#include <stdio.h>
#include <string.h>

#define MAX 64

int n, k;
int a[MAX];
int ans;

void pset()  {
	for(int i = 1; i <= k; ++i)  {
//		printf("%d%c", a[i], i == k ? '\n' : ' ');
		ans += a[i];
	}
}

void gen(int m, int p)  {
	if(m > k)  {
		pset();
		return;
	}

	for(int i = p + 1; i <= n; ++i)  {
		a[m] = i;
		gen(m + 1, i);
		a[m] = 0;
	}
}

int main()  {
	for(;;)  {	
		scanf("%d%d", &n, &k);

		if(n == 0 && k == 0)
			break;

		ans = 0;
		gen(1, 0);
		printf("%d\n", ans);
	}
	
	return 0;
}
