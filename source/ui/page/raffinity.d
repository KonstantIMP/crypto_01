module ui.page.raffinity;

import adw.PreferencesPage;

import ui.widget.crypt_group;
import ui.widget.key_group;

class RAffinityCipherPage : PreferencesPage {
    public this() {
        add(new CryptGroup());
        add(new KeyGroup());
        add(new KeyGroup());
    }
}
