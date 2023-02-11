module ui.widget.key_group;

import adw.PreferencesGroup;
import adw.PreferencesRow;

import gtk.Grid;
import gtk.InfoBar;
import gtk.Label;
import gtk.Image;
import gtk.SpinButton;

import gdkpixbuf.Pixbuf;

import std.format;

import crypto.alphabet;

class KeyGroup: PreferencesGroup {
    private PreferencesRow contentRow;
    private SpinButton alpha, betta;
    private InfoBar errorBar;
    private Label errorMsg;

    private string alphabet;
    
    public this(string alphabet = englishAlphabet) {
        setTitle("Key pair settings");
        setDescription("Set the key's field to process text");

        this.alphabet = alphabet;
        
        buildContent();
        applyStyleForBar();

        alpha.addOnValueChanged( (SpinButton sb) {
            import crypto.affinity, crypto.key;

            if (!isValidKey(Key(cast(ulong)sb.getValue(), 1), alphabet)) {
                errorMsg.setText((
                    `Invalid α for the given alphabet: gcd(%d, %d) != 1`.format(
                        cast(ulong)sb.getValue(), alphabet.length
                    )
                ));
                errorBar.setRevealed(true);
                errorBar.setMarginBottom(10);
            } else {
                errorBar.setRevealed(false);
                errorBar.setMarginBottom(0);
            }
        });
    }

    private void buildContent() {
        contentRow = new PreferencesRow();
        contentRow.setTitle("Alfa and Betta settings");

        auto contentGrid = new Grid();
        contentGrid.setRowHomogeneous(false);
        contentGrid.setColumnHomogeneous(true);
        contentGrid.setRowSpacing(10);
        contentGrid.setColumnSpacing(10);

        foreach (string direction; ["top", "start", "end"]) {
            contentGrid.setProperty("margin-" ~ direction, 10);
        }

        contentGrid.setVexpand(false);
        contentGrid.setHexpand(true);

        errorMsg = new Label("");
        errorMsg.setHexpand(true);

        errorBar = new InfoBar();
        errorBar.setMessageType(GtkMessageType.ERROR);
        errorBar.setShowCloseButton(false);
        errorBar.setRevealed(false);
        errorBar.setMarginBottom(0);
        
        auto i = new Image();
        i.setMarginStart(4);
        i.setFromIconName("dialog-warning-symbolic");
        errorBar.addChild(i);

        errorBar.addChild(errorMsg);
        errorBar.getFirstChild().addCssClass("rounded_bar");

        contentGrid.attach(errorBar, 0, 1, 8, 1);

        contentGrid.attach(buildKeyLabel("α"), 0, 0, 2, 1);
        contentGrid.attach(buildKeyLabel("β"), 4, 0, 2, 1);
        
        alpha = new SpinButton(1.0, 65_535.0, 1.0);
        betta = new SpinButton(1.0, 65_535.0, 1.0);

        contentGrid.attach(alpha, 2, 0, 2, 1);
        contentGrid.attach(betta, 6, 0, 2, 1);

        contentRow.setChild(contentGrid);
        add(contentRow);
    }

    private Label buildKeyLabel(string l) {
        Label result = new Label(
            `Set the key's <span size="large" weight="ultrabold">%s</span>`.format(l)
        );
        result.setUseMarkup(true);
        result.setHalign(GtkAlign.START);
        return result;
    }

    private void applyStyleForBar() {
        import gtk.CssProvider, gtk.StyleContext, gdk.Display;
        
        auto provider = new CssProvider();
        provider.loadFromData(".rounded_bar { border-radius: 8px; }");

        StyleContext.addProviderForDisplay(
            Display.getDefault(), provider, GTK_STYLE_PROVIDER_PRIORITY_USER
        );
    }
}
