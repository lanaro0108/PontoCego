import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/widgets/shared.dart';
import '../features/auth/auth_screen.dart';
import '../features/home/home_screen.dart';
import '../features/locations/locations_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/reports/new_report_screen.dart';
import '../features/reports/report_detail_screen.dart';
import '../features/reports/reports_screen.dart';
import 'app_controller.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final controller = ref.read(appControllerProvider);
  final root = GlobalKey<NavigatorState>();
  final router = GoRouter(
    navigatorKey: root,
    initialLocation: '/home',
    refreshListenable: controller,
    redirect: (context, state) {
      if (!controller.ready) return state.uri.path == '/boot' ? null : '/boot';
      final auth = state.uri.path == '/login' || state.uri.path == '/register';
      if (controller.user == null) return auth ? null : '/login';
      if (auth || state.uri.path == '/boot') return '/home';
      return null;
    },
    errorBuilder: (context, state) => Scaffold(
      body: SafeArea(
        child: EmptyMessage(
          title: 'Essa tela não foi encontrada.',
          message: 'Volte ao início para continuar.',
          action: 'Voltar ao início',
          onAction: () => context.go('/home'),
        ),
      ),
    ),
    routes: [
      GoRoute(path: '/boot', builder: (context, state) => const BootScreen()),
      GoRoute(path: '/login', builder: (context, state) => const AuthScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const AuthScreen(register: true),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/reports',
                builder: (context, state) => const ReportsScreen(),
                routes: [
                  GoRoute(
                    path: ':id',
                    parentNavigatorKey: root,
                    pageBuilder: (context, state) => _page(
                      context,
                      state,
                      ReportDetailScreen(id: state.pathParameters['id']!),
                    ),
                    routes: [
                      GoRoute(
                        path: 'success',
                        parentNavigatorKey: root,
                        pageBuilder: (context, state) => _page(
                          context,
                          state,
                          ReportSuccessScreen(id: state.pathParameters['id']!),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/mine',
                builder: (context, state) => const ReportsScreen(mine: true),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/new',
        pageBuilder: (context, state) =>
            _page(context, state, const NewReportScreen()),
      ),
      GoRoute(
        path: '/locations',
        pageBuilder: (context, state) => _page(
          context,
          state,
          LocationsScreen(selected: state.uri.queryParameters['selected']),
        ),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});

Page<dynamic> _page(BuildContext context, GoRouterState state, Widget child) =>
    CustomTransitionPage<dynamic>(
      key: state.pageKey,
      child: child,
      transitionDuration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : const Duration(milliseconds: 180),
      reverseTransitionDuration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : const Duration(milliseconds: 140),
      transitionsBuilder: (context, animation, secondary, child) =>
          FadeTransition(opacity: animation, child: child),
    );

class AppShell extends StatelessWidget {
  const AppShell(this.shell, {super.key});
  final StatefulNavigationShell shell;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: shell,
    bottomNavigationBar: NavigationBar(
      animationDuration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : const Duration(milliseconds: 200),
      selectedIndex: shell.currentIndex,
      onDestinationSelected: (index) =>
          shell.goBranch(index, initialLocation: index == shell.currentIndex),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Início',
        ),
        NavigationDestination(
          icon: Icon(Icons.place_outlined),
          selectedIcon: Icon(Icons.place),
          label: 'Ocorrências',
        ),
        NavigationDestination(
          icon: Icon(Icons.description_outlined),
          selectedIcon: Icon(Icons.description),
          label: 'Meus relatos',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
    ),
  );
}

class BootScreen extends ConsumerWidget {
  const BootScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final app = ref.watch(appControllerProvider);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: app.startupError == null
                ? const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BrandLogo(),
                      SizedBox(height: 30),
                      CircularProgressIndicator(),
                      SizedBox(height: 20),
                      Text('Preparando seu espaço…'),
                    ],
                  )
                : EmptyMessage(
                    title: 'Vamos tentar novamente?',
                    message: app.startupError!,
                    action: 'Tentar novamente',
                    onAction: app.initialize,
                    icon: Icons.error_outline,
                  ),
          ),
        ),
      ),
    );
  }
}
