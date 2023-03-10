module ui.widget.crypt_group;

import adw.ButtonContent;
import adw.Clamp;
import adw.PreferencesGroup;
import adw.PreferencesRow;
import adw.StyleManager;

import gtk.Box;
import gtk.Button;
import gtk.Grid;
import gtk.ScrolledWindow;
import gtk.Window;

import sourceview.Buffer;
import sourceview.StyleSchemeManager;
import sourceview.LanguageManager;
import sourceview.View;

import std.uni : toLower;

import crypto.result;
import cryptor;

class CryptGroup : PreferencesGroup {
    private PreferencesRow textInputRow;
    private Button encrypt, decrypt;
    private Box control, content;

    private StyleManager styleManager;

    private Buffer buffer;
    private View textView;

    private Cryptor cryptor;

    @property string text() { return buffer.getText().toLower(); }

    public this(Cryptor cryptor = null) {
        setTitle("Encryption and Decryption");
        setDescription("Use this block to encrypt and decrypt text");
        
        textInputRow = new PreferencesRow();
        textInputRow.setTitle("Enter text here");

        encrypt = buildButtonWithContent("Encrypt", "channel-secure-symbolic");
        decrypt = buildButtonWithContent("Decrypt", "dialog-password-symbolic");

        content = new Box(GtkOrientation.VERTICAL  , 10);
        control = new Box(GtkOrientation.HORIZONTAL, 10);

        control.append(encrypt); control.append(decrypt);
        control.setVexpand(false); content.setHexpand(true);
        control.setHomogeneous(true);

        buffer = new Buffer(LanguageManager.getDefault().getLanguage("markdown"));
        buffer.setStyleScheme(StyleSchemeManager.getDefault().getScheme("Adwaita"));
        connectThemeChanging();
        
        textView = new View(buffer);
        textView.setShowLineNumbers(true);
        textView.setShowLineMarks(true);
        textView.setHighlightCurrentLine(true);
        textView.setBackgroundPattern(GtkSourceBackgroundPatternType.NONE);
        textView.addCssClass("rounded_text_view");

        auto textScrollView = new ScrolledWindow();
        textScrollView.setVexpand(true);
        textScrollView.setHexpand(true);
        textScrollView.setChild(textView);
        textScrollView.setMinContentHeight(250);

        content.append(textScrollView);
        content.append(control);
        foreach (string direction; ["top", "start", "bottom", "end"]) {
            content.setProperty("margin-" ~ direction, 10);
        }

        textInputRow.setChild(content);
        applyStyleForEditor();
        add(textInputRow);

        this.cryptor = cryptor;
        connectSignals();
    }

    private void connectSignals() {   
        import optional;

        encrypt.addOnClicked((btn) { 
            if (cryptor !is null) {
                cryptor.encrypt(buffer.getText().toLower()).match!(
                    (Result res) { setResult(res); },
                    () { cryptErrorMsg(); },
                );
            }
        });
        
        decrypt.addOnClicked((btn) {
            if (cryptor !is null) {
                cryptor.decrypt(buffer.getText().toLower()).match!(
                    (Result res) { setResult(res); },
                    () { cryptErrorMsg(); },
                );
            }
        });
    }

    private void cryptErrorMsg() {        
        import gtk.MessageDialog;

        auto md = new MessageDialog(
            getToplevel(),
            GtkDialogFlags.MODAL,
            GtkMessageType.ERROR,
            GtkButtonsType.OK,
            "Invalid options"
        );
        md.addOnResponse( (res, d) { d.close(); } );
        md.show();
    }

    private Window getToplevel() {
        auto widget = getParent();
        while (widget.getParent() !is null) {
            widget = widget.getParent();
        }
        return cast(Window)widget;
    }

    private void applyStyleForEditor() {
        import gtk.CssProvider, gtk.StyleContext, gdk.Display;
        
        auto provider = new CssProvider();
        provider.loadFromData(".rounded_text_view { border-radius: 8px; border: 1px solid #999999; }");

        StyleContext.addProviderForDisplay(
            Display.getDefault(), provider, GTK_STYLE_PROVIDER_PRIORITY_USER
        );
    }

    public static Button buildButtonWithContent(string label, string iconName) {
        auto content = new ButtonContent();
        content.setLabel(label);
        content.setIconName(iconName);

        auto btn = new Button();
        btn.setChild(content);
        return btn;
    }

    private void connectThemeChanging() {
        styleManager = StyleManager.getDefault();
        styleManager.addOnNotify((ps, go) {
            buffer.setStyleScheme(
                StyleSchemeManager.getDefault().getScheme("Adwaita" ~ (styleManager.getDark() ? "-dark" : ""))
            );
        }, "dark");
    }

    private void setResult(Result res) {
        buffer.setText(res.msg);
    }
}
