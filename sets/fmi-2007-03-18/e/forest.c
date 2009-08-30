#include <stdio.h>

int obs[200][200];
int done[200];

main(){
	int P,T,C,i,j=0,k,cnt=0, t;
	while(scanf("%d%d",&P, &T, &C) == 3){
		for(t = 0, t < C; ++t){
			scanf("%d%d",&i,&j);
			obs[i][j] = 1;
		}
		for (i=1; i<=P; i++) {
			if (done[i]) continue;
			cnt++;
			for (j=i;j<=P;j++) {
				for (k=1;k<=T && obs[i][k]==obs[j][k];k++);
				if (k > T) done[j] = 1;
			}
		}
		printf("%d\n",cnt);
	}
}
