import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/app_controller.dart';
import '../../app/theme/app_theme.dart';
import '../../core/data/models.dart';
import '../../core/widgets/shared.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final app = ref.watch(appControllerProvider);
    final user = app.user;
    if (user == null) return const SizedBox.shrink();
    final firstName = user.name.split(' ').first;
    final mine = app.reports.where((r) => r.authorId == user.id).length;
    return Scaffold(
      appBar: AppBar(
        title: const BrandLogo(width: 152),
        actions: [
          IconButton(
            tooltip: 'Meu perfil',
            onPressed: () => context.go('/profile'),
            icon: const Icon(Icons.person_outline),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: PageBody(
        children: [
          const SizedBox(height: 14),
          const Text(
            'UM NOVO OLHAR SOBRE O SEU ESPAÇO',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
              color: Brand.muted,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Olá, $firstName.',
            style: const TextStyle(
              fontSize: 31,
              fontWeight: FontWeight.w700,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 8),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.school_outlined, size: 19, color: Brand.purple),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  demoOrganizationName,
                  style: TextStyle(
                    color: Brand.muted,
                    fontSize: 13,
                    height: 1.6,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              color: Brand.purple,
              borderRadius: BorderRadius.circular(23),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                Positioned(
                  right: -20,
                  top: 20,
                  child: Opacity(opacity: .14, child: brandSymbol(size: 180)),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Seu olhar faz\na diferença.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          height: 1.2,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -.8,
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Percebeu uma barreira?\nDê o primeiro passo para a mudança.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          height: 1.8,
                        ),
                      ),
                      const SizedBox(height: 22),
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Brand.purple,
                        ),
                        onPressed: () => context.push('/new'),
                        icon: const Icon(Icons.add, size: 20),
                        label: const Text('Registrar barreira'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const DemoNotice(compact: true),
          const SectionTitle('Um espaço, muitas perspectivas'),
          Card(
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 8,
              ),
              leading: const Icon(
                Icons.description_outlined,
                color: Brand.purple,
              ),
              title: const Text(
                'Meus relatos',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: Text(
                '$mine ${mine == 1 ? 'contribuição salva' : 'contribuições salvas'} neste dispositivo',
                style: const TextStyle(fontSize: 12, color: Brand.muted),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.go('/mine'),
            ),
          ),
          SectionTitle(
            'Ocorrências recentes',
            action: 'Ver todas',
            onAction: () => context.go('/reports'),
          ),
          if (app.reports.isEmpty)
            EmptyMessage(
              title: 'Todo olhar conta.',
              message: 'Ainda não há ocorrências neste ambiente.',
              action: 'Registrar uma barreira',
              onAction: () => context.push('/new'),
            )
          else
            ...app.reports.take(3).map(ReportCard.new),
          const SizedBox(height: 14),
          const Text(
            'Piloto previsto. Pesquisa e autorização institucional ainda pendentes. Os relatos desta demonstração não comprovam as condições de nenhum ambiente.',
            style: TextStyle(color: Brand.muted, fontSize: 11, height: 1.8),
          ),
        ],
      ),
    );
  }
}
