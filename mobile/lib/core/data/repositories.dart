import 'models.dart';

abstract interface class CommunityRepository
    implements
        AuthRepository,
        ReportsRepository,
        LocationsRepository,
        PreferencesRepository {
  Future<void> initialize();
}

abstract interface class AuthRepository {
  Future<CommunityUser?> currentUser();
  Future<CommunityUser> signIn(String email, String password);
  Future<CommunityUser> signUp(String name, String email, String password);
  Future<void> signOut();
}

abstract interface class ReportsRepository {
  Future<List<BarrierReport>> listReports();
  Future<BarrierReport?> getReport(String id);
  Future<BarrierReport> createReport(NewReport report);
}

abstract interface class LocationsRepository {
  Future<List<Location>> listLocations();
}

abstract interface class PreferencesRepository {
  Future<AccessibilityPreferences> getPreferences();
  Future<void> savePreferences(AccessibilityPreferences preferences);
}
