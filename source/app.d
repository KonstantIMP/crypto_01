import adw.Application;
import gtk.Builder;
import r : R;

import ui.window;

int main(string [] args) {
  auto cryptoApp = new Application(
    "org.kimp.crypto",
    GApplicationFlags.FLAGS_NONE | GApplicationFlags.CAN_OVERRIDE_APP_ID
  );

  cryptoApp.addOnActivate((app) {
    auto builder = new Builder();
    builder.addFromString(R.MAIN_WINDOW_LAYOUT, R.MAIN_WINDOW_LAYOUT.length);

    auto mainWindow = new MainWindow(builder);
    cryptoApp.addWindow(mainWindow);
    mainWindow.show();
  });

  return cryptoApp.run(args);
}


