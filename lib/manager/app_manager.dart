import 'package:event_bus/event_bus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppManager {
  static const String account = 'account';
  static EventBus eventBus;
  static SharedPreferences sharedPreference;

  static initApp() async {
    sharedPreference = await SharedPreferences.getInstance();
    eventBus = EventBus();
  }

  static bool isLogin() {
    return sharedPreference.getString(account) != null;
  }
}
