#include <stdio.h>

int m,n;

int abs(int val)
{
	return (val<0)?(-val):val;
}

int valof(int r, int c)
{
	return (r-1)*m + c;
}

int tr1(int rows, int cols)
{
	int sum = 0;

	int i,i2;
	int last = 0;

	for(i=1;i<=cols;i++)
	{
		int c = i;
		for(i2=1;c>0&&i2<=n;i2++,c--)
		{
			if(last!=0)
				sum += abs(last-valof(i2,c));
			last = valof(i2,c);
		}
	}

	for(i=2;i<=n;i++)
	{
		int c = m;
		for(i2=i;i2<=n&&c>0;i2++,c--)
		{
			if(last!=0)
				sum += abs(last-valof(i2,c));
			last = valof(i2,c);
		}
	}

	return sum;
}

int tr2(int rows, int cols)
{
	int sum = 0;

	int i,i2;
	int last = 0;

	for(i=m;i>0;i-=2)
	{
		for(i2=n;i2>0;i2--)
		{
			if(last!=0)
				sum += abs(last-valof(i2,i));
			last = valof(i2,i);
		}

		if(i-1>0)
		{
			for(i2=1;i2<=n;i2++)
			{
				if(last!=0)
					sum += abs(last-valof(i2,i-1));
				last = valof(i2,i-1);
			}
		}
	}

	return sum;
}

int main()
{
	//freopen("traversals.in","r",stdin);
	//freopen("traversals.out","w",stdout);

	while(1)
	{
		scanf("%d %d",&n,&m);
		if(m==0 && n==0)
			break;

		int res1 = tr1(n,m);
		int res2 = tr2(n,m);

		printf("%d\n",abs(res1 - res2));
	}

	return 0;
}
