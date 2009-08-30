#include <stdio.h>

int main()
{
    int i,j,n,ai,aj,x,k;
    long long fib[2005];
    int t,T,sw;
    long long xx;
    scanf("%d",&T);
    fib[0]=0;fib[1]=1;
    for(t=2;t<=2004;t++) fib[t]=fib[t-1]+fib[t-2];
    for(t=1;t<=T;t++)
    {
       scanf("%d %d %d %d %d",&i,&ai,&j,&aj,&n);
       if(n==i) {printf("%d\n",ai);continue;}
       if(n==j) {printf("%d\n",aj);continue;}
       if(i>j){sw=i;i=j;j=sw;sw=ai;ai=aj;aj=sw;}
       xx=(aj-fib[j-i-1]*ai)/fib[j-i];
       x=xx;
       if(n==i+1){printf("%d\n",x);continue;}
       if(n>i+1) 
       {   for(k=i+2;k<=n;k++){sw=ai+x;ai=x;x=sw;}
           printf("%d\n",sw);continue;}
       else    
       {   for(k=i-1;k>=n;k--){sw=x-ai;x=ai;ai=sw;}
           printf("%d\n",sw);continue;}
    }
    return 0;   
    
}
