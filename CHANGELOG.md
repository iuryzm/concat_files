# Changelog

Todas as mudanças notáveis neste projeto serão documentadas neste arquivo.

O formato baseia-se em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/),
e este projeto adere ao [Semantic Versioning](https://semver.org/lang/pt-BR/).

## [1.1.0] - 2026-05-25

### Adicionado
- Criação dos arquivos de documentação: `README.md` e `CHANGELOG.md`.

### Alterado
- **Formato de Saída:** O arquivo gerado pelo script passou de `.txt` para `.md` (`concat_files.md`).
- **Estruturação do Conteúdo:** O conteúdo gerado agora agrupa cada arquivo em uma seção individual identificada pelo formato Markdown (`### caminho_do_arquivo`).
- **Blocos de Código:** O conteúdo dos arquivos agora é incluído dentro de blocos de código Markdown (` ```` `).
- **Realce de Sintaxe:** O script passou a extrair a extensão do arquivo e aplicar no bloco de código para que o arquivo Markdown final conte com *syntax highlighting* adequado.
- **Prevenção de Conflitos:** Blocos de código agora utilizam 4 crases no lugar de 3, garantindo que arquivos concatenados contendo blocos com 3 crases não quebrem o layout do arquivo gerado.

## [1.0.0] - Lançamento Inicial

### Adicionado
- Script principal em PowerShell (`concat_files.ps1`) para leitura e parsing do arquivo `.gitignore`.
- Identificação de regras de inclusão (`!arquivo`) para concatenação de arquivos específicos.
- Script executável em Batch (`concat_files.bat`) para atalho de inicialização no Windows.
- Mecanismo de ignorar linhas em branco, comentários ou diretórios (`/`).
- Suporte para uso de curingas em diretórios (ex: `*.txt`).
- Mecanismo automático de detecção e filtro para evitar a concatenação de arquivos binários (por extensão ou identificação de null-byte em amostra).
