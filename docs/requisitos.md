# Ponto Cego — visão e requisitos (v0.1)

**Produto:** plataforma colaborativa de gestão de barreiras de acessibilidade  
**Piloto:** SENAI (ambiente a definir)  
**Data:** 10/11/2026  
**Situação:** planejamento; pesquisa de campo e autorização institucional pendentes.

## Visão
Conectar a comunidade aos gestores dos espaços para identificar, registrar e acompanhar barreiras de acessibilidade, com transparência e histórico das ações. Os relatos não substituem laudos técnicos.

## Hipótese do problema
Barreiras podem não contar com canal claro de registro e acompanhamento; essa hipótese precisa ser validada no SENAI, especialmente com pessoas afetadas por dificuldades de acessibilidade.

## Papéis
- **Comunidade:** cria, consulta e acompanha ocorrências.
- **Gestor institucional:** analisa, prioriza, atribui e atualiza relatos.
- **Admin técnico:** configura a unidade e apoia o piloto.

## Escopo
**MVP:** autenticação, locais internos, relatos com foto opcional, consulta, filtros, histórico, dashboard Web, prioridade, responsável e permissões.

**Futuro:** confirmação de relatos duplicados, revisão, multi-instituição, mapa público, rotas acessíveis e IA.

## Requisitos funcionais
| ID | Prioridade | Requisito | Critério de aceite |
|---|---|---|---|
| RF-01 | Essencial | Login e acesso por perfil | Usuário acessa somente ações autorizadas. |
| RF-02 | Essencial | Cadastrar e consultar locais | Local aparece no formulário de relato. |
| RF-03 | Essencial | Criar relato com título, categoria, local, descrição e foto opcional | Campos validados; status inicial Aberta. |
| RF-04 | Essencial | Listar, buscar e filtrar ocorrências | Filtros retornam resultados coerentes. |
| RF-05 | Essencial | Mostrar detalhe e histórico | Alterações permanecem consultáveis. |
| RF-06 | Essencial | Gestor altera status com justificativa | Atualização registra autor e momento. |
| RF-07 | Essencial | Gestor define prioridade e responsável | Campos persistem e aparecem na ocorrência. |
| RF-08 | Essencial | Exibir relatos do próprio usuário | Autor consegue localizar seus relatos. |
| RF-09 | Essencial | Dashboard com totais por estado | Indicadores refletem dados persistidos. |
| RF-10 | Essencial | Restringir dados por organização na API | Acesso não autorizado é bloqueado. |
| RF-11 | Desejável | Confirmar relato existente | Uma confirmação por usuário/relato. |
| RF-12 | Desejável | Solicitar revisão de resolução | Solicitação não apaga histórico anterior. |
| RF-13 | Desejável | Registrar evidência da resolução | Gestor inclui nota ou foto. |

## Requisitos não funcionais
- **RNF-01 Acessibilidade:** labels, navegação por teclado, foco perceptível, contraste e suporte a leitor de tela.
- **RNF-02 Segurança:** senhas com hash, autorização na API, validação de uploads, credenciais fora do cliente.
- **RNF-03 Privacidade:** dados mínimos, não expor pessoas nas imagens e permitir moderação.
- **RNF-04 Confiabilidade:** erros de validação e falhas de rede tratados.
- **RNF-05 Manutenibilidade:** código modular, API documentada e Git.
- **RNF-06 Testes:** autenticação, CRUD, permissões e histórico.
- **RNF-07 Responsividade:** uso em desktop e dispositivos móveis.

## Regras de negócio
1. Relatos pertencem a uma organização e a um local dessa organização.
2. Apenas gestores autorizados podem alterar status, prioridade e responsável.
3. Estados: `Aberta → Em análise → Em andamento → Resolvida`.
4. Alterações registram autor, data/hora e justificativa.
5. Autorizações são verificadas no servidor, não apenas na interface.

## Dados preliminares
`organizations`, `users`, `memberships`, `locations`, `reports`, `report_images`, `report_updates`, `report_confirmations`.

## Critérios de sucesso do piloto
- Relato cadastrado no Mobile aparece no Web.
- Mudança de status no Web aparece no Mobile com histórico.
- A API rejeita operações não autorizadas.
- Requisitos revisados após pesquisa com usuários reais.
