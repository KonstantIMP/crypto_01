module ui.page.affinity;

import adw.PreferencesPage;

import ui.widget.crypt_group;
import ui.widget.key_group;

import cipher = crypto.affinity;
import crypto.result;

import cryptor;

class AffinityCipherPage : PreferencesPage, Cryptor {
    private CryptGroup cgroup;
    private KeyGroup kGroup;

    public this() {
        cgroup = new CryptGroup(this);
        kGroup = new KeyGroup();

        add(cgroup); add(kGroup);
    }

    Result encrypt(string src) {
        return cipher.encrypt(src, kGroup.key());
    }

    Result decrypt(string src) {
        return cipher.decrypt(src, kGroup.key());
    }
}
