import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/app_controller.dart';
import '../../app/theme/app_theme.dart';
import '../../core/data/models.dart';
import '../../core/widgets/shared.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key, this.register = false});
  final bool register;
  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController(),
      _email = TextEditingController(),
      _password = TextEditingController();
  bool _obscure = true, _busy = false;
  String? _error;
  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_busy || !_form.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final app = ref.read(appControllerProvider);
      if (widget.register) {
        await app.register(_name.text, _email.text, _password.text);
      } else {
        await app.login(_email.text, _password.text);
      }
    } catch (e) {
      if (mounted) setState(() => _error = errorMessage(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 510),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: AutofillGroup(
              child: Form(
                key: _form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: BrandLogo(width: 182),
                    ),
                    const SizedBox(height: 38),
                    Text(
                      widget.register
                          ? 'Um novo olhar\ncomeça com você.'
                          : 'Seu olhar pode\ntransformar espaços.',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -1.3,
                        height: 1.18,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      widget.register
                          ? 'Crie uma conta demonstrativa neste dispositivo.'
                          : 'Entre para identificar barreiras e acompanhar seus relatos.',
                      style: const TextStyle(color: Brand.muted, height: 1.8),
                    ),
                    const SizedBox(height: 24),
                    const DemoNotice(compact: true),
                    const SizedBox(height: 25),
                    if (_error != null) ErrorNotice(_error!),
                    if (widget.register) ...[
                      TextFormField(
                        controller: _name,
                        decoration: const InputDecoration(
                          labelText: 'Nome',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        autofillHints: const [AutofillHints.name],
                        validator: (v) => requiredText(v, min: 2, max: 80),
                      ),
                      const SizedBox(height: 18),
                    ],
                    TextFormField(
                      controller: _email,
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        prefixIcon: Icon(Icons.alternate_email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autocorrect: false,
                      autofillHints: const [AutofillHints.email],
                      validator: validateEmail,
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      controller: _password,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        helperText: widget.register
                            ? '8 ou mais caracteres, com letras e números.'
                            : null,
                        helperMaxLines: 2,
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          tooltip: _obscure ? 'Mostrar senha' : 'Ocultar senha',
                          onPressed: () => setState(() => _obscure = !_obscure),
                          icon: Icon(
                            _obscure
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                      obscureText: _obscure,
                      textInputAction: TextInputAction.done,
                      autofillHints: [
                        widget.register
                            ? AutofillHints.newPassword
                            : AutofillHints.password,
                      ],
                      validator: widget.register
                          ? validatePassword
                          : (v) => requiredText(v, max: 200),
                      onFieldSubmitted: (_) => _submit(),
                    ),
                    const SizedBox(height: 25),
                    FilledButton(
                      onPressed: _busy ? null : _submit,
                      child: Text(
                        _busy
                            ? 'Aguarde…'
                            : widget.register
                            ? 'Criar conta local'
                            : 'Entrar',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: _busy
                          ? null
                          : () => context.go(
                              widget.register ? '/login' : '/register',
                            ),
                      child: Text(
                        widget.register
                            ? 'Já tenho uma conta'
                            : 'Criar uma conta',
                      ),
                    ),
                    if (!widget.register) ...[
                      const SizedBox(height: 17),
                      OutlinedButton.icon(
                        onPressed: _busy
                            ? null
                            : () {
                                _email.text = demoEmail;
                                _password.text = demoPassword;
                              },
                        icon: const Icon(Icons.science_outlined),
                        label: const Text('Preencher acesso de demonstração'),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Acesso local: comunidade@pontocego.demo\nSenha: PontoCego123!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Brand.muted,
                          fontSize: 11,
                          height: 1.8,
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    const Text(
                      'Use dados fictícios. Esta conta não é uma autenticação institucional.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        color: Brand.muted,
                        height: 1.7,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
