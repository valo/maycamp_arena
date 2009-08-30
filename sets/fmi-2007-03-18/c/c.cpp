#include <stdio.h>
#define MAXV 200
#define INF 2000000000
int g[MAXV][MAXV][3];
int d[MAXV],used[MAXV];

int main()
{
    int s,T,N,E,M,L;
    int i,j,k,f,t,tf,tt,min,minp;
    scanf("%d",&T);
    for(s=1;s<=T;s++)
    {
      scanf("%d %d",&N,&E);
       scanf("%d",&M);
       for(i=1;i<=N;i++) {g[i][0][0]=0;d[i]=INF;used[i]=0;}
       for(i=1;i<=M;i++)
       {
          scanf("%d",&L);
          scanf("%d %d",&f,&tf);
          for(j=1;j<L;j++)
          {
             scanf("%d %d",&t,&tt);
             g[f][0][0]++;
             g[f][g[f][0][0]][0]=t;
             g[f][g[f][0][0]][1]=tf;
             g[f][g[f][0][0]][2]=tt;
             f=t;tf=tt;                 
          } 
       }                                
       d[1]=0;used[1]=1;f=1;             
       for(i=2;i<=N;i++)
       {
          min=INF;minp=-1;
          for(k=1;k<=g[f][0][0];k++)
          {  t=g[f][k][0];tf=g[f][k][1];tt=g[f][k][2];
             if((!used[t])&&tf>=d[f]&&tt<d[t]) 
             { d[t]=tt;
               if(d[t]<min){min=d[t];minp=t;}
               }  
          }
          f=minp;used[f]=1;
          if(f==E) break;
       }
       if(d[E]==INF) printf("-1\n");
       else printf("%d\n",d[E]);
    }
    return 0;                   
}
