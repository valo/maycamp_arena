#include <stdio.h>

int A[101];
unsigned C[101][101];
int main()
{
  int i,j,k,l,d,N;
  unsigned t,T,mint;
  scanf("%d",&T);
  for(t=1;t<=T;t++)
  {  
     scanf("%d",&N);
     for(i=1;i<=N;i++) scanf("%d",&A[i]);
     for(i=1;i<=N-1;i++) C[i][i+1]= 0;
     for(d=2;d<=N-1;d++)
     {
         for(i=1;i<=N-d;i++)
         {
            j=i+d;
            mint=4294967295;
            for(k=i+1;k<=j-1;k++) 
            {
               l=C[i][k]+C[k][j]+A[i]*A[k]*A[j];
               if(l<mint) mint=l;
            }
            C[i][j]=mint;
         }
     }
     printf("%u\n",C[1][N]);
  }  
  return 0;
}
