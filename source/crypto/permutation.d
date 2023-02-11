module crypto.permutation;


import std.algorithm.searching : count;
import std.exception : enforce;
import std.array : appender;
import crypto.exception;
import crypto.result;


bool isValidPermutationMap(char[char] permutationMap) {
    auto values = permutationMap.values;

    foreach (ch; values) {
        if ((ch !in permutationMap) || (count(values, ch) != 1)) {
            return false;
        }
    }

    return true;
}


Result encrypt(string msg, char[char] permutationMap) {
    enforce!InvalidKeyException(isValidPermutationMap(permutationMap), "Invalid permutation map");

    auto msgBuilder = appender!string;
    auto result = Result();

    foreach (size_t i, char ch; msg) {
        if (ch in permutationMap) {
            msgBuilder.put(permutationMap[ch]);
        } else {
            result.skipped ~= [i];
            msgBuilder.put(ch);
        }
    }

    result.msg = msgBuilder[];
    return result;
}


Result decrypt(string msg, char[char] permutationMap) {
    char[char] reversedPermutationMap;

    foreach (e; permutationMap.byKeyValue) {
        reversedPermutationMap[e.value] = e.key;
    }

    return encrypt(msg, reversedPermutationMap);
}
