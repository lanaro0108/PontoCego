import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/data/demo_repository.dart';
import '../core/data/local_store.dart';
import '../core/data/models.dart';
import '../core/data/repositories.dart';
import '../features/reports/photo_service.dart';

final repositoryProvider = Provider<CommunityRepository>(
  (ref) => DemoRepository(PreferencesStore()),
);
final photoServiceProvider = Provider<PhotoService>((ref) => PhotoService());
final appControllerProvider = ChangeNotifierProvider<AppController>(
  (ref) => AppController(ref.watch(repositoryProvider))..initialize(),
);

class AppController extends ChangeNotifier {
  AppController(this.repository);
  final CommunityRepository repository;
  bool ready = false;
  String? startupError;
  CommunityUser? user;
  List<BarrierReport> reports = [];
  List<Location> locations = [];
  AccessibilityPreferences preferences = const AccessibilityPreferences();
  bool _disposed = false;

  void _changed() {
    if (!_disposed) notifyListeners();
  }

  Future<void> initialize() async {
    ready = false;
    startupError = null;
    _changed();
    try {
      await repository.initialize();
      preferences = await repository.getPreferences();
      user = await repository.currentUser();
      await _reload();
      ready = true;
    } catch (e) {
      startupError = e is AppFailure
          ? e.message
          : 'Não foi possível iniciar. Tente novamente.';
    }
    _changed();
  }

  Future<void> _reload() async {
    if (user == null) {
      reports = [];
      locations = [];
      return;
    }
    reports = await repository.listReports();
    locations = await repository.listLocations();
  }

  Future<void> login(String email, String password) async {
    user = await repository.signIn(email, password);
    await _reload();
    _changed();
  }

  Future<void> register(String name, String email, String password) async {
    user = await repository.signUp(name, email, password);
    await _reload();
    _changed();
  }

  Future<void> logout() async {
    await repository.signOut();
    user = null;
    reports = [];
    locations = [];
    _changed();
  }

  Future<BarrierReport> create(NewReport input) async {
    final report = await repository.createReport(input);
    await _reload();
    _changed();
    return report;
  }

  Future<void> refresh() async {
    await _reload();
    _changed();
  }

  BarrierReport? report(String id) =>
      reports.where((r) => r.id == id).firstOrNull;
  Future<void> setPreferences(AccessibilityPreferences value) async {
    await repository.savePreferences(value);
    preferences = value;
    _changed();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

String errorMessage(Object error) => error is AppFailure
    ? error.message
    : 'Não foi possível concluir. Tente novamente.';
