#include <iostream>
#include <vector>
#include <map>
#include <set>
#include <queue>
#include <deque>

using namespace std;

class Solution {
 public:
  bool ReadTest() {
    regexp_ = "a(((bad|cd|as)+g)*(ad?as+)+)?d";
    getline(cin, sample_);
    return cin;
  }

  void Execute() {
    while (ReadTest()) {
      OutputResult(Solve());
    }
  }

  void OutputResult(int result) {
    if (result == -1)
      cout << "YES" << endl;
    else
      cout << result << endl;
  }

  int Solve() {
    ClearTestData();
    BuildAutomata();
    return RunSample();
  }

  int CreateNextState() {
    automata_.push_back(map<char,set<int> >());
    return automata_.size() - 1;
  }

  int GetFirstOpenOr(int start_index, int end_index) {
    int i;
    int brackets = 0;
    for (i = start_index; i < end_index; i++) {
      if (!brackets && regexp_[i] == '|')
        return i;
      if (regexp_[i] == '(')
        brackets++;
      if (regexp_[i] == ')')
        brackets--;
    }
    return string::npos;
  }

  bool HandleOr(int start_state,
                int final_state,
                int start_index,
                int end_index) {
    int first_open_or = GetFirstOpenOr(start_index, end_index);
    if (first_open_or != string::npos) {
      DecodeRegExp(start_state, final_state, start_index, first_open_or);
      DecodeRegExp(start_state, final_state, first_open_or + 1, end_index);
      return true;
    } else {
      return false;
    }
  }

  int GetFirstOpenBracketIndex(int start_index, int end_index) {
    int i = start_index;
    for (;i < end_index; i++) {
      if (regexp_[i] == '(') {
        break;
      }
    }
    if (i < end_index)
      return i;
    else
      return string::npos;
  }

  bool HandleBrackets(int start_state,
                      int final_state,
                      int start_index,
                      int end_index) {
    int open_bracket = GetFirstOpenBracketIndex(start_index, end_index);
    if (open_bracket == string::npos) {
      return false;
    } else {
      int brackets = 0;
      int closing_bracket = open_bracket + 1;
      for (; closing_bracket < end_index; closing_bracket++) {
        if (regexp_[closing_bracket] == '(')
          brackets++;
        if (regexp_[closing_bracket] == ')')
          if (brackets)
            brackets--;
          else
            break;
      }
      int add_special_charcter = IsSpecialChar(closing_bracket + 1, end_index);
      int pre_bracket_state = start_state;
      if (start_index != open_bracket) {
        pre_bracket_state = CreateNextState();
        DecodeRegExp(start_state, pre_bracket_state, start_index, open_bracket);
      }
      int post_bracket_state = final_state;
      if (closing_bracket + add_special_charcter + 1 < end_index) {
        post_bracket_state = CreateNextState();
        DecodeRegExp(post_bracket_state,
                     final_state,
                     closing_bracket + add_special_charcter + 1,
                     end_index);
      }
      if (!add_special_charcter) {
        DecodeRegExp(pre_bracket_state,
                     post_bracket_state,
                     open_bracket + 1,
                     closing_bracket);
      } else {
        switch (regexp_[closing_bracket + 1]) {
          case '?':
            DecodeRegExp(pre_bracket_state,
                         post_bracket_state,
                         open_bracket + 1,
                         closing_bracket);
            AddZeroValueTransition(pre_bracket_state, post_bracket_state);
            break;
          case '*':
            DecodeRegExp(pre_bracket_state,
                         post_bracket_state,
                         open_bracket + 1,
                         closing_bracket);
            DecodeRegExp(post_bracket_state,
                         post_bracket_state,
                         open_bracket + 1,
                         closing_bracket);
            AddZeroValueTransition(pre_bracket_state, post_bracket_state);
            break;
          case '+':
            DecodeRegExp(pre_bracket_state,
                         post_bracket_state,
                         open_bracket + 1,
                         closing_bracket);
            DecodeRegExp(post_bracket_state,
                         post_bracket_state,
                         open_bracket + 1,
                         closing_bracket);
            break;
          default:
            cerr << "Some problem on bracket special charater." << endl;
        }
      }
      return true;
    }
  }

  void AddState(int start_state, int character, int result_state) {
    if (!automata_[start_state].count(character))
      automata_[start_state][character] = set<int>();
    automata_[start_state][character].insert(result_state);
  }

  void AddZeroValueTransition(int start_state, int end_state) {
    AddState(start_state, 0, end_state);
  }

  int IsSpecialChar(int index, int end_index) {
    if (index < end_index &&
        regexp_[index] == '?' ||
        regexp_[index] == '+' ||
        regexp_[index] == '*')
      return 1;
    else
      return 0;
  }

  void DecodeRegExp(int start_state,
                    int final_state,
                    int start_index,
                    int end_index) {
    if (HandleOr(start_state, final_state, start_index, end_index))
      return;
    if (HandleBrackets(start_state, final_state, start_index, end_index))
      return;
    int state_number = start_state;
    for (int i = start_index; i < end_index; i++) {
      int has_special_char = IsSpecialChar(i + 1, end_index);
      int state_to_be_assigned = ((i + has_special_char + 1 < end_index) ?
                                  CreateNextState() :
                                  final_state);
      if (!has_special_char) {
        AddState(state_number, regexp_[i], state_to_be_assigned);
      } else {
        switch (regexp_[i + 1]) {
          case '?':
            AddState(state_number, regexp_[i], state_to_be_assigned);
            AddZeroValueTransition(state_number, state_to_be_assigned);
            break;
          case '+':
            AddState(state_number, regexp_[i], state_to_be_assigned);
            AddState(state_to_be_assigned, regexp_[i], state_to_be_assigned);
            break;
          case '*':
            AddState(state_number, regexp_[i], state_to_be_assigned);
            AddZeroValueTransition(state_number, state_to_be_assigned);
            AddState(state_to_be_assigned, regexp_[i], state_to_be_assigned);
            break;
        }
      }
      i += has_special_char;
      state_number = state_to_be_assigned;
    }
  }

  void BuildAutomata() {
    start_state_ = CreateNextState();
    final_state_ = CreateNextState();
    DecodeRegExp(start_state_, final_state_, 0, regexp_.size());
  }

  void TransitiveClose(set<int>& states) {
    deque<int> to_be_traversed(states.begin(), states.end());
    while (to_be_traversed.size()) {
      set<int>& trasfers = automata_[to_be_traversed.front()][0];
      for (set<int>::const_iterator iter = trasfers.begin();
           iter != trasfers.end();
           iter++) {
        if (!states.count(*iter)) {
          states.insert(*iter);
          to_be_traversed.push_back(*iter);
        }
      }
      to_be_traversed.pop_front();
    }
  }

  int RunSample() {
    set<int> states_in;
    states_in.insert(start_state_);
    set<int> next_states;
    for (int i = 0; i < sample_.size(); i++) {
      for (set<int>::const_iterator iter = states_in.begin();
           iter != states_in.end();
           iter++) {
        if (automata_[*iter].count(sample_[i]))
          next_states.insert(automata_[*iter][sample_[i]].begin(),
                             automata_[*iter][sample_[i]].end());
      }
      if (next_states.size() == 0)
        return i;

      TransitiveClose(next_states);

      states_in = next_states;
      next_states.clear();
    }
    if (states_in.count(final_state_))
      return -1;
    else
      return sample_.size();
  }

  void ClearTestData() {
    automata_.clear();
    start_state_ = 0;
    final_state_ = 0;
  }

 private:
  vector<map<char,set<int> > > automata_;
  int final_state_;
  int start_state_;
  string regexp_;
  string sample_;
};

int main() {
  Solution solution;
  solution.Execute();
  return 0;
}
