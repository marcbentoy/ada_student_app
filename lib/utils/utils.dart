import 'package:shared_preferences/shared_preferences.dart';

Future<String> getPbUrl() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  return prefs.getString("pbUrl") ?? "http://192.168.1.48:8090";
}
