module ui.widget.freq_group;

import adw.ComboRow;
import adw.PreferencesGroup;
import adw.PreferencesRow;

import gtk.Box;
import gtk.Button;
import gtk.Grid;
import gtk.Label;
import gtk.ProgressBar;

import std.algorithm.searching : canFind;

import crypto.alphabet;
import textprovider;


class FrequencyGroup: PreferencesGroup {
    private string alphabet;

    private ProgressBar[char] bars;
    
    private PreferencesRow contentRow;
    private Button generate, clear;
    private Label countMsg;

    private TextProvider provider;

    public this(TextProvider provider, string alphabet = englishAlphabet) {
        setTitle("Frequency analysis");
        setDescription("See the information about the text");

        this.alphabet = alphabet;
        this.provider = provider;
        initBars();

        buildContent();
        connectSignals();
    }

    private void connectSignals() {
        clear.addOnClicked((btn) {
            countMsg.setMarkup(`<span weight="heavy" size="large">0</span>`);
            clearBars(); 
        });

        generate.addOnClicked((btn) {
            clearBars();

            size_t[char] data; size_t total = 0;
            foreach(char ch; provider.provideText()) {
                if (canFind(alphabet, ch)) {
                    if (ch !in data) data[ch] = 0;
                    data[ch]++; total++;
                }
            }

            import std.format;
            countMsg.setMarkup(
                `<span weight="heavy" size="large">%d</span>`.format(total)
            );

            foreach (k; data.byKeyValue) {
                bars[k.key].setFraction(
                    (cast(double)k.value) / (cast(double)total)
                );
            }
        });
    }

    private void initBars() {
        foreach (char ch; alphabet) {
            ProgressBar bar = new ProgressBar();
            //bar.setShowText(true); // Invalid orientation
            bar.setOrientation(GtkOrientation.VERTICAL);
            bar.setHexpand(false);
            bar.setVexpand(true);
            bar.setInverted(true);
            bars[ch] = bar;
        }
        clearBars();
    }

    private void clearBars() {
        foreach (char ch; alphabet) {
            bars[ch].setFraction(0.0);
        }
    }

    private void buildContent() {
        contentRow = new PreferencesRow();

        auto contentGrid = new Grid();
        contentGrid.setRowHomogeneous(true);
        contentGrid.setColumnHomogeneous(true);
        contentGrid.setColumnSpacing(10);
        contentGrid.setRowSpacing(10);

        foreach (string direction; ["top", "start", "bottom", "end"]) {
            contentGrid.setProperty("margin-" ~ direction, 10);
        }

        countMsg = new Label(`<span weight="heavy" size="large">0</span>`);
        countMsg.setUseMarkup(true);
        countMsg.setHalign(GtkAlign.END);
        
        auto totalMsg = new Label("Total number of letters is");
        totalMsg.setHalign(GtkAlign.START);

        contentGrid.attach(totalMsg, 0, 0, 7, 1);
        contentGrid.attach(countMsg, 7, 0, 1, 1);

        auto barsBox = new Box(GtkOrientation.HORIZONTAL, 5);
        barsBox.setHomogeneous(true);
        foreach (char ch; alphabet) {
            auto bbox = new Box(GtkOrientation.VERTICAL, 3);
            bbox.append(bars[ch]);
            bbox.append(new Label([ch]));
            barsBox.append(bbox);
        }

        contentGrid.attach(barsBox, 0, 1, 8, 8);

        import ui.widget.crypt_group;
        clear = CryptGroup.buildButtonWithContent("Clear", "folder-templates-symbolic");
        generate = CryptGroup.buildButtonWithContent("Process analysis", "system-search-symbolic");

        contentGrid.attach(generate, 0, 9, 4, 1);
        contentGrid.attach(clear, 4, 9, 4, 1);

        contentRow.setChild(contentGrid);
        add(contentRow);
    }
}
