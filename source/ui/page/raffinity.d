module ui.page.raffinity;

import adw.PreferencesPage;

import ui.widget.crypt_group;
import ui.widget.key_group;

import crypto.affinity : isValidKey;
import cipher = crypto.raffinity;
import crypto.alphabet;
import crypto.result;

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

    Result encrypt(string src) {
        return cipher.encrypt(src, k1.key(), k2.key());
    }

    Result decrypt(string src) {
        return cipher.decrypt(src, k1.key(), k2.key());
    }
}
