module ui.widget.color_scheme_button;

import adw.StyleManager;
import gtk.Button;
import gtk.Widget;


class ColorSchemeButton : Button {
    public this(Widget instance) {
        super((cast(Button)instance).getButtonStruct(), true);

        setSchemeIcon();
        this.addOnClicked(&onButtonClicked);
    }

    private void setSchemeIcon() {
        StyleManager manager = StyleManager.getDefault();

        this.setIconName(
            "weather-clear" ~
            (!manager.getDark() ? "-night" : "") ~
            "-symbolic"
        );
    }

    protected void onButtonClicked(Button) {
        StyleManager manager = StyleManager.getDefault();
        
        manager.setColorScheme(
            manager.getDark() ?
            AdwColorScheme.FORCE_LIGHT :
            AdwColorScheme.FORCE_DARK
        );
        setSchemeIcon();
    }
}

