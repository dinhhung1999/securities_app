
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalService {
  final String kKeyUid = 'key_uid';

  //NOTE: List key not delete when user logout
  final List<String> keyExcludes = [];

  final SharedPreferences sharedPreferences = GetIt.instance.get();

  bool isAuthorized() {
    return sharedPreferences.containsKey(kKeyUid);
  }

  int? getUid() {
    if (isAuthorized()) {
      return sharedPreferences.getInt(kKeyUid);
    } else {
      return null;
    }
  }


  List<String> getListString(String key) {
    return sharedPreferences.getStringList(key) ?? [];
  }

  Future saveListString(List<String> data, String key) {
    return sharedPreferences.setStringList(key, data);
  }

  Future saveUid(int? uid) {
    if (uid == null) {
      return clear();
    } else {
      return sharedPreferences.setInt(kKeyUid, uid);
    }
  }

  Future clear() async {
    final keys = sharedPreferences.getKeys();
    keys.removeAll(keyExcludes);
    for (final key in keys) {
      await sharedPreferences.remove(key);
    }
  }
}
