#include <stdio.h>

int main(void)
{
	printf("5\n1 6 666666996 0 5123412\n");
	printf("4\n4 0 1 2\n");
	printf("4\n4 0 1 0\n");
	printf("4\n4 0 0 0\n");
	printf("4\n42 42 42 42\n");
	printf("1\n1\n");
	printf("10\n1 2 3 4 5 6 7 8 9 10\n");
	printf("19\n1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19\n");
	printf("20\n1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20\n");
	printf("21\n1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 19 19\n");

	printf("100\n42");
	for (int i = 1; i < 100; i++) printf(" 42");
	printf("\n");

	printf("20000\n");
	for (int i = 0; i < 20000; i++) {
		if (i) printf(" ");
		if (i % 5000 == 0)
			printf("%d", i+900000000);
		else
			printf("1");
	}
	printf("\n");

	printf("0\n");
	return 0;
}
