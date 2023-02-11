module ui.page.permutation;

import adw.PreferencesPage;

import ui.widget.crypt_group;
import ui.widget.permutation_group;

import cipher = crypto.permutation;
import crypto.result;

import cryptor;

class PermutationCipherPage : PreferencesPage, Cryptor {
    private CryptGroup cGroup;
    private PermutationsGroup pGroup;

    public this() {
        cGroup = new CryptGroup(this);
        pGroup = new PermutationsGroup();

        add(cGroup); add(pGroup);
    }

    Result encrypt(string src) {
        return cipher.encrypt(src, pGroup.key());
    }

    Result decrypt(string src) {
        return cipher.decrypt(src, pGroup.key());
    }
}
