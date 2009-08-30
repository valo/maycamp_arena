#include <sstream>
#include <vector>
#include <map>
#include <set>
#include <iostream>

using namespace std;

vector<map<char,vector<int> > > g;

int main() {
  int n, s;
  char buf[2000];
  while (cin >> n >> s) {
    cin.getline(buf, sizeof(buf));
    g.clear();
    for (int i = 0; i < n; ++i) {
      cin.getline(buf, sizeof(buf));
      stringstream ss(buf);
      map<char, vector<int> > gi;
      char c, dummy;
      int v;
      while (ss >> c) {
        gi.insert(make_pair<char, vector<int> >(c, vector<int>()));
        ss >> dummy;
        while (1) {
          ss >> v;
          gi[c].push_back(v);
          dummy = ' ';
          dummy = ss.peek();
          if (dummy == ',') {
            ss >> dummy;
            continue;
          }
          break;
        }
      }
      g.push_back(gi);
    }
    cin.getline(buf, sizeof(buf));
    string tf(buf);
    set<int> states, newStates;
    states.insert(s);
    for (int k = 0; k < tf.size(); k++) {
      newStates.clear();
      for (set<int>::const_iterator it = states.begin(); it != states.end(); ++it) {
        for (int i = 0; i < g[*it][tf[k]].size(); ++i)
          newStates.insert(g[*it][tf[k]][i]);
      }
      states = newStates;
    }
    bool first = true;
    for (set<int>::const_iterator it = states.begin(); it != states.end(); ++it) {
      if (first)
        first = false;
      else
        printf(" ");
      printf("%d", *it);
    }
    printf("\n");
  }
}
