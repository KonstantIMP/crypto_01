module ui.page.permutation;

import adw.PreferencesPage;

import ui.widget.crypt_group;
import ui.widget.permutation_group;

class PermutationCipherPage : PreferencesPage {
    public this() {
        add(new CryptGroup());
        add(new PermutationsGroup());
    }
}
