module crypto.raffinity;

import std.algorithm.searching : canFind;
import std.algorithm.comparison : max;
import std.exception : enforce;
import std.string : indexOf;
import std.array : appender;
import std.format;

import crypto.affinity : isValidKey;
import crypto.alphabet;
import crypto.exception;
import crypto.result;
import crypto.reverse;
import crypto.gcd;
import crypto.key;


Key [] generateKeys(Key a, Key b, size_t len, size_t alphabetLen) {
    Key [] result = new Key[max(2, len)];
    result[0] = a; result[1] = b;

    for (size_t i = 2; i < len; i++) {
        result[i] = Key(
            (result[i - 1].a * result[i - 2].a) % alphabetLen,
            (result[i - 1].b + result[i - 2].b) % alphabetLen
        );
    }
    return result;
}


Result encrypt(string msg, Key a, Key b, string alphabet = englishAlphabet) {
    enforce!InvalidKeyException(
        isValidKey(a, alphabet) && isValidKey(b, alphabet),
        "Invalid keys pair (%d, %d) for %d-size alphabet".format(
            a.a, b.a, alphabet.length
        )
    );

    auto keys = generateKeys(a, b, msg.length, alphabet.length);
    auto msgBuilder = appender!string;
    auto result = Result();

    foreach (size_t i, char ch; msg) {
        if (canFind(alphabet, ch)) {
            size_t x = alphabet.indexOf(ch);
            auto key = keys[i];
            msgBuilder.put(alphabet[(x * key.a + key.b) % alphabet.length]);
        } else {
            result.skipped ~= [i];
            msgBuilder.put(ch);
        }
    }
    result.msg = msgBuilder[];
    return result;
}


Result decrypt(string msg, Key a, Key b, string alphabet = englishAlphabet) {
    enforce!InvalidKeyException(
        isValidKey(a, alphabet) && isValidKey(b, alphabet),
        "Invalid keys pair (%d, %d) for %d-size alphabet".format(
            a.a, b.a, alphabet.length
        )
    );

    auto keys = generateKeys(a, b, msg.length, alphabet.length);
    auto msgBuilder = appender!string;
    auto result = Result();

    foreach (size_t i, char ch; msg) {
        if (canFind(alphabet, ch)) {
            size_t y = alphabet.indexOf(ch);
            auto key = keys[i];
            long aR = reverseByMod(cast(long)key.a, cast(long)alphabet.length);
            msgBuilder.put(alphabet[((y - key.b) * aR) % alphabet.length]);
        } else {
            result.skipped ~= [i];
            msgBuilder.put(ch);
        }
    }

    result.msg = msgBuilder[];
    return result;
}
