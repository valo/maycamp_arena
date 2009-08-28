#include <stdio.h>

int main()
{
    
    int N,i,d,b;
    int mask[20002];
    int a[20002];
    int t,T;
scanf("%d",&T);
for(t=1;t<=T;t++)
{    
     
    scanf("%d %d",&a[1],&N);
    for(i=0;i<10001;i++) mask[i]=-1;
    mask[a[1]]=1;
    for(i=2;i<=20001;i++) 
    {
       a[i]=(a[i-1]*a[i-1])%10000; 
       if(mask[a[i]]== -1) mask[a[i]]=i;
       else {b=mask[a[i]];d=i-mask[a[i]]; break;}
    } 
    if(N<=i) printf("%d\n",a[N]);
    else printf("%d\n",a[b+(N-b)%d]);
}

}      
