#include <algorithm>
#include <cstdio>
#include <cstdlib>
#include <cctype>
#include <cmath>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>
using namespace std;
 
#define REP(i,n) for(int i=0;i<(n);++i)
#define FOR(i,a,b) for(int i=(a);i<=(b);++i)
#define FORD(i,a,b) for(int i=(a);i>=(b);--i)
#define FOREACH(i,c) for(__typeof((c).begin()) i=(c).begin();i!=(c).end();++i)
typedef long long LL;
const int INF = 1000000000;
typedef vector<int> VI;
template<class T> inline int size(const T&c) { return c.size(); }
 
char buf1[1000];
 
string i2s(int x) {
  sprintf(buf1,"%d",x);
  return buf1;
}
 
 
const int MAXN = 64;
 
int n;
int dist[MAXN][MAXN];
 
int timeTaken(vector <int> x, vector <int> y) {
  n = size(x);
  REP(a,n) REP(b,n) {
    if(x[a]==x[b]) dist[a][b] = (abs(y[a]-y[b])+1)/2;
    else if(y[a]==y[b]) dist[a][b]=(abs(x[a]-x[b])+1)/2;
    else dist[a][b] = max(abs(x[a]-x[b]),abs(y[a]-y[b]));
  }
  REP(c,n) REP(a,n) REP(b,n)
  dist[a][b] = min(dist[a][b],max(dist[a][c],dist[c][b]));
  int r=0;
  REP(a,n) REP(b,n) r=max(r,dist[a][b]);
  return r;
}

int main() {
   char buf[100000];
   vector<int> x, y;
   int value;
   while (1) {
     x.clear();
     y.clear(); 
     if (!cin.getline(buf, 100000))
       break;
     if (strlen(buf) <= 0)
       break;
     stringstream sx(buf);
     while (sx >> value) {
       x.push_back(value);
     }
     cin.getline(buf, 100000);
     stringstream sy(buf);
     while (sy >> value) {
       y.push_back(value);
     }
     cout << timeTaken(x,y) << endl;
   }
}
 
