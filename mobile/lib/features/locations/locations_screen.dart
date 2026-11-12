import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/app_controller.dart';
import '../../app/theme/app_theme.dart';
import '../../core/data/models.dart';
import '../../core/widgets/shared.dart';

class LocationsScreen extends ConsumerStatefulWidget {
  const LocationsScreen({super.key, this.selected});
  final String? selected;
  @override
  ConsumerState<LocationsScreen> createState() => _LocationsScreenState();
}

class _LocationsScreenState extends ConsumerState<LocationsScreen> {
  String _query = '';
  @override
  Widget build(BuildContext context) {
    final locations = ref
        .watch(appControllerProvider)
        .locations
        .where((l) => normalize(l.label).contains(normalize(_query)))
        .toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Selecionar local')),
      body: PageBody(
        children: [
          const Text(
            demoOrganizationName,
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          const Text(
            'Escolha o bloco e o ambiente. Não utilizamos GPS interno.',
            style: TextStyle(color: Brand.muted, height: 1.7),
          ),
          const SizedBox(height: 22),
          TextField(
            onChanged: (v) => setState(() => _query = v),
            decoration: const InputDecoration(
              labelText: 'Buscar ambiente',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 20),
          if (locations.isEmpty)
            const EmptyMessage(
              title: 'Ambiente não encontrado.',
              message: 'Tente o nome do bloco, entrada, pátio ou cantina.',
              icon: Icons.location_off_outlined,
            ),
          for (final block in locations.map((l) => l.block).toSet()) ...[
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                block.toUpperCase(),
                style: const TextStyle(
                  color: Brand.muted,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                  letterSpacing: 1,
                ),
              ),
            ),
            for (final location in locations.where((l) => l.block == block))
              Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 9,
                    ),
                    leading: const Icon(
                      Icons.place_outlined,
                      color: Brand.purple,
                    ),
                    title: Text(
                      location.room,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      location.block,
                      style: const TextStyle(color: Brand.muted),
                    ),
                    trailing: Icon(
                      widget.selected == location.id
                          ? Icons.check_circle
                          : Icons.chevron_right,
                      color: Brand.purple,
                    ),
                    onTap: () => context.pop(location),
                  ),
                ),
              ),
          ],
          const SizedBox(height: 20),
          const DemoNotice(compact: true),
        ],
      ),
    );
  }
}
