#include <stdio.h>
#include <math.h>
#define hypot(x,y) sqrt((x)*(x)+(y)*(y))

double x[100], y[100];
int N;

double test(double xx, double yy) {
   double tot = 0;
   int i;
   for (i=0;i<N;i++) {
      tot += hypot(x[i]-xx,y[i]-yy);
   }
   return tot;
}

main(){
   int i,j,k;
   double xx,yy,delta;

while(scanf("%d",&N) == 1){
   for (i=0;i<N;i++) scanf("%lf%lf",&x[i],&y[i]);
   
   xx = 5000;
   yy = 5000;

   for (delta=5000;delta > .0001;delta *=.9) {
      if (test(xx,yy+delta) < test(xx,yy)) yy+=delta;
      if (test(xx,yy-delta) < test(xx,yy)) yy-=delta;
      if (test(xx+delta,yy) < test(xx,yy)) xx+=delta;
      if (test(xx-delta,yy) < test(xx,yy)) xx-=delta;
   }
   printf("%0.0lf\n",test(xx,yy));
}
}
