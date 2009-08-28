#include <algorithm>
#include <cstdio>
#include <cstdlib>
#include <cctype>
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
 
const int MAX = 53;
 
int sx,sy;
char board[MAX+2][MAX+2];
bool vis[MAX+2][MAX+2];
int kolej[128];
int score;
 
int cGroup(int x,int y,char c) {
  if(vis[x][y] || board[x][y]!=c) return 0;
  vis[x][y]=true;
  int v=1;
  v+=cGroup(x+1,y,c);
  v+=cGroup(x-1,y,c);
  v+=cGroup(x,y+1,c);
  v+=cGroup(x,y-1,c);
  return v;
}
 
void delGroup(int x,int y,char c) {
  if(board[x][y]!=c) return;
  board[x][y]=' ';
  delGroup(x+1,y,c);
  delGroup(x-1,y,c);
  delGroup(x,y-1,c);
  delGroup(x,y+1,c);
}
 
void move() {
  FOR(x,1,sx) {
    int p=sy;
    FORD(y,sy,1) {
      char c=board[x][y];
      if(c!=' ') { board[x][y]=' '; board[x][p--]=c;}
    }
  }
  int q=1;
  FOR(x,1,sx) {
    if(board[x][sy]!=' ') {
      if(q!=x) {
        FOR(y,1,sy) { board[q][y]=board[x][y]; board[x][y]=' '; }
      }
      ++q;
    }
  }
}
 
bool rounda() {
  FOR(y,1,sy) FOR(x,1,sx) vis[x][y]=false;
  int bx=-1,by=-1;
  int bk=INF, bg=INF;
  FOR(y,1,sy) FOR(x,1,sx) if(board[x][y]!=' ' && !vis[x][y]) {
    char c=board[x][y];
    int k=kolej[c];
    int g=cGroup(x,y,c);
    if(g>1 && (k<bk || k==bk && g<bg)) { bx=x; by=y; bk=k; bg=g; }
  }
  if(bx==-1) return false;
  score += bg*(bg-1)/2;
  delGroup(bx,by,board[bx][by]);
  move();
  return true;
}
 
struct SameGame {
  // MAIN
  int getScore(vector <string> bbb, string order) {
    REP(i,MAX) REP(j,MAX) board[i][j]=' ';
    REP(i,size(order)) kolej[order[i]]=i;
    sy = size(bbb); sx = size(bbb[0]);
    FOR(y,1,sy) FOR(x,1,sx) board[x][y] = bbb[y-1][x-1];
    score=0;
    while(rounda()) ;
    if(board[1][sy]==' ') score*=4;
    return score;
  }
  
 
 
};

int main() {
  char buf[10000];
  SameGame game;
  while (cin.getline(buf, 10000)) {
    string line(buf);
    vector<string> b;
    while (line != string("-ORDER-")) {
      b.push_back(line);
      cin.getline(buf, 10000);
      line = buf;
    }
    cin.getline(buf, 10000);
    line = buf;
    cout << game.getScore(b, line) << endl;
  }
  return 0;
}
