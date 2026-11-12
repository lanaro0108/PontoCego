import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/app_controller.dart';
import '../../app/theme/app_theme.dart';
import '../../core/data/models.dart';
import '../../core/widgets/shared.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});
  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _busy = false;
  Future<void> _preferences(AccessibilityPreferences value) async {
    setState(() => _busy = true);
    try {
      await ref.read(appControllerProvider).setPreferences(value);
    } catch (e) {
      if (mounted) showError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair da demonstração?'),
        content: const Text(
          'Os relatos e sua conta local continuarão salvos neste dispositivo.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Continuar aqui'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sair da conta'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _busy = true);
    try {
      await ref.read(appControllerProvider).logout();
    } catch (e) {
      if (mounted) showError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = ref.watch(appControllerProvider);
    final user = app.user;
    if (user == null) return const SizedBox.shrink();
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil e configurações')),
      body: PageBody(
        children: [
          const SizedBox(height: 16),
          Align(
            child: Container(
              width: 76,
              height: 76,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFEBE3FF),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                user.name.characters.first.toUpperCase(),
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Brand.purple,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            user.name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 7),
          Text(
            user.email,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Brand.muted, fontSize: 13),
          ),
          const SectionTitle('Seu espaço'),
          const Card(
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 12,
              ),
              leading: Icon(Icons.school_outlined, color: Brand.purple),
              title: Text('Instituição atual'),
              subtitle: Text(
                demoOrganizationName,
                style: TextStyle(fontSize: 12, height: 1.8),
              ),
            ),
          ),
          const SectionTitle('Acessibilidade'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: const Text(
                    'Contraste reforçado',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(
                    'Realça contornos dos componentes.',
                    style: TextStyle(fontSize: 12, height: 1.7),
                  ),
                  value: app.preferences.highContrast,
                  onChanged: _busy
                      ? null
                      : (value) => _preferences(
                          AccessibilityPreferences(
                            highContrast: value,
                            reduceMotion: app.preferences.reduceMotion,
                          ),
                        ),
                ),
                const Divider(),
                SwitchListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: const Text(
                    'Reduzir movimento',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(
                    'Desativa transições. Também respeitamos a preferência do sistema.',
                    style: TextStyle(fontSize: 12, height: 1.7),
                  ),
                  value: app.preferences.reduceMotion,
                  onChanged: _busy
                      ? null
                      : (value) => _preferences(
                          AccessibilityPreferences(
                            highContrast: app.preferences.highContrast,
                            reduceMotion: value,
                          ),
                        ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Para aumentar o texto, use o tamanho de fonte nas configurações do seu dispositivo.',
            style: TextStyle(color: Brand.muted, fontSize: 12, height: 1.8),
          ),
          const SectionTitle('Privacidade e projeto'),
          Card(
            child: Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 8,
                  ),
                  leading: const Icon(
                    Icons.privacy_tip_outlined,
                    color: Brand.purple,
                  ),
                  title: const Text(
                    'Seus dados nesta demonstração',
                    style: TextStyle(fontSize: 14),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => showDialog<void>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Você mantém o controle.'),
                      content: const SingleChildScrollView(
                        child: Text(
                          'Os dados são mantidos somente neste dispositivo, no armazenamento local do aplicativo. Nenhum relato ou foto é enviado à instituição.\n\nUse informações fictícias e evite fotografar pessoas ou dados pessoais. Limpar os dados do aplicativo ou desinstalá-lo remove os registros locais.\n\nA sessão é demonstrativa; não substitui autenticação, autorização ou armazenamento seguros de um produto em produção.',
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Entendi'),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 8,
                  ),
                  leading: const Icon(Icons.info_outline, color: Brand.purple),
                  title: const Text(
                    'Sobre o Ponto Cego',
                    style: TextStyle(fontSize: 14),
                  ),
                  subtitle: const Text(
                    'Mobile · versão demonstrativa 0.1.0',
                    style: TextStyle(fontSize: 11),
                  ),
                  onTap: () => showAboutDialog(
                    context: context,
                    applicationName: 'Ponto Cego',
                    applicationVersion: '0.1.0 · demonstração local',
                    applicationIcon: brandSymbol(size: 52),
                    children: [
                      const Text(
                        'Uma plataforma colaborativa para identificar e acompanhar barreiras de acessibilidade. Piloto SENAI previsto, sujeito à pesquisa e autorização institucional. Não substitui laudos técnicos.',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          OutlinedButton.icon(
            onPressed: _busy ? null : _logout,
            icon: const Icon(Icons.logout),
            label: Text(_busy ? 'Aguarde…' : 'Sair da conta'),
          ),
          const SizedBox(height: 20),
          const DemoNotice(),
        ],
      ),
    );
  }
}
