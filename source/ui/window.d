module ui.window;

import adw.Window;
import adw.Leaflet;
import gtk.Builder;
import gtk.Button;
import gobject.ObjectG;
import gobject.ParamSpec;
import gtk.Widget;

import ui.widget.color_scheme_button;


class MainWindow: Window {
    private Widget[string] children;

    public this(ref Builder ui) {
        import adw.c.types : AdwWindow;
        super(cast(AdwWindow *)(cast(Window)ui.getObject("window")).getWindowStruct(), true);

        connectObjects(ui);
        connectSignals();
        setupPages();
    }


    private void connectObjects(ref Builder ui) {
        foreach (string name; [
            "color_scheme_button",
            "navigation",
            "back",
            "stack"
        ]) {
            children[name] = cast(Widget)ui.getObject(name);
        }
    }


    private void connectSignals() {
        new ColorSchemeButton(children["color_scheme_button"]);

        children["stack"].addOnNotify(&stackVisibleChildChanged, "visible-child");
        (cast(Button)children["back"]).addOnClicked(&backButtonPressed);
    }


    private void setupPages() {
        import gtk.Stack, ui.page.permutation;
        Stack stack = cast(Stack)children["stack"];
        stack.addTitled(new PermutationCipherPage(), "permutations", "Simple permutation cipher");
    }


    protected void stackVisibleChildChanged(ParamSpec, ObjectG) {
        Leaflet leaflet = cast(Leaflet)children["navigation"];
        leaflet.navigate(AdwNavigationDirection.FORWARD);
    }


    protected void backButtonPressed(Button) {
        Leaflet leaflet = cast(Leaflet)children["navigation"];
        leaflet.navigate(AdwNavigationDirection.BACK);
    }
}

