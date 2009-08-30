#include <stdio.h>


int L[5],C[5],k,min;
int i,x1,y1,x2,y2;


int abs(int x)
{ return (x>=0?x:-x);}

void rec(int x,int y, int kind, int count)
{
  
      int cx,cy,abscx,Ckind,Lkind;
      if(count>=min) return;
      if(kind==1) 
      {
         if (abs(x)%L[1]==0 && abs(y)%L[1]==0) 
         {
            cx=abs(x)/L[1];
            cy=abs(y)/L[1];
            if(cx+cy<=C[1]&&count+cx+cy<min) 
               min=count+cx+cy;
         }
      }
      else 
      {
         Ckind=C[kind];
         Lkind=L[kind];
         for(cx=1;cx<=Ckind-1;cx++)
            for(cy=1;cy<=Ckind-cx;cy++)
            { 
               rec(x+cx*Lkind,y+cy*Lkind,kind-1,count+cx+cy);
               rec(x+cx*Lkind,y-cy*Lkind,kind-1,count+cx+cy);
               rec(x-cx*Lkind,y+cy*Lkind,kind-1,count+cx+cy);
               rec(x-cx*Lkind,y-cy*Lkind,kind-1,count+cx+cy);
            }
         cx=0;
         for(cy=1;cy<=Ckind;cy++)
         {
            rec(x,y+cy*Lkind,kind-1,count+cy);
            rec(x,y-cy*Lkind,kind-1,count+cy);
         }
         cy=0;
         for(cx=1;cx<=Ckind;cx++)
         {
            rec(x+cx*Lkind,y,kind-1,count+cx);
            rec(x-cx*Lkind,y,kind-1,count+cx);
         }
         rec(x,y,kind-1,count);
      }
}

int main()
{  
     
 int t,T;
 scanf("%d",&T);
 for(t=1;t<=T;t++)
 {  
   scanf("%d %d %d %d %d",&x1,&y1,&x2,&y2,&k);
   for(i=1;i<=k;i++) scanf("%d",&L[i]);
   for(i=1;i<=k;i++) scanf("%d",&C[i]);
   min=2100000000;
   rec(x1-x2,y1-y2,k,0);
   if(min==2100000000) printf("-1\n");
   else printf("%d\n",min);
 }  
   return 0;
}
