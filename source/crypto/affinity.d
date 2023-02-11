module crypto.affinity;

import std.algorithm.searching : canFind;
import std.string : indexOf;
import std.exception : enforce;
import std.array : appender;
import std.format;

import crypto.alphabet;
import crypto.exception;
import crypto.result;
import crypto.reverse;
import crypto.gcd;
import crypto.key;


bool isValidKey(Key key, string alphabet) {
    return gcd(key.a, alphabet.length) == 1;
}


Result encrypt(string msg, Key key, string alphabet = englishAlphabet) {
    enforce!InvalidKeyException(
        isValidKey(key, alphabet),
        format("Invalid key %d for %d-size alphabet", key.a, alphabet.length)
    );

    auto msgBuilder = appender!string;
    auto result = Result();

    foreach (size_t i, char ch; msg) {
        if (canFind(alphabet, ch)) {
            size_t x = alphabet.indexOf(ch);
            msgBuilder.put(alphabet[(x * key.a + key.b) % alphabet.length]);
        } else {
            result.skipped ~= [i];
            msgBuilder.put(ch);
        }
    }

    result.msg = msgBuilder[];
    return result;
}


Result decrypt(string msg, Key key, string alphabet = englishAlphabet) {
    enforce!InvalidKeyException(
        isValidKey(key, alphabet),
        format("Invalid key %d for %d-size alphabet", key.a, alphabet.length)
    );

    auto msgBuilder = appender!string;
    auto result = Result();

    foreach (size_t i, char ch; msg) {
        if (canFind(alphabet, ch)) {
            size_t y = alphabet.indexOf(ch);
            long aR = reverseByMod(cast(long)key.a, cast(long)alphabet.length);
            msgBuilder.put(alphabet[((y - key.b + alphabet.length) * aR) % alphabet.length]);
        } else {
            result.skipped ~= [i];
            msgBuilder.put(ch);
        }
    }

    result.msg = msgBuilder[];
    return result;
}

