#include <iostream>
#include <algorithm>
#include <cstring>
using namespace std;

int a[20001], n;

int factors[20002];

void add(int x, int direction)
{
	int i = 2;
	while (i*i <= x) {
		while (x % i == 0) {
			factors[i] += direction;
			x /= i;
		}
		i++;
	}
	if (x > 1)
		factors[x] += direction;
}

void add_factorial(int x, int direction)
{
	for (int i = 2; i <= x; i++)
		add(i, direction);
}

long long calculate(void)
{
	long long res = (long long)1;
	for (int i = 2; i < 20002; i++)
		for (int j = 0; j < factors[i]; j++)
			res *= (long long) i;
	return res;
}

int main(void)
{
	while (1) {
		cin >> n;
		if (!n) break;
		memset(factors, 0, sizeof(factors));
		for (int i = 0; i < n; i++)
			cin >> a[i];
		sort(a, a+n);
		add_factorial(n, +1);
		a[n] = 1999666111; // sentinel
		int x = 0;
		while (x < n) {
			int counter = 1;
			while (a[x+1] == a[x]) {
				counter++;
				x++;
			}
			x++;
			add_factorial(counter, -1);
		}
		cout << calculate() << endl;
	}
	return 0;
}
