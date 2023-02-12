module ui.page.raffinity;

import adw.PreferencesPage;

import ui.widget.crypt_group;
import ui.widget.key_group;

import crypto.affinity : isValidKey;
import cipher = crypto.raffinity;
import crypto.alphabet;
import crypto.result;

import optional;
import cryptor;

class RAffinityCipherPage : PreferencesPage, Cryptor {
    private CryptGroup cGroup;
    private KeyGroup k1, k2;

    public this() {
        cGroup = new CryptGroup(this);
        k1 = new KeyGroup();
        k2 = new KeyGroup();

        add(cGroup); add(k1); add(k2);
    }

    Optional!Result encrypt(string src) {
        if (!isValidKey(k1.key(), englishAlphabet) || !isValidKey(k2.key(), englishAlphabet)) {
            return no!Result;
        }
        return some(cipher.encrypt(src, k1.key(), k2.key()));
    }

    Optional!Result decrypt(string src) {
        if (!isValidKey(k1.key(), englishAlphabet) || !isValidKey(k2.key(), englishAlphabet)) {
            return no!Result;
        }
        return some(cipher.decrypt(src, k1.key(), k2.key()));
    }
}
