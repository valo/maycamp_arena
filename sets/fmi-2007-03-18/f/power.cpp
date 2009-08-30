#include "../header.h"

string s;

main(){
   int i,j,k,m,n;
   string s;
   while(getline(cin, s)) {
      m = n = int(s.size());
      for (i=2;i<=n;i++) {
         while (n%i == 0) {
            n /= i;
            for (j=0;j<m-m/i && s[j] == s[j+m/i];j++);
            if (j == m-m/i) m /= i;
         }
      }
      printf("%d\n",int(s.size())/m);
   }
}
