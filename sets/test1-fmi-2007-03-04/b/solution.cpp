#include <stdio.h>

int n,k;
int l[10001];

int cut(int len)
{
   int sum,i;
   sum=0;
   for(i=1;i<=n;i++)
   {
      sum=sum+l[i]/len;
      if(sum>10000) return sum;
    }   
    return sum;
}

int main()
{
    
   int i,min,max,mid,t,T;
scanf("%d",&T);   
for(t=1;t<=T;t++)
{
   scanf("%d %d",&n,&k);
   for(i=1;i<=n;i++) scanf("%d",&l[i]);
   min=0;
   max=2100000000;
   while(max>min+1) 
   {
      mid=(min+max)/2;
      if(cut(mid)>=k) min=mid;
      else max=mid;
   }
   printf("%d\n",min);
}   
}
