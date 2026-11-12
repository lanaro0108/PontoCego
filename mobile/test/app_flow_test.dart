import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ponto_cego/app/app.dart';
import 'package:ponto_cego/app/app_controller.dart';
import 'package:ponto_cego/app/router.dart';
import 'package:ponto_cego/core/data/demo_repository.dart';
import 'package:ponto_cego/core/data/models.dart';
import 'support/memory_store.dart';

Future<AppController> openApp(
  WidgetTester tester,
  MemoryStore store, {
  bool authenticated = false,
}) async {
  final app = (await tester.runAsync(() async {
    final app = AppController(DemoRepository(store));
    await app.initialize();
    if (authenticated) await app.login(demoEmail, demoPassword);
    return app;
  }))!;
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [appControllerProvider.overrideWith((ref) => app)],
      child: const PontoCegoApp(),
    ),
  );
  await tester.pumpAndSettle();
  return app;
}

Future<void> tap(WidgetTester tester, Finder finder) async {
  if (finder.evaluate().isEmpty) {
    await tester.scrollUntilVisible(
      finder,
      300,
      scrollable: find.byType(Scrollable).last,
      maxScrolls: 25,
    );
  }
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> waitForOperation(
  WidgetTester tester,
  Finder button,
  bool Function() done,
) async {
  await tester.ensureVisible(button);
  await tester.pumpAndSettle();
  await tester.tap(button);
  for (var i = 0; i < 400 && !done(); i++) {
    await tester.pump(const Duration(milliseconds: 20));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 2)),
    );
  }
  await tester.pumpAndSettle();
  expect(done(), isTrue);
}

void main() {
  testWidgets(
    'Entrar → registrar → local → confirmar → meus relatos → detalhe → reiniciar → logout',
    (tester) async {
      final store = MemoryStore();
      var app = await openApp(tester, store);
      await tap(tester, find.text('Preencher acesso de demonstração'));
      await waitForOperation(
        tester,
        find.widgetWithText(FilledButton, 'Entrar'),
        () => app.user != null,
      );
      expect(find.text('Olá, Ana.'), findsOneWidget);
      await tap(tester, find.text('Registrar barreira'));
      await tester.enterText(
        find.byType(TextFormField).at(0),
        'Acesso obstruído à biblioteca',
      );
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'Uma mesa está bloqueando a passagem para a biblioteca.',
      );
      await tap(tester, find.byType(DropdownButtonFormField<Category>));
      await tap(tester, find.text('Acesso').last);
      await tap(tester, find.text('Selecionar localização *'));
      await tester.enterText(find.byType(TextField), 'biblioteca');
      await tester.pumpAndSettle();
      await tap(tester, find.text('Biblioteca'));
      expect(find.text('Bloco A · Biblioteca'), findsOneWidget);
      await tap(tester, find.text('Revisar relato'));
      expect(find.textContaining('Proteja a privacidade'), findsOneWidget);
      await waitForOperation(
        tester,
        find.text('Confirmar registro local'),
        () => app.reports.length == 4,
      );
      expect(find.text('Seu relato\nestá salvo.'), findsOneWidget);
      await tap(tester, find.text('Ver meu relato'));
      expect(find.text('Detalhes do relato'), findsOneWidget);
      expect(find.text('Acesso obstruído à biblioteca'), findsOneWidget);
      expect(app.reports.first.authorId, app.user!.id);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      await tap(tester, find.text('Meus relatos'));
      expect(find.text('Acesso obstruído à biblioteca'), findsOneWidget);
      await tap(tester, find.text('Acesso obstruído à biblioteca'));
      expect(find.textContaining('Uma mesa está bloqueando'), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
      app = await openApp(tester, store);
      expect(find.text('Olá, Ana.'), findsOneWidget);
      await tap(tester, find.text('Meus relatos'));
      expect(find.text('Acesso obstruído à biblioteca'), findsOneWidget);
      await tap(tester, find.text('Perfil'));
      await tap(tester, find.widgetWithText(OutlinedButton, 'Sair da conta'));
      await waitForOperation(
        tester,
        find.widgetWithText(FilledButton, 'Sair da conta'),
        () => app.user == null,
      );
      expect(find.widgetWithText(FilledButton, 'Entrar'), findsOneWidget);
      expect(await app.repository.currentUser(), isNull);
      expect(store.value, contains('Acesso obstruído à biblioteca'));
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('validação impede login e registro incompletos', (tester) async {
    final app = await openApp(tester, MemoryStore());
    await tap(tester, find.widgetWithText(FilledButton, 'Entrar'));
    expect(find.text('Informe um e-mail válido.'), findsOneWidget);
    expect(app.user, isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    final signedIn = await openApp(tester, MemoryStore(), authenticated: true);
    await tap(tester, find.text('Registrar barreira'));
    await tap(tester, find.text('Revisar relato'));
    expect(find.text('Selecione uma categoria.'), findsOneWidget);
    expect(find.text('Selecione um bloco e ambiente.'), findsOneWidget);
    expect(signedIn.reports.length, 3);
    expect(find.text('Confira seu relato'), findsNothing);
  });
  testWidgets('busca e filtros preservam estado ao trocar abas', (
    tester,
  ) async {
    await openApp(tester, MemoryStore(), authenticated: true);
    await tap(tester, find.text('Ocorrências'));
    await tester.enterText(find.byType(TextField), 'SINALIZACAO');
    await tester.pumpAndSettle();
    expect(find.text('Sinalização de orientação ausente'), findsOneWidget);
    expect(find.text('Desnível no acesso ao bloco A'), findsNothing);
    await tap(tester, find.text('Início'));
    await tap(tester, find.text('Ocorrências'));
    expect(find.text('SINALIZACAO'), findsOneWidget);
    await tap(tester, find.text('Resolvida'));
    expect(find.text('Nenhum relato com esses filtros.'), findsOneWidget);
    await tap(tester, find.text('Limpar filtros').first);
    expect(find.text('Desnível no acesso ao bloco A'), findsOneWidget);
  });
  testWidgets('relato inexistente apresenta recuperação', (tester) async {
    final app = await openApp(tester, MemoryStore(), authenticated: true);
    final context = tester.element(find.byType(PontoCegoApp));
    final container = ProviderScope.containerOf(context);
    container.read(routerProvider).go('/reports/missing');
    await tester.pumpAndSettle();
    expect(find.text('Relato não encontrado.'), findsOneWidget);
    expect(app.reports.length, 3);
    await tap(tester, find.text('Ver ocorrências'));
    expect(find.text('Ocorrências'), findsWidgets);
  });
  testWidgets('texto ampliado, movimento reduzido e alvos acessíveis', (
    tester,
  ) async {
    await openApp(tester, MemoryStore(), authenticated: true);
    final semantics = tester.ensureSemantics();

    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    semantics.dispose();
    tester.view.physicalSize = const Size(320, 800);
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tap(tester, find.text('Registrar barreira'));
    expect(tester.takeException(), isNull);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await tap(tester, find.text('Perfil'));
    expect(tester.takeException(), isNull);
  });
}
