module ui.page.affinity;

import adw.PreferencesPage;

import ui.widget.crypt_group;
import ui.widget.key_group;

import cipher = crypto.affinity;
import crypto.alphabet;
import crypto.result;

import optional;
import cryptor;

class AffinityCipherPage : PreferencesPage, Cryptor {
    private CryptGroup cgroup;
    private KeyGroup kGroup;

    public this() {
        cgroup = new CryptGroup(this);
        kGroup = new KeyGroup();

        add(cgroup); add(kGroup);
    }

    Optional!Result encrypt(string src) {
        if (!cipher.isValidKey(kGroup.key(), englishAlphabet)) return no!Result;
        return some(cipher.encrypt(src, kGroup.key()));
    }

    Optional!Result decrypt(string src) {
        if (!cipher.isValidKey(kGroup.key(), englishAlphabet)) return no!Result;
        return some(cipher.decrypt(src, kGroup.key()));
    }
}
