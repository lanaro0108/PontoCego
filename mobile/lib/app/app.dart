import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_controller.dart';
import 'router.dart';
import 'theme/app_theme.dart';

class PontoCegoApp extends ConsumerWidget {
  const PontoCegoApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final app = ref.watch(appControllerProvider);
    return MaterialApp.router(
      title: 'Ponto Cego',
      debugShowCheckedModeBanner: false,
      theme: appTheme(highContrast: app.preferences.highContrast),
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [Locale('pt', 'BR')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      routerConfig: ref.watch(routerProvider),
      builder: (context, child) {
        final media = MediaQuery.of(context);
        return MediaQuery(
          data: media.copyWith(
            disableAnimations:
                media.disableAnimations || app.preferences.reduceMotion,
          ),
          child: child!,
        );
      },
    );
  }
}
