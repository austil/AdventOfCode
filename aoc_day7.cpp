#include <iostream>
#include <unordered_map>
#include <vector>
#include <regex>
#include <bitset>
#include <queue>

#include "utils.cpp"

using namespace std;

// Puzzle

using wires = unordered_map<string, bitset<16>>;

const regex signal{R"(^\S+$)"};
const regex unaryGate{R"(^[A-Z]+ [a-z]+$)"};
const regex binaryGate{R"(^[a-z,1-9]+ [A-Z]+ \S+$)"};

const regex gates{R"(AND|OR|LSHIFT|RSHIFT|NOT)"};

wires runCircuit(const vector<string> &circuit)
{
  wires wiresWithSignal;
  queue<string> pendingInstructions;

  for (auto &elem : circuit)
  {
    pendingInstructions.push(elem);
  }

  while (pendingInstructions.size() > 0)
  {
    const auto instruction = pendingInstructions.front();
    pendingInstructions.pop();
    const auto [source, destination] = split(instruction, " -> ");

    if (regex_match(source, signal))
    {
      bitset<16> value;
      bool sourceIsNumber;
      try
      {
        value = stoi(source);
        sourceIsNumber = true;
      }
      catch (invalid_argument &e)
      {
        sourceIsNumber = false;
      }

      if(sourceIsNumber) {
        wiresWithSignal[destination] = value;
      }
      else if (!sourceIsNumber && wiresWithSignal.find(source) != wiresWithSignal.end())
      {
        wiresWithSignal[destination] = wiresWithSignal[source];
      }
      else
      {
        pendingInstructions.push(instruction);
      }
    }
    else if (regex_match(source, unaryGate))
    {
      const string sourceWire = get<1>(split(source, "NOT"));

      if (wiresWithSignal.find(sourceWire) != wiresWithSignal.end())
      {
        wiresWithSignal[destination] = ~wiresWithSignal[sourceWire];
      }
      else
      {
        pendingInstructions.push(instruction);
      }
    }
    else if (regex_match(source, binaryGate))
    {
      smatch matches;
      regex_search(source, matches, gates);

      if (matches.size() == 1)
      {
        if (matches[0] == "AND")
        {
          const auto [opLeft, opRight] = split(source, " AND ");

          bitset<16> value;
          bool opLeftIsNumber;
          try
          {
            value = stoi(opLeft);
            opLeftIsNumber = true;
          }
          catch (invalid_argument &e)
          {
            opLeftIsNumber = false;
          }

          if (opLeftIsNumber && wiresWithSignal.find(opRight) != wiresWithSignal.end())
          {
            wiresWithSignal[destination] = value & wiresWithSignal[opRight];
          }
          else if (!opLeftIsNumber && wiresWithSignal.find(opLeft) != wiresWithSignal.end() &&
                   wiresWithSignal.find(opRight) != wiresWithSignal.end())
          {
            wiresWithSignal[destination] = wiresWithSignal[opLeft] & wiresWithSignal[opRight];
          }
          else
          {
            pendingInstructions.push(instruction);
          }
        }
        else if (matches[0] == "OR")
        {
          const auto [opLeft, opRight] = split(source, " OR ");
          if (wiresWithSignal.find(opLeft) != wiresWithSignal.end() &&
              wiresWithSignal.find(opRight) != wiresWithSignal.end())
          {
            wiresWithSignal[destination] = wiresWithSignal[opLeft] | wiresWithSignal[opRight];
          }
          else
          {
            pendingInstructions.push(instruction);
          }
        }
        else if (matches[0] == "LSHIFT")
        {
          const auto [opLeft, opRight] = split(source, " LSHIFT ");
          const auto value = stoi(opRight);
          if (wiresWithSignal.find(opLeft) != wiresWithSignal.end())
          {
            wiresWithSignal[destination] = wiresWithSignal[opLeft] << value;
          }
          else
          {
            pendingInstructions.push(instruction);
          }
        }
        else if (matches[0] == "RSHIFT")
        {
           const auto [opLeft, opRight] = split(source, " RSHIFT ");
          const auto value = stoi(opRight);
          if (wiresWithSignal.find(opLeft) != wiresWithSignal.end())
          {
            wiresWithSignal[destination] = wiresWithSignal[opLeft] >> value;
          }
          else
          {
            pendingInstructions.push(instruction);
          }
        }
        else
        {
          cerr << "Can't do anything with matched binaryGate : " << instruction << "\n";
          throw;
        }
      }
      else
      {
        cerr << "Can't do anything with unmatched binaryGate : " << instruction << "\n";
        throw;
      }
    }
    else
    {
      cerr << "Can't do anything with gate : " << instruction << "\n";
      throw;
    }
  }

  return wiresWithSignal;
}

// Payloads

const vector<string> testCircuitInstructions{
    "123 -> x",
    "x AND y -> d",
    "x OR y -> e",
    "x LSHIFT 2 -> f",
    "y RSHIFT 2 -> g",
    "456 -> y",
    "NOT x -> h",
    "NOT y -> i",
    "1 AND y -> j",
    "j LSHIFT 15 -> w"
};

const wires testCircuitResults{
    {"d", 72},
    {"e", 507},
    {"f", 492},
    {"g", 114},
    {"h", 65412},
    {"i", 65079},
    {"x", 123},
    {"y", 456},
    {"j", 0},
    {"w", 0}};

int main(int argc, char const *argv[])
{
  cout << "Starting Test\n";
  wires result = runCircuit(testCircuitInstructions);
  if (result != testCircuitResults)
  {
    cout << "Test Failed, result :\n";
    cout << result;
    return 1;
  }

  cout << "Test Succeeded, proceed with first real payload\n";
  result = runCircuit(getPuzzleInput("./inputs/day7_1.txt"));
  cout << "a -> " << result["a"] << "\n";

  if (result["a"] != 956)
  {
    cout << "Wrong result with first real payload :\n";
    cout << result["a"];
    return 1;
  }

  cout << "First real payload Succeeded, next one : \n";

  result = runCircuit(getPuzzleInput("./inputs/day7_2.txt"));
  cout << "a -> " << result["a"] << "\n";

  return 0;
}
