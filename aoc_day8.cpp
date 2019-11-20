#include <iostream>
#include <regex>
#include "utils.cpp"

using namespace std;

const regex escaped{R"((\\\\|\\"|\\x[a-f,0-9]{2}))"};
const regex toEscape{R"("|\\)"};

int decodedDelta(const vector<string> &strs) {
  int originalSize = 0;
  int decocedSize = 0;
  for (auto &str : strs)
  {
    // cout << str << "\n";
    smatch matches;
    string::const_iterator searchStart( str.cbegin() );
    int matchesCount = 0;
    int matchedStrSize = 0;
    while ( regex_search(searchStart, str.cend(), matches, escaped) )
    {
      // cout << ( searchStart == str.cbegin() ? "" : " " ) << matches[0];  
      matchesCount++;
      matchedStrSize += matches.str(0).size();
      searchStart = matches.suffix().first;
    }

    originalSize += str.size();
    decocedSize += str.size() - 2 - (matchedStrSize - matchesCount);
    // cout << "\n" << str.size() << " & " << str.size() - 2 - (matchedStrSize - matchesCount) << "\n\n";
  }
  return originalSize - decocedSize;
}

int encodedDelta(const vector<string> &strs) {
  int originalSize = 0;
  int encodedSize = 0;
  for (auto &str : strs)
  {
    // cout << str << "\n";
    smatch matches;
    string::const_iterator searchStart( str.cbegin() );
    int matchesCount = 0;
    while ( regex_search(searchStart, str.cend(), matches, toEscape) )
    {
      // cout << ( searchStart == str.cbegin() ? "" : " " ) << matches[0];  
      matchesCount++;
      searchStart = matches.suffix().first;
    }

    originalSize += str.size();
    encodedSize += str.size() + matchesCount + 2;
    // cout << "\n" << str.size() << " & " << str.size() + matchesCount << "\n\n";
  }
  return encodedSize - originalSize;
}

const vector<string> testStrs {
  "\"\"",
  "\"abc\"",
  "\"aaa\\\"aaa\"",
  "\"\\x27\""
};

int main(int argc, char const *argv[])
{
  cout << "Starting Test\n";
  int result = decodedDelta(testStrs);
  if (result != 12)
  {
    cout << "Test decodedDelta Failed, result :\n";
    cout << result << "\n";
    return 1;
  }

  result = encodedDelta(testStrs);
  if (result != 19)
  {
    cout << "Test encodedDelta Failed, result :\n";
    cout << result << "\n";
    return 1;
  }

  cout << "Test Succeeded, proceed with first real payload\n";
  result = decodedDelta(getPuzzleInput("./inputs/day8_1.txt"));

  if (result != 1371)
  {
    cout << "Wrong result with first real payload :\n";
    cout << result;
    return 1;
  }

  cout << encodedDelta(getPuzzleInput("./inputs/day8_1.txt")) << "\n";

  return 0;
}
