module ui.page.permutation;

import adw.PreferencesPage;

import ui.widget.crypt_group;
import ui.widget.permutation_group;

import cipher = crypto.permutation;
import crypto.result;

import optional;
import cryptor;

class PermutationCipherPage : PreferencesPage, Cryptor {
    private CryptGroup cGroup;
    private PermutationsGroup pGroup;

    public this() {
        cGroup = new CryptGroup(this);
        pGroup = new PermutationsGroup();

        add(cGroup); add(pGroup);
    }

    Optional!Result encrypt(string src) {
        if (!cipher.isValidPermutationMap(pGroup.key())) return no!Result;
        return some(cipher.encrypt(src, pGroup.key()));
    }

    Optional!Result decrypt(string src) {
        if (!cipher.isValidPermutationMap(pGroup.key())) return no!Result;
        return some(cipher.decrypt(src, pGroup.key()));
    }
}
