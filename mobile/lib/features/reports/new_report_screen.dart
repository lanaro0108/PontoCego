import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../app/app_controller.dart';
import '../../app/theme/app_theme.dart';
import '../../core/data/models.dart';
import '../../core/widgets/shared.dart';

class NewReportScreen extends ConsumerStatefulWidget {
  const NewReportScreen({super.key});
  @override
  ConsumerState<NewReportScreen> createState() => _NewReportScreenState();
}

class _NewReportScreenState extends ConsumerState<NewReportScreen> {
  final _form = GlobalKey<FormState>();
  final _title = TextEditingController(),
      _description = TextEditingController();
  Category? _category;
  Location? _location;
  String? _photo, _error;
  bool _busy = false, _photoBusy = false;
  @override
  void initState() {
    super.initState();
    _recoverPhoto();
  }

  Future<void> _recoverPhoto() async {
    final photo = await ref.read(photoServiceProvider).recover();
    if (mounted && photo != null && _photo == null) {
      setState(() => _photo = photo);
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _choosePhoto(ImageSource source) async {
    setState(() => _photoBusy = true);
    try {
      final image = await ref.read(photoServiceProvider).choose(source);
      if (mounted && image != null) setState(() => _photo = image);
    } catch (e) {
      if (mounted) showError(context, e);
    } finally {
      if (mounted) setState(() => _photoBusy = false);
    }
  }

  Future<void> _submit() async {
    if (_busy || _photoBusy || !_form.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final confirm = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 6, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Confira seu relato',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -.6,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                _title.text.trim(),
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '${_category!.label} · ${_location!.label}',
                style: const TextStyle(color: Brand.muted, height: 1.6),
              ),
              const SizedBox(height: 14),
              Text(
                _description.text.trim(),
                style: const TextStyle(height: 1.7),
              ),
              if (_photo != null) ...[
                const SizedBox(height: 18),
                EvidencePhoto(_photo!),
              ],
              const SizedBox(height: 20),
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Proteja a privacidade: evite fotografar pessoas, documentos ou dados pessoais. Revise a imagem e o texto antes de confirmar.',
                    style: TextStyle(
                      color: Brand.muted,
                      height: 1.7,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const DemoNotice(compact: true),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () => context.pop(true),
                child: const Text('Confirmar registro local'),
              ),
              TextButton(
                onPressed: () => context.pop(false),
                child: const Text('Voltar para editar'),
              ),
            ],
          ),
        ),
      ),
    );
    if (confirm != true || !mounted) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final report = await ref
          .read(appControllerProvider)
          .create(
            NewReport(
              title: _title.text,
              description: _description.text,
              category: _category!,
              locationId: _location!.id,
              photoBase64: _photo,
            ),
          );
      if (mounted) context.go('/reports/${report.id}/success');
    } catch (e) {
      if (mounted) setState(() => _error = errorMessage(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Registrar barreira')),
    body: PageBody(
      children: [
        const Text(
          'O primeiro passo é tornar visível.',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w700,
            letterSpacing: -.8,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Conte o que você percebeu. Quanto mais contexto, mais fácil entender a barreira.',
          style: TextStyle(color: Brand.muted, height: 1.8),
        ),
        const SizedBox(height: 24),
        if (_error != null) ErrorNotice(_error!),
        Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _title,
                enabled: !_busy,
                decoration: const InputDecoration(
                  labelText: 'Título da ocorrência *',
                  hintText: 'Ex.: desnível no acesso ao bloco',
                ),
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
                maxLength: 100,
                validator: (v) => requiredText(v, min: 5, max: 100),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Category>(
                initialValue: _category,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Categoria *'),
                items: [
                  for (final category in Category.values)
                    DropdownMenuItem(
                      value: category,
                      child: Text(category.label),
                    ),
                ],
                onChanged: _busy ? null : (v) => setState(() => _category = v),
                validator: (v) => v == null ? 'Selecione uma categoria.' : null,
              ),
              const SizedBox(height: 22),
              FormField<Location>(
                initialValue: _location,
                validator: (_) =>
                    _location == null ? 'Selecione um bloco e ambiente.' : null,
                builder: (field) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Brand.navy,
                        alignment: Alignment.centerLeft,
                        side: BorderSide(
                          color: field.hasError
                              ? Theme.of(context).colorScheme.error
                              : Brand.line,
                        ),
                      ),
                      onPressed: _busy
                          ? null
                          : () async {
                              final selected = await context.push<Location>(
                                '/locations${_location == null ? '' : '?selected=${_location!.id}'}',
                              );
                              if (selected != null && mounted) {
                                setState(() => _location = selected);
                                field.didChange(selected);
                              }
                            },
                      icon: const Icon(
                        Icons.place_outlined,
                        color: Brand.purple,
                      ),
                      label: Text(
                        _location?.label ?? 'Selecionar localização *',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    if (field.hasError)
                      Padding(
                        padding: const EdgeInsets.only(top: 8, left: 16),
                        child: Semantics(
                          liveRegion: true,
                          child: Text(
                            field.errorText!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              TextFormField(
                controller: _description,
                enabled: !_busy,
                decoration: const InputDecoration(
                  labelText: 'Descrição *',
                  hintText:
                      'Onde está a barreira? Como ela dificulta o uso do espaço?',
                  alignLabelWithHint: true,
                ),
                minLines: 4,
                maxLines: 8,
                maxLength: 2000,
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.multiline,
                validator: (v) => requiredText(v, min: 15, max: 2000),
              ),
              const SizedBox(height: 18),
              const Text(
                'Uma foto ajuda a contextualizar',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              const Text(
                'Opcional · até 1 MB. Evite incluir pessoas ou dados pessoais.',
                style: TextStyle(fontSize: 12, color: Brand.muted, height: 1.7),
              ),
              const SizedBox(height: 14),
              if (_photo != null)
                EvidencePhoto(
                  _photo!,
                  onRemove: _busy || _photoBusy
                      ? null
                      : () => setState(() => _photo = null),
                ),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  OutlinedButton.icon(
                    onPressed: _busy || _photoBusy
                        ? null
                        : () => _choosePhoto(ImageSource.camera),
                    icon: const Icon(Icons.photo_camera_outlined, size: 19),
                    label: const Text('Câmera'),
                  ),
                  OutlinedButton.icon(
                    onPressed: _busy || _photoBusy
                        ? null
                        : () => _choosePhoto(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library_outlined, size: 19),
                    label: const Text('Galeria'),
                  ),
                ],
              ),
              if (_photoBusy)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Semantics(
                    liveRegion: true,
                    child: Text('Preparando imagem…'),
                  ),
                ),
              const SizedBox(height: 28),
              FilledButton.icon(
                onPressed: _busy || _photoBusy ? null : _submit,
                icon: Icon(
                  _busy ? Icons.hourglass_top : Icons.arrow_forward,
                  size: 19,
                ),
                label: Text(
                  _busy ? 'Salvando no dispositivo…' : 'Revisar relato',
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'O registro será salvo localmente. Nenhuma informação será enviada a um servidor nesta demonstração.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: Brand.muted, height: 1.8),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
