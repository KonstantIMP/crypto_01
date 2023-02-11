module cryptor;

import crypto.result;

interface Cryptor {
    Result encrypt(string);
    Result decrypt(string);
}

