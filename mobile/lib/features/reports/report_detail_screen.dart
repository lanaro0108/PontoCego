import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/app_controller.dart';
import '../../app/theme/app_theme.dart';
import '../../core/widgets/shared.dart';

class ReportDetailScreen extends ConsumerWidget {
  const ReportDetailScreen({super.key, required this.id});
  final String id;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(appControllerProvider).report(id);
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do relato')),
      body: report == null
          ? PageBody(
              children: [
                EmptyMessage(
                  title: 'Relato não encontrado.',
                  message:
                      'Ele não está disponível nesta sessão ou instituição.',
                  action: 'Ver ocorrências',
                  onAction: () => context.go('/reports'),
                  icon: Icons.search_off,
                ),
              ],
            )
          : PageBody(
              children: [
                const DemoNotice(compact: true),
                const SizedBox(height: 25),
                Align(
                  alignment: Alignment.centerLeft,
                  child: StatusBadge(report.status),
                ),
                const SizedBox(height: 20),
                Text(
                  report.title,
                  style: const TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -.8,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Info(
                          Icons.place_outlined,
                          'Localização',
                          report.location.label,
                        ),
                        const Divider(height: 28),
                        _Info(
                          Icons.category_outlined,
                          'Categoria',
                          report.category.label,
                        ),
                        const Divider(height: 28),
                        _Info(
                          Icons.schedule,
                          'Registro',
                          displayDate(report.createdAt),
                        ),
                      ],
                    ),
                  ),
                ),
                const SectionTitle('O que foi percebido'),
                Text(
                  report.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Brand.muted,
                    height: 1.9,
                  ),
                ),
                if (report.photoBase64 != null) ...[
                  const SectionTitle('Foto do relato'),
                  EvidencePhoto(report.photoBase64!),
                ],
                const SectionTitle('Histórico de atualizações'),
                ...report.updates.indexed.map((entry) {
                  final (index, update) = entry;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEEE8FF),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                index == report.updates.length - 1
                                    ? Icons.check
                                    : Icons.circle_outlined,
                                size: 15,
                                color: Brand.purple,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    update.status.label,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 7),
                                  Text(
                                    update.note,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Brand.muted,
                                      height: 1.8,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    displayDate(update.at),
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Brand.muted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 18),
                const Text(
                  'As atualizações institucionais serão integradas à plataforma Web no futuro. A comunidade não altera o status dos relatos.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Brand.muted,
                    height: 1.8,
                  ),
                ),
              ],
            ),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info(this.icon, this.label, this.value);
  final IconData icon;
  final String label, value;
  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, size: 20, color: Brand.purple),
      const SizedBox(width: 14),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: Brand.muted),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class ReportSuccessScreen extends ConsumerWidget {
  const ReportSuccessScreen({super.key, required this.id});
  final String id;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(appControllerProvider).report(id);
    return Scaffold(
      appBar: AppBar(title: const BrandLogo(width: 150)),
      body: PageBody(
        children: [
          const SizedBox(height: 40),
          Align(
            child: Container(
              padding: const EdgeInsets.all(25),
              decoration: const BoxDecoration(
                color: Color(0xFFE6F5EB),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                size: 47,
                color: Color(0xFF2D7550),
              ),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            report == null
                ? 'Relato não encontrado.'
                : 'Seu relato\nestá salvo.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.w700,
              letterSpacing: -1,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Seu olhar faz parte da mudança. Você pode consultar o registro e seu histórico em Meus relatos.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Brand.muted, height: 1.9),
          ),
          const SizedBox(height: 28),
          if (report != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StatusBadge(report.status),
                    const SizedBox(height: 13),
                    Text(
                      report.title,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      report.location.label,
                      style: const TextStyle(fontSize: 12, color: Brand.muted),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 25),
          FilledButton(
            onPressed: () => context.go('/reports/$id'),
            child: const Text('Ver meu relato'),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => context.go('/home'),
            child: const Text('Voltar ao início'),
          ),
          const SizedBox(height: 24),
          const DemoNotice(),
        ],
      ),
    );
  }
}
