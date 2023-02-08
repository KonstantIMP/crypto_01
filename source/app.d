import std.stdio;

import crypto.permutation;

int main(string [] args) {
  char[char] simpleMap;
  simpleMap['a'] = 'b';
  simpleMap['b'] = 'c';
  simpleMap['c'] = 'd';

  auto a = encrypt("abc", simpleMap);
  writeln(a.msg);

  a = decrypt(a.msg, simpleMap);
  writeln(a.msg);

  return 0;
}


