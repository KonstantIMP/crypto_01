module ui.widget.permutation_group;

import adw.ComboRow;
import adw.PreferencesGroup;
import adw.PreferencesRow;

import gtk.Grid;
import gtk.StringList;

import std.format;
import std.string : indexOf;

import crypto.alphabet;


class PermutationsGroup: PreferencesGroup {
    private StringList lettersStore;
    private string alphabet;

    private ComboRow[char] lettersMap;
    private char[char] permutation;

    private PreferencesRow contentRow;

    public this(string alphabet = englishAlphabet) {
        setTitle("Key settings");
        setDescription("Set up a permutation for the simple replacement cipher");
    
        this.alphabet = alphabet;
        initLettersStore();
        initLettersMap();

        buildContent();
    }

    private void initLettersStore() {
        string [] list = new string[alphabet.length];
        foreach (size_t i, char ch; alphabet) {
            list[i] = [ch];
        }
        lettersStore = new StringList(list);
    }

    private void initLettersMap() {
        import gio.ListModelIF;

        foreach (size_t i, char ch; alphabet) {
            auto row = new ComboRow();

            row.setModel(cast(ListModelIF)lettersStore);
            row.setSelected(cast(uint)((i + 1) % alphabet.length));
            row.setSelectable(true);

            row.setTitle("<span weight=\"heavy\">%c</span>".format(ch));
            row.setSubtitle("will be replaced by");

            row.setProperty("use-markup", true);
            row.setVexpand(true);
            row.setHexpand(false);

            row.addOnNotify( (spec, obj) {
                string title = (cast(ComboRow)obj).getTitle();
                letterChanged(title[title.indexOf('>') + 1]);
            }, "selected");

            permutation[ch] = alphabet[(i + 1) % alphabet.length];
            lettersMap[ch] = row;
        }
    }

    private void buildContent() {
        contentRow = new PreferencesRow();
        contentRow.setTitle("Configure permutation");

        foreach (size_t i, char ch; alphabet) {
            add(lettersMap[ch]);
        }
    }

    private void letterChanged(char letter) {
        char from = permutation[letter];
        char to = alphabet[lettersMap[letter].getSelected()];

        char victim;
        foreach (e; permutation.byKeyValue) {
            if (e.value == to) {
                victim = e.key; break;
            }
        }

        lettersMap[victim].setSelected(cast(uint)alphabet.indexOf(from));
        permutation[victim] = from;
        permutation[letter] = to;
    }
}
