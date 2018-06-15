/*
MIT License

Copyright (c) 2018 Doi Yusuke

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

#include <iostream>
#include <optional>
#include <sstream>
#include <string>
#include <string_view>
#include <utility>

using namespace std;

class WriteGuard
{
public:
  WriteGuard(ostream& os, string_view sv) noexcept
    : os_ {os},
      sv_ {move(sv)}
  {
  }

  ~WriteGuard() noexcept
  {
    os_ << sv_ << '\n';
  }

private:
  ostream&    os_;
  string_view sv_;
};

constexpr optional<unsigned int> uint_from_hex(char ch)
{
  switch (ch) {
    case '0': return 0;
    case '1': return 1;
    case '2': return 2;
    case '3': return 3;
    case '4': return 4;
    case '5': return 5;
    case '6': return 6;
    case '7': return 7;
    case '8': return 8;
    case '9': return 9;
    case 'a': return 10;
    case 'b': return 11;
    case 'c': return 12;
    case 'd': return 13;
    case 'e': return 14;
    case 'f': return 15;
  }
  return nullopt;
}

int main()
{
  for (string s {}; getline(cin, s);) {
    const WriteGuard wg {cout, s}; // always write original line on finaly
    constexpr string_view data_str {R"(\"data\":\")"};
    const auto data_pos = s.find(data_str);
    if (data_pos == string::npos)
      continue;
    const auto data_begin_pos {data_pos + data_str.size()};
    const auto data_line {s.substr(data_begin_pos, s.find('\\', data_begin_pos) - data_begin_pos)};
    istringstream iss {data_line};

    cout << R"("data_str":")";
    for (char c; iss.get(c);) {
      const auto high_value {uint_from_hex(c)};
      if (!high_value || !iss.get(c))
        break;
      if (const auto low_value {uint_from_hex(c)}) {
        const auto ch {static_cast<char>(*high_value << 4 | *low_value)};
        if (ch == '"')
          cout << R"(\")";
        else
          cout << ch;
      }
    }
    cout << "\",\n";
  }
}
