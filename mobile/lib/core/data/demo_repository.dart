import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:cryptography/cryptography.dart';
import 'local_store.dart';
import 'models.dart';
import 'repositories.dart';

class DemoRepository implements CommunityRepository {
  DemoRepository(this.store);
  final LocalStore store;
  Map<String, dynamic>? _data;
  Future<void> _pending = Future.value();
  final _passwords = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: 100000,
    bits: 256,
  );
  String _id() => List.generate(
    16,
    (_) => Random.secure().nextInt(256).toRadixString(16).padLeft(2, '0'),
  ).join();
  Future<String> _derive(String password, String salt) async => base64Encode(
    await (await _passwords.deriveKey(
      secretKey: SecretKey(utf8.encode(password)),
      nonce: base64Decode(salt),
    )).extractBytes(),
  );

  @override
  Future<void> initialize() async {
    try {
      final raw = await store.read();
      if (raw != null) {
        final decoded = jsonDecode(raw) as Map<String, dynamic>;
        if (decoded['schema'] != 1 ||
            decoded['accounts'] is! List ||
            decoded['reports'] is! List) {
          throw const FormatException();
        }
        for (final report in decoded['reports'] as List) {
          BarrierReport.fromJson(Map<String, dynamic>.from(report as Map));
        }
        _data = decoded;
        return;
      }
      final user = const CommunityUser(
        id: 'demo-community',
        name: 'Ana',
        email: demoEmail,
        organizationId: demoOrganizationId,
      );
      final salt = base64Encode(
        List.generate(16, (_) => Random.secure().nextInt(256)),
      );
      final now = DateTime.now().toUtc();
      final reports = [
        BarrierReport(
          id: 'example-entry',
          organizationId: demoOrganizationId,
          authorId: 'example-author',
          locationId: 'a-entry',
          title: 'Desnível no acesso ao bloco A',
          description:
              'Exemplo fictício: um desnível na entrada pode dificultar a circulação de pessoas com mobilidade reduzida.',
          category: Category.mobility,
          status: ReportStatus.progress,
          createdAt: now.subtract(const Duration(days: 3)),
          updates: [
            ReportUpdate(
              status: ReportStatus.open,
              note: 'Relato fictício registrado para demonstração.',
              at: now.subtract(const Duration(days: 3)),
            ),
            ReportUpdate(
              status: ReportStatus.review,
              note: 'Exemplo de triagem institucional.',
              at: now.subtract(const Duration(days: 2)),
            ),
            ReportUpdate(
              status: ReportStatus.progress,
              note: 'Exemplo: equipe responsável avalia uma intervenção.',
              at: now.subtract(const Duration(days: 1)),
            ),
          ],
        ),
        BarrierReport(
          id: 'example-sign',
          organizationId: demoOrganizationId,
          authorId: user.id,
          locationId: 'b-lab',
          title: 'Sinalização de orientação ausente',
          description:
              'Exemplo fictício de uma sinalização de acesso que precisa ser avaliada no ambiente.',
          category: Category.signage,
          status: ReportStatus.open,
          createdAt: now.subtract(const Duration(hours: 4)),
          updates: [
            ReportUpdate(
              status: ReportStatus.open,
              note: 'Relato fictício recebido. Aguardando análise.',
              at: now.subtract(const Duration(hours: 4)),
            ),
          ],
        ),
        BarrierReport(
          id: 'example-path',
          organizationId: demoOrganizationId,
          authorId: 'example-author',
          locationId: 'common',
          title: 'Passagem na área comum',
          description:
              'Exemplo fictício de passagem que estava obstruída e teve o acesso reorganizado.',
          category: Category.access,
          status: ReportStatus.resolved,
          createdAt: now.subtract(const Duration(days: 5)),
          updates: [
            ReportUpdate(
              status: ReportStatus.open,
              note: 'Relato fictício registrado.',
              at: now.subtract(const Duration(days: 5)),
            ),
            ReportUpdate(
              status: ReportStatus.resolved,
              note: 'Exemplo de retorno da instituição: passagem desobstruída.',
              at: now.subtract(const Duration(days: 2)),
            ),
          ],
        ),
      ];
      final initial = {
        'schema': 1,
        'accounts': [
          {
            ...user.toJson(),
            'salt': salt,
            'passwordHash': await _derive(demoPassword, salt),
          },
        ],
        'session': null,
        'reports': reports.map((r) => r.toJson()).toList(),
        'preferences': const AccessibilityPreferences().toJson(),
      };
      await store.write(jsonEncode(initial));
      _data = initial;
    } catch (e) {
      if (e is AppFailure) rethrow;
      throw const AppFailure(
        'Não foi possível abrir os dados locais. Eles foram preservados. Tente reabrir o aplicativo.',
      );
    }
  }

  Future<T> _mutate<T>(T Function(Map<String, dynamic>) change) {
    final result = Completer<T>();
    _pending = _pending.then((_) async {
      try {
        final next = jsonDecode(jsonEncode(_data)) as Map<String, dynamic>;
        final value = change(next);
        await store.write(jsonEncode(next));
        _data = next;
        result.complete(value);
      } catch (e, stack) {
        result.completeError(
          e is AppFailure
              ? e
              : const AppFailure(
                  'Não foi possível salvar os dados. Tente novamente.',
                ),
          stack,
        );
      }
    });
    return result.future;
  }

  List<Map<String, dynamic>> get _accounts => (_data!['accounts'] as List)
      .map((a) => Map<String, dynamic>.from(a as Map))
      .toList();
  @override
  Future<CommunityUser?> currentUser() async {
    final id = _data!['session'];
    for (final account in _accounts) {
      if (account['id'] == id) return CommunityUser.fromJson(account);
    }
    return null;
  }

  Future<CommunityUser> _requireUser() async =>
      (await currentUser()) ??
      (throw const AppFailure('Entre novamente para continuar.'));
  @override
  Future<CommunityUser> signIn(String email, String password) async {
    final normalized = email.trim().toLowerCase();
    final account = _accounts
        .where((a) => a['email'] == normalized)
        .firstOrNull;
    if (account == null) throw const AppFailure('E-mail ou senha incorretos.');
    final actual = base64Decode(
      await _derive(password, account['salt'] as String),
    );
    final expected = base64Decode(account['passwordHash'] as String);
    var difference = actual.length ^ expected.length;
    for (var i = 0; i < min(actual.length, expected.length); i++) {
      difference |= actual[i] ^ expected[i];
    }
    if (difference != 0) throw const AppFailure('E-mail ou senha incorretos.');
    return _mutate((data) {
      data['session'] = account['id'];
      return CommunityUser.fromJson(account);
    });
  }

  @override
  Future<CommunityUser> signUp(
    String name,
    String email,
    String password,
  ) async {
    final error =
        requiredText(name, min: 2, max: 80) ??
        validateEmail(email) ??
        validatePassword(password);
    if (error != null) throw AppFailure(error);
    final normalized = email.trim().toLowerCase();
    final salt = base64Encode(
      List.generate(16, (_) => Random.secure().nextInt(256)),
    );
    final hash = await _derive(password, salt);
    return _mutate((data) {
      final accounts = data['accounts'] as List;
      if (accounts.any((a) => a['email'] == normalized)) {
        throw const AppFailure(
          'Este e-mail já tem um cadastro local. Entre com sua senha.',
        );
      }
      final user = CommunityUser(
        id: _id(),
        name: name.trim(),
        email: normalized,
        organizationId: demoOrganizationId,
      );
      accounts.add({...user.toJson(), 'salt': salt, 'passwordHash': hash});
      data['session'] = user.id;
      return user;
    });
  }

  @override
  Future<void> signOut() => _mutate((data) {
    data['session'] = null;
  });
  @override
  Future<List<Location>> listLocations() async {
    final user = await _requireUser();
    return demoLocations
        .where((l) => l.organizationId == user.organizationId)
        .toList();
  }

  @override
  Future<List<BarrierReport>> listReports() async {
    final user = await _requireUser();
    return (_data!['reports'] as List)
        .map((r) => BarrierReport.fromJson(Map<String, dynamic>.from(r as Map)))
        .where((r) => r.organizationId == user.organizationId)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<BarrierReport?> getReport(String id) async =>
      (await listReports()).where((r) => r.id == id).firstOrNull;
  @override
  Future<BarrierReport> createReport(NewReport input) async {
    final user = await _requireUser();
    final error =
        requiredText(input.title, min: 5, max: 100) ??
        requiredText(input.description, min: 15, max: 2000);
    if (error != null) throw AppFailure(error);
    if (!demoLocations.any(
      (l) =>
          l.id == input.locationId && l.organizationId == user.organizationId,
    )) {
      throw const AppFailure('Escolha um ambiente válido da instituição.');
    }
    if (input.photoBase64 != null) {
      try {
        if (base64Decode(input.photoBase64!).length > 1024 * 1024) {
          throw const FormatException();
        }
      } catch (_) {
        throw const AppFailure('A imagem deve ser válida e ter até 1 MB.');
      }
    }
    final now = DateTime.now().toUtc();
    final report = BarrierReport(
      id: _id(),
      organizationId: user.organizationId,
      authorId: user.id,
      locationId: input.locationId,
      title: input.title.trim(),
      description: input.description.trim(),
      category: input.category,
      status: ReportStatus.open,
      createdAt: now,
      photoBase64: input.photoBase64,
      updates: [
        ReportUpdate(
          status: ReportStatus.open,
          note:
              'Salvo neste dispositivo. Aguardando integração institucional; nenhum envio ao servidor foi realizado.',
          at: now,
        ),
      ],
    );
    return _mutate((data) {
      if (data['session'] != user.id) {
        throw const AppFailure('A sessão mudou. Entre novamente.');
      }
      (data['reports'] as List).add(report.toJson());
      return report;
    });
  }

  @override
  Future<AccessibilityPreferences> getPreferences() async =>
      AccessibilityPreferences.fromJson(
        Map<String, dynamic>.from(_data!['preferences'] as Map),
      );
  @override
  Future<void> savePreferences(AccessibilityPreferences preferences) =>
      _mutate((data) {
        data['preferences'] = preferences.toJson();
      });
}
