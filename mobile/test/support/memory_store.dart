import 'package:ponto_cego/core/data/local_store.dart';
import 'package:ponto_cego/core/data/models.dart';

class MemoryStore implements LocalStore {
  String? value;
  bool fail = false;
  int writes = 0;
  @override
  Future<String?> read() async => value;
  @override
  Future<void> write(String data) async {
    if (fail) throw const AppFailure('Armazenamento indisponível');
    value = data;
    writes++;
  }
}
