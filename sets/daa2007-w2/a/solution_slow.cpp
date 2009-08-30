#include <stdio.h>
#include <time.h>

const int MAXN = 30004;

int brt;
int n;
int heap[MAXN];
int hc = 1;

///////test//////
int mas[MAXN];
int cnt = 0;

void insert(int num)
{
	int ind = hc++;
	heap[ind] = num;

	while(ind>1)
	{
		if(heap[ind]>heap[ind/2])
		{
			int buf = heap[ind];
			heap[ind] = heap[ind/2];
			heap[ind/2] = buf;
			ind /= 2;
		}
		else
			break;
	}
}

int pop()
{
	int save = heap[1];

	if(hc==0)
	{
		printf("error");
		return -1;
	}

	heap[1] = heap[--hc];

	int ind = 1;
	int nind;

	while(2*ind<hc)
	{
		nind = ind*2;

		if(nind+1<hc)
			if(heap[nind]<heap[nind+1])
				nind++;

		if(heap[ind]<heap[nind])
		{
			int buf = heap[ind];
			heap[ind] = heap[nind];
			heap[nind] = buf;
			ind = nind;
		}
		else
			break;
	}

	return save;
}

//// test////

void insert2(int num)
{
	mas[cnt++] = num;
}

int pop2()
{
	int i;
	int max = -1000000000;
	int mind = 0;

	for(i=0;i<cnt;i++)
	{
		if (max < mas[i])
		{
			max = mas[i];
			mind = i;
		}
	}

	mas[mind] = -1000000000;

	return max;
}

int main()
{
	//freopen("queries.in","r",stdin);
	//freopen("queries.out","w",stdout);

	clock_t beg,end;

	beg = clock();

	scanf("%d",&brt);

	int i;

	while(brt--)
	{
		scanf("%d",&n);
		hc = 1;
		/// test ///
		cnt = 0;

		for(i=0;i<n;i++)
		{
			int com;
			scanf("%d",&com);
			if(com==1)
			{
				int num;
				scanf("%d",&num);
				//insert(num);
				insert2(num);
			}
			else
			{
				//int res = pop();
				int res2 = pop2();
				//printf("%d\n",res);
				printf("%d\n",res2);
			}
		}

		if(brt!=0)
			printf("\n");
	}

	end = clock();

	printf("%lf\n",(end-beg)/(double)CLOCKS_PER_SEC);

	return 0;
}
