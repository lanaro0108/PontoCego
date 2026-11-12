import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:ponto_cego/core/data/demo_repository.dart';
import 'package:ponto_cego/core/data/local_store.dart';
import 'package:ponto_cego/core/data/models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'support/memory_store.dart';

const draft = NewReport(
  title: 'Desnível na porta da biblioteca',
  description: 'O desnível na entrada dificulta o acesso com cadeira de rodas.',
  category: Category.mobility,
  locationId: 'a-library',
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MemoryStore store;
  late DemoRepository repository;
  setUp(() async {
    store = MemoryStore();
    repository = DemoRepository(store);
    await repository.initialize();
  });
  test(
    'login valida credenciais e preserva sessão após reinicializar',
    () async {
      await expectLater(
        repository.signIn(demoEmail, 'senha errada'),
        throwsA(isA<AppFailure>()),
      );
      final user = await repository.signIn(
        '  COMUNIDADE@PONTOCEGO.DEMO ',
        demoPassword,
      );
      final restarted = DemoRepository(store);
      await restarted.initialize();
      expect((await restarted.currentUser())!.id, user.id);
      expect(store.value, isNot(contains(demoPassword)));
      expect(
        (jsonDecode(store.value!)['accounts'] as List).first['salt'],
        isNotEmpty,
      );
    },
  );
  test('cadastro local valida dados e impede e-mail duplicado', () async {
    await expectLater(
      repository.signUp('A', 'invalid', '123'),
      throwsA(isA<AppFailure>()),
    );
    final user = await repository.signUp(
      'Marina Lima',
      'marina@example.test',
      'Senha12345',
    );
    expect((await repository.currentUser())!.id, user.id);
    expect(
      (await repository.listReports()).where((r) => r.authorId == user.id),
      isEmpty,
    );
    await expectLater(
      repository.signUp('Outra Marina', 'MARINA@example.test', 'Senha12345'),
      throwsA(isA<AppFailure>()),
    );
  });
  test(
    'criação, autoria, detalhes, histórico e persistência real do adaptador',
    () async {
      SharedPreferences.setMockInitialValues({});
      final first = DemoRepository(PreferencesStore());
      await first.initialize();
      final user = await first.signIn(demoEmail, demoPassword);
      final report = await first.createReport(draft);
      final second = DemoRepository(PreferencesStore());
      await second.initialize();
      final loaded = await second.getReport(report.id);
      expect(loaded!.authorId, user.id);
      expect(loaded.organizationId, demoOrganizationId);
      expect(loaded.status, ReportStatus.open);
      expect(loaded.updates.single.note, contains('nenhum envio'));
      expect(loaded.title, draft.title);
      expect((await second.listReports()).length, 4);
      await second.initialize();
      expect((await second.listReports()).length, 4);
    },
  );
  test(
    'filtros combinam título sem acentos, local, status, categoria e autoria',
    () async {
      final user = await repository.signIn(demoEmail, demoPassword);
      await repository.createReport(draft);
      final reports = await repository.listReports();
      expect(
        const ReportFilter(
          query: 'DESNIVEL',
          status: ReportStatus.open,
          category: Category.mobility,
          locationId: 'a-library',
        ).apply(reports).single.title,
        draft.title,
      );
      expect(const ReportFilter(query: 'biblioteca').apply(reports).length, 1);
      expect(ReportFilter(authorId: user.id).apply(reports).length, 2);
      expect(
        const ReportFilter(
          status: ReportStatus.resolved,
          query: 'biblioteca',
        ).apply(reports),
        isEmpty,
      );
      expect(await repository.getReport('not-a-report'), isNull);
    },
  );
  test('não permite operação sem sessão ou local inválido', () async {
    await expectLater(repository.listReports(), throwsA(isA<AppFailure>()));
    await expectLater(
      repository.createReport(draft),
      throwsA(isA<AppFailure>()),
    );
    await repository.signIn(demoEmail, demoPassword);
    await expectLater(
      repository.createReport(
        const NewReport(
          title: 'Um relato de teste',
          description: 'Descrição de uma barreira observada.',
          category: Category.other,
          locationId: 'other-organization',
        ),
      ),
      throwsA(isA<AppFailure>()),
    );
    await expectLater(
      repository.createReport(
        const NewReport(
          title: '',
          description: '',
          category: Category.other,
          locationId: 'a-entry',
        ),
      ),
      throwsA(isA<AppFailure>()),
    );
  });
  test('falha ao gravar preserva dados e permite tentar novamente', () async {
    await repository.signIn(demoEmail, demoPassword);
    final before = store.value;
    store.fail = true;
    await expectLater(
      repository.createReport(draft),
      throwsA(isA<AppFailure>()),
    );
    expect(store.value, before);
    expect((await repository.listReports()).length, 3);
    store.fail = false;
    await repository.createReport(draft);
    expect((await repository.listReports()).length, 4);
  });
  test('criações simultâneas não sobrescrevem relatos', () async {
    await repository.signIn(demoEmail, demoPassword);
    final reports = await Future.wait([
      repository.createReport(draft),
      repository.createReport(draft),
    ]);
    expect(reports[0].id, isNot(reports[1].id));
    expect((await repository.listReports()).length, 5);
  });
  test('preferências, logout e nova sessão preservam os relatos', () async {
    await repository.signIn(demoEmail, demoPassword);
    final report = await repository.createReport(draft);
    await repository.savePreferences(
      const AccessibilityPreferences(highContrast: true, reduceMotion: true),
    );
    await repository.signOut();
    final restarted = DemoRepository(store);
    await restarted.initialize();
    expect(await restarted.currentUser(), isNull);
    expect((await restarted.getPreferences()).reduceMotion, isTrue);
    await restarted.signIn(demoEmail, demoPassword);
    expect(await restarted.getReport(report.id), isNotNull);
  });
  test(
    'dados ilegíveis não são apagados nem substituídos pelos exemplos',
    () async {
      store.value = 'broken data';
      final writes = store.writes;
      await expectLater(
        DemoRepository(store).initialize(),
        throwsA(isA<AppFailure>()),
      );
      expect(store.value, 'broken data');
      expect(store.writes, writes);
    },
  );
}
