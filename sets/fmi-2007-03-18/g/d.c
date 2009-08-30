/*
	Problem: 	Packets
	Author:		Jan Kotas
	Algorithm:	direct calculation
	Complexity:	O(1)
*/
/*
#include <stdio.h>

int t[4] = { 0, 7, 6, 5 };
int u[4] = { 0, 5, 3, 1 };

int main()
{
   int a,b,c,d,e,f,i,x,y,z;

  for(;;)
  {
     scanf("%d %d %d %d %d %d\n", &a, &b, &c, &d, &e, &f);

     x = 11 * e + t[c % 4];
     y = 5 * d + u[c % 4];

     z = f + d + e + (c + 3) / 4;

     if(y < b)
     {
	i = (b - y + 8) / 9;
	z += i;
	x += 4 * (9 * i - (b - y));
     }
     else x += 4 * (y - b);

     if(x < a) z += (a - x + 35) / 36;

     if(!z) break;

     printf("%d\n", z);
  }
  return 0;
}*/
/*
	Problem: 	Packets
	Author:		Jan Kotas
	Algorithm:	direct calculation
	Complexity:	O(1)
*/


#include <stdio.h>

int t[4] = { 0, 7, 6, 5 };
int u[4] = { 0, 5, 3, 1 };

int main()
{
   int a,b,c,d,e,f,i,x,y,z;

  for(;;)
  {
     if(scanf("%d%d%d%d%d%d", &a, &b, &c, &d, &e, &f) < 6) break;

     x = 11 * e + t[c % 4];
     y = 5 * d + u[c % 4];

     z = f + d + e + (c + 3) / 4;

     if(y < b)
     {
	i = (b - y + 8) / 9;
	z += i;
	x += 4 * (9 * i - (b - y));
     }
     else x += 4 * (y - b);

     if(x < a) z += (a - x + 35) / 36;

     if(!z) break;

     printf("%d\n", z);
  }
  return 0;
}
