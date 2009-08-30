#include <stdio.h>

int n,m,k;

int valof(int x, int y)
{
	return (x-1)*m + y;
}

int solve(int rows,int cols, int cur, int tar, int x, int y)
{
	int i;

	if(rows==1 && cols==1)
		return valof(x+1,y+1);

	for(i=1;i<cols;i++)
	{
		cur++;
		if(cur == tar)
			return valof(x+1,y+i);
	}

	for(i=1;i<rows;i++)
	{
		cur++;
		if(cur == tar)
			return valof(x+i,y+cols);
	}

	for(i=cols;i>1;i--)
	{
		cur++;
		if(cur == tar)
			return valof(x+rows,y+i);
	}

	for(i=rows;i>1;i--)
	{
		cur++;
		if(cur == tar)
			return valof(x+i,y+1);
	}

	return solve(rows-2,cols-2,cur, tar, x+1,y+1);
}

int main()
{
	//freopen("spiral.in","r",stdin);
	//freopen("spiral.out","w",stdout);

	while(1)
	{
		scanf("%d %d %d",&n,&m,&k);
		if(n==0)
			break;

		int res = solve(n,m,0,k,0,0);

		printf("%d\n",res);
	}

	return 0;
}
