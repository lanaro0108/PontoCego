import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../app/theme/app_theme.dart';
import '../data/models.dart';

String displayDate(DateTime at) =>
    DateFormat('dd/MM/yyyy · HH:mm').format(at.toLocal());

class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.width = 170});
  final double width;
  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Ponto Cego',
    image: true,
    child: Image.asset(
      'assets/branding/logo.png',
      width: width,
      excludeFromSemantics: true,
    ),
  );
}

class DemoNotice extends StatelessWidget {
  const DemoNotice({super.key, this.compact = false});
  final bool compact;
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(compact ? 12 : 16),
    decoration: BoxDecoration(
      color: const Color(0xFFEEE9FC),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.science_outlined, size: 20, color: Brand.purple),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            compact
                ? 'Modo demonstrativo · dados locais'
                : 'Demonstração local. Os exemplos e ambientes são fictícios. Seus registros ficam neste dispositivo; não são enviados à instituição.',
            style: const TextStyle(
              color: Color(0xFF503786),
              fontSize: 12,
              height: 1.6,
            ),
          ),
        ),
      ],
    ),
  );
}

class PageBody extends StatelessWidget {
  const PageBody({super.key, required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 620),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(22, 16, 22, 32),
        children: children,
      ),
    ),
  );
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key, this.action, this.onAction});
  final String title;
  final String? action;
  final VoidCallback? onAction;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 26, bottom: 14),
    child: Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 12,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            letterSpacing: -.5,
          ),
        ),
        if (action != null)
          TextButton(onPressed: onAction, child: Text(action!)),
      ],
    ),
  );
}

class EmptyMessage extends StatelessWidget {
  const EmptyMessage({
    super.key,
    required this.title,
    required this.message,
    this.action,
    this.onAction,
    this.icon = Icons.inbox_outlined,
  });
  final String title, message;
  final String? action;
  final VoidCallback? onAction;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 12),
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFFEEE8FE),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Icon(icon, size: 32, color: Brand.purple),
        ),
        const SizedBox(height: 18),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Brand.muted, height: 1.7),
        ),
        if (action != null)
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: OutlinedButton(onPressed: onAction, child: Text(action!)),
          ),
      ],
    ),
  );
}

class ErrorNotice extends StatelessWidget {
  const ErrorNotice(this.message, {super.key});
  final String message;
  @override
  Widget build(BuildContext context) => Semantics(
    liveRegion: true,
    child: Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEDEF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        message,
        style: const TextStyle(color: Color(0xFF971D30), height: 1.6),
      ),
    ),
  );
}

class StatusBadge extends StatelessWidget {
  const StatusBadge(this.status, {super.key});
  final ReportStatus status;
  @override
  Widget build(BuildContext context) {
    final (color, bg, icon) = switch (status) {
      ReportStatus.open => (
        const Color(0xFF865714),
        const Color(0xFFFFF3D9),
        Icons.radio_button_unchecked,
      ),
      ReportStatus.review => (
        const Color(0xFF6637A2),
        const Color(0xFFF0E7FF),
        Icons.search,
      ),
      ReportStatus.progress => (
        const Color(0xFF185A91),
        const Color(0xFFE8F2FF),
        Icons.build_outlined,
      ),
      ReportStatus.resolved => (
        const Color(0xFF246347),
        const Color(0xFFE7F5EC),
        Icons.check_circle_outline,
      ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 5,
        children: [
          Icon(icon, size: 14, color: color),
          Text(
            status.label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class ReportCard extends StatelessWidget {
  const ReportCard(this.report, {super.key});
  final BarrierReport report;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => context.push('/reports/${report.id}'),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 10,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  StatusBadge(report.status),
                  Text(
                    report.category.label,
                    style: const TextStyle(color: Brand.muted, fontSize: 11),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                report.title,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.place_outlined,
                    size: 17,
                    color: Brand.muted,
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      report.location.label,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Brand.muted,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward,
                    size: 17,
                    color: Brand.purple,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                displayDate(report.createdAt),
                style: const TextStyle(fontSize: 11, color: Brand.muted),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class EvidencePhoto extends StatelessWidget {
  const EvidencePhoto(this.data, {super.key, this.onRemove});
  final String data;
  final VoidCallback? onRemove;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.memory(
          base64Decode(data),
          height: 200,
          fit: BoxFit.cover,
          semanticLabel: 'Foto anexada ao relato',
          errorBuilder: (_, error, stack) => const Padding(
            padding: EdgeInsets.all(20),
            child: Text('Não foi possível exibir a imagem.'),
          ),
        ),
      ),
      if (onRemove != null)
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: onRemove,
            icon: const Icon(Icons.close, size: 16),
            label: const Text('Remover foto'),
          ),
        ),
    ],
  );
}

void showError(BuildContext context, Object error) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        error is AppFailure
            ? error.message
            : 'Não foi possível concluir. Tente novamente.',
      ),
    ),
  );
}

Widget brandSymbol({double size = 72}) => Image.asset(
  'assets/branding/symbol.png',
  width: size,
  height: size,
  excludeFromSemantics: true,
);
