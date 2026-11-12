import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/app_controller.dart';
import '../../app/theme/app_theme.dart';
import '../../core/data/models.dart';
import '../../core/widgets/shared.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key, this.mine = false});
  final bool mine;
  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  final _search = TextEditingController();
  ReportStatus? _status;
  Category? _category;
  String? _location;
  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _clear() {
    setState(() {
      _search.clear();
      _status = null;
      _category = null;
      _location = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final app = ref.watch(appControllerProvider);
    if (app.user == null) return const SizedBox.shrink();
    final results = ReportFilter(
      query: _search.text,
      status: _status,
      category: _category,
      locationId: _location,
      authorId: widget.mine ? app.user!.id : null,
    ).apply(app.reports);
    final filtered =
        _search.text.isNotEmpty ||
        _status != null ||
        _category != null ||
        _location != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mine ? 'Meus relatos' : 'Ocorrências'),
        actions: [
          IconButton(
            tooltip: 'Registrar barreira',
            onPressed: () => context.push('/new'),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: PageBody(
        children: [
          Text(
            widget.mine
                ? 'Cada contribuição tem um caminho.'
                : 'Veja o que a comunidade percebe.',
            style: const TextStyle(color: Brand.muted, height: 1.8),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _search,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: 'Buscar por título ou local',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _search.text.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Limpar busca',
                      onPressed: () {
                        _search.clear();
                        setState(() {});
                      },
                      icon: const Icon(Icons.close),
                    ),
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              for (final status in ReportStatus.values)
                FilterChip(
                  label: Text(status.label),
                  selected: _status == status,
                  onSelected: (selected) =>
                      setState(() => _status = selected ? status : null),
                ),
            ],
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<Category>(
            initialValue: _category,
            key: ValueKey(_category),
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Categoria'),
            items: [
              const DropdownMenuItem<Category>(
                value: null,
                child: Text('Todas as categorias'),
              ),
              for (final category in Category.values)
                DropdownMenuItem(value: category, child: Text(category.label)),
            ],
            onChanged: (v) => setState(() => _category = v),
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<String>(
            initialValue: _location,
            key: ValueKey(_location),
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Ambiente'),
            items: [
              const DropdownMenuItem<String>(
                value: null,
                child: Text('Todos os ambientes'),
              ),
              for (final location in app.locations)
                DropdownMenuItem(
                  value: location.id,
                  child: Text(
                    location.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
            onChanged: (v) => setState(() => _location = v),
          ),
          const SizedBox(height: 18),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            children: [
              Semantics(
                liveRegion: true,
                child: Text(
                  '${results.length} ${results.length == 1 ? 'relato encontrado' : 'relatos encontrados'}',
                  style: const TextStyle(color: Brand.muted, fontSize: 12),
                ),
              ),
              if (filtered)
                TextButton(
                  onPressed: _clear,
                  child: const Text('Limpar filtros'),
                ),
            ],
          ),
          const SizedBox(height: 14),
          if (results.isEmpty)
            EmptyMessage(
              title: filtered
                  ? 'Nenhum relato com esses filtros.'
                  : widget.mine
                  ? 'Seu primeiro olhar pode mudar algo.'
                  : 'Ainda não há relatos.',
              message: filtered
                  ? 'Tente buscar outro termo ou remova os filtros.'
                  : 'Registre uma barreira para iniciar seu acompanhamento.',
              action: filtered ? 'Limpar filtros' : 'Registrar barreira',
              onAction: filtered ? _clear : () => context.push('/new'),
            )
          else
            ...results.map(ReportCard.new),
          const SizedBox(height: 14),
          const DemoNotice(compact: true),
        ],
      ),
    );
  }
}
