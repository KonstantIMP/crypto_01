module cryptor;

import crypto.result;
import optional;

interface Cryptor {
    Optional!Result encrypt(string);
    Optional!Result decrypt(string);
}

