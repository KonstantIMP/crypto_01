module ui.page.permutation;

import adw.PreferencesPage;
import adw.ComboRow;

import ui.widget.crypt_group;
import ui.widget.permutation_group;

class PermutationCipherPage : PreferencesPage {
    public this() {
        add(new CryptGroup());
        add(new PermutationsGroup());
    }
}
