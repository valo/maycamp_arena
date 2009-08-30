#include <stdio.h>

int main()
{
     char sx[1000],sy[1000],s[1000000];
     int x1,y1,x2,y2,Dx,Dy,d;
     
     int t,T,i,j;
  scanf("%d",&T);
  for(t=1;t<=T;t++)
  {     
     scanf("%d %d %d %d %d %d",&x1,&y1,&x2,&y2,&Dx,&Dy);
     for(i=0;i<=x1;i++) sx[i]=0;
     for(i=0;i<=y1;i++) sy[i]=0;
     for(i=0;i<=x1*y1;i++) s[i]=0;
     d=Dx;
     for(i=1;i<=x1;i++)
     {
         if(d+x2<=x1)sx[x2]=1;
         else if(x1<d+x2&&d+x2<2*x1) 
              { sx[x1-d]=1;sx[d+x2-x1]=1; }
              else if(d+x2>=2*x1)
                   {sx[x1-d]=1;sx[x1]=1;sx[(d+x2)%x1]=1;}
              else break;
         d=(d+x2)%x1;
     }
     d=Dy;
     for(i=1;i<=y1;i++)
     {
         if(d+y2<=y1)sy[y2]=1;
         else if(y1<d+y2&&d+y2<2*y1) 
              { sy[y1-d]=1;sy[d+y2-y1]=1; }
              else if(d+y2>=2*y1)
                   {sy[y1-d]=1;sy[y1]=1;sy[(d+y2)%y1]=1;}
              else break;
         d=(d+y2)%y1;
     }
    for(i=1;i<=x1;i++)
        for(j=1;j<=y1;j++)
           if(sx[i]&&sy[j]) s[i*j]=1;
    j=0;
//    for(i=1;i<=x1*x2;i++)
//       if(s[i]) {j++; printf("face=%d\n",i);}
    printf("%d\n",j);
  } 
}
