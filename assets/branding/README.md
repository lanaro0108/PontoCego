# Identidade visual — Ponto Cego

A marca combina um **marcador de localização** com um **olho estilizado**, representando barreiras que precisam ser identificadas.

## Paleta

| Cor | HEX | Uso |
|---|---|---|
| Roxo | `#5421EB` | Marca e ações principais |
| Azul-marinho | `#0B1630` | Texto sobre fundo claro |
| Lavanda | `#9B83F5` | Destaque |
| Fundo escuro | `#0B1026` | Versão escura |
| Branco | `#FFFFFF` | Superfícies e texto escuro |

## Arquivos

- `svg/logo-horizontal-light.svg`: logo para fundo branco.
- `svg/logo-horizontal-dark.svg`: logo para fundo azul-marinho.
- `svg/logo-horizontal-transparent.svg`: marca sobre fundo transparente, com texto escuro.
- `svg/logo-horizontal-white-transparent.svg`: texto branco para fundo escuro.
- `svg/logo-stacked-light.svg` e `logo-stacked-dark.svg`: versão vertical.
- `svg/icon-*.svg`: ícones sobre fundo claro, escuro, roxo ou transparente.
- `png/`: PNGs exportados automaticamente pela GitHub Actions.

**Nota:** Os vetores são uma reconstrução geométrica do conceito visual aprovado e podem diferir levemente do desenho raster original. Os PNGs são derivados dos SVGs e podem ser regenerados a qualquer momento.

### Gerar os PNGs localmente

```bash
python -m pip install cairosvg==2.7.1
python scripts/render_branding.py
```

A publicação no GitHub também aciona uma automação que gera os PNGs na branch `main` se houver permissão para escrita por workflows.
