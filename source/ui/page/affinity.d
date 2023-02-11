module ui.page.affinity;

import adw.PreferencesPage;

import ui.widget.crypt_group;
import ui.widget.key_group;

class AffinityCipherPage : PreferencesPage {
    public this() {
        add(new CryptGroup());
        add(new KeyGroup());
    }
}
