import 'package:shared_preferences/shared_preferences.dart';
import 'models.dart';

abstract interface class LocalStore {
  Future<String?> read();
  Future<void> write(String data);
}

class PreferencesStore implements LocalStore {
  static const storageKey = 'ponto_cego.demo.v1';
  @override
  Future<String?> read() async =>
      (await SharedPreferences.getInstance()).getString(storageKey);
  @override
  Future<void> write(String data) async {
    final saved = await (await SharedPreferences.getInstance()).setString(
      storageKey,
      data,
    );
    if (!saved) {
      throw const AppFailure(
        'Não foi possível salvar no dispositivo. Libere espaço e tente novamente.',
      );
    }
  }
}
