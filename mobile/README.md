# Ponto Cego Mobile

Aplicativo comunitário Flutter com modo demonstrativo funcional e persistência local. Mantém a marca, a paleta e a fonte Plus Jakarta Sans do site. A referência visual disponível no repositório foi `assets/wireframes/`; não foram encontrados protótipos do Google Stitch.

## Executar

Requisitos: Flutter 3.38.10 ou superior compatível com Dart 3.10.9, SDK Android e JDK compatíveis com o Flutter instalado.

```bash
cd mobile
flutter pub get
flutter run
```

Para uma prévia no navegador, com Chrome instalado:

```bash
flutter run -d chrome
```

Conta local inicial:

- E-mail: `comunidade@pontocego.demo`
- Senha: `PontoCego123!`

O botão **Preencher acesso de demonstração** preenche o formulário. O login ainda valida a senha. Também é possível criar uma nova conta local com nome, e-mail e senha. Use dados fictícios: não há cadastro institucional ou validação de e-mail.

## Demonstrar o fluxo

1. Entre com a conta de demonstração ou crie uma conta local.
2. Consulte os exemplos na Home ou em Ocorrências.
3. Toque em **Registrar barreira** e informe título, categoria e descrição.
4. Escolha um bloco e ambiente em **Selecionar localização**.
5. Opcionalmente, selecione uma foto pela câmera ou galeria.
6. Toque em **Revisar relato**, leia a orientação de privacidade e confirme o registro local.
7. Abra o relato na confirmação ou pela aba **Meus relatos**.
8. Feche e reabra o app: sessão, relatos, fotos e preferências continuam disponíveis.

Os exemplos iniciais são fictícios e criados somente quando não há banco local. Cadastros posteriores não são substituídos por novos exemplos. Todas as instituições, ambientes e andamentos desta demonstração são ilustrativos. O piloto SENAI continua sujeito a pesquisa e autorização institucional.

## Organização

```text
lib/app/                   Inicialização, controller Riverpod, GoRouter e tema
lib/core/data/             Modelos, interfaces de repositório e armazenamento local
lib/core/network/          Configuração opcional do cliente Dio
lib/core/widgets/          Marca, mensagens, cards e status compartilhados
lib/features/auth/         Login e cadastro
lib/features/home/         Início e atalhos
lib/features/reports/      Lista, filtros, formulário, fotos, detalhes e confirmação
lib/features/locations/    Pesquisa e seleção de bloco/ambiente
lib/features/profile/      Perfil, privacidade, acessibilidade e logout
test/                      Testes dos repositórios e fluxos reais de widgets
assets/                    Cópias dos assets oficiais e fonte local licenciada
```

As quatro abas usam `StatefulShellRoute.indexedStack` para preservar busca e filtros. Formulário e seleção de local usam rotas sobre a navegação principal. A confirmação substitui o formulário e mantém um caminho de volta ao relato e à lista, evitando reenviar um registro ao voltar.

## Dados locais e limites do modo demonstrativo

- `DemoRepository` implementa `CommunityRepository`, reunindo as interfaces de autenticação, relatos, locais e preferências. O provider pode ser substituído por um adaptador HTTP sem redesenhar as telas.
- `PreferencesStore` usa SharedPreferences com documento JSON versionado (`ponto_cego.demo.v1`). Operações de escrita são serializadas; o estado em memória só é atualizado após a gravação.
- Senhas são derivadas com PBKDF2-HMAC-SHA256, 100.000 iterações e salt aleatório individual. A sessão armazena somente o identificador local do usuário. Isso **não** constitui autenticação segura de produção: o cliente e seu armazenamento podem ser manipulados pelo proprietário do dispositivo.
- Fotos são reduzidas pelo seletor quando possível e limitadas a 1 MB. Os bytes são armazenados no documento local, permitindo reabertura após encerrar o app. Essa solução serve ao MVP demonstrativo; produção deve usar armazenamento de arquivos e política de retenção adequados. No navegador, a capacidade depende da quota de armazenamento local.
- Câmera e galeria usam o seletor nativo. Cancelamento não cria foto; indisponibilidade e falha de permissão exibem orientação. Há recuperação de seleção interrompida pelo Android por meio de `retrieveLostData`.
- Não há sincronização, monitoramento de câmera, GPS indoor, edição administrativa de status ou envio de relatos à instituição. As alterações institucionais aparecem apenas nos exemplos pré-carregados.
- O logout preserva os dados. Desinstalar, limpar o armazenamento do aplicativo ou limpar os dados do navegador remove os dados locais. O backup automático do aplicativo Android está desativado.
- Falhas de leitura não apagam nem reinicializam silenciosamente os dados. A tela inicial permite tentar novamente.

## Integração futura

O cliente Dio recebe a URL por configuração externa:

```bash
flutter run --dart-define=API_BASE_URL=https://api.seu-dominio.example
```

**Definir a URL não ativa uma integração nem muda o modo demonstrativo.** `ApiClient.create()` é apenas um ponto de configuração para o futuro repositório HTTP; não é chamado pelo repositório local. Uma URL inválida é rejeitada quando esse cliente é criado.

Os caminhos candidatos documentados pelo projeto são `POST /auth/login`, `GET /me`, `GET /locations`, `GET /reports`, `POST /reports` e `GET /reports/:id`. Formatos de requisição/resposta, tokens, paginação e uploads ainda precisam ser definidos com o backend NestJS. Não foi inventado um contrato de cadastro remoto.

Os modelos locais têm identificadores, `organizationId`, `authorId`, `locationId`, categoria, status, timestamps UTC e histórico. A listagem e a criação respeitam a organização da sessão local. Isso prepara a substituição de dados, sem implementar operações multi-instituição ou autorização de servidor nesta entrega.

## Acessibilidade e qualidade

Interfaces em português brasileiro, foco e validações nativos, ícones com rótulos, status por texto e cor, alvos de toque Material, conteúdo rolável e fonte ajustável pelas preferências do sistema. As preferências **Contraste reforçado** e **Reduzir movimento** são persistidas. A preferência de redução de movimento do sistema também é respeitada.

```bash
flutter pub get
dart format .
flutter analyze
flutter test
flutter build apk --debug
```

O APK de desenvolvimento é gerado em `build/app/outputs/flutter-apk/app-debug.apk`. A assinatura de publicação e a integração com backend ficam para uma etapa posterior. A validação de câmera, galeria e leitor de tela em aparelho físico deve ser feita antes de distribuir o app.

### Verificações desta entrega

Executados com Flutter 3.38.10 / Dart 3.10.9: resolução das dependências, `dart format .`, `flutter analyze` sem ocorrências, 14 testes aprovados e builds web e APK Android de depuração. Os testes de widgets percorrem login, criação, seleção de local, confirmação, detalhes, reinicialização e logout; também verificam filtros, erros, alvos de toque e texto em escala 2 em uma tela de 320 px.

O APK foi compilado com JDK 21, Android SDK 36 e mínimo de API 24. Não havia dispositivo ou emulador Android conectado: instalação, câmera/galeria nativas e TalkBack em aparelho físico permanecem pendentes. As verificações automáticas não constituem certificação de acessibilidade.
