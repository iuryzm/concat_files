# Concat Files (.gitignore)

Este é um utilitário simples em PowerShell (acompanhado de um script `.bat` para conveniência) projetado para ler as regras de inclusão do seu arquivo `.gitignore` (linhas iniciadas com `!`) e concatenar o conteúdo de todos esses arquivos em um único documento Markdown (`concat_files.md`).

O objetivo principal é gerar um documento de texto estruturado contendo o código/texto de arquivos importantes de um projeto, o que é extremamente útil para compartilhar contexto de código com IAs.

## ✨ Recursos

- **Baseado no `.gitignore`**: Lê automaticamente as regras do seu arquivo `.gitignore`.
- **Filtro de Inclusão**: Apenas processa os arquivos que foram explicitamente não-ignorados (ou seja, que começam com `!`).
- **Markdown Estruturado**: Cada arquivo é colocado em uma seção própria (`### caminho/do/arquivo`) e seu conteúdo é encapsulado em um bloco de código.
- **Realce de Sintaxe**: O script identifica a extensão do arquivo original e a utiliza no bloco de código Markdown para que a sintaxe seja corretamente colorida.
- **Escopo Seguro**: Utiliza 4 crases (````) para criar os blocos de código, evitando quebras acidentais caso o arquivo concatenado já possua blocos de 3 crases internamente.
- **Proteção contra Binários**: Ignora automaticamente arquivos binários baseando-se em uma lista de extensões comuns e verificações de bytes nulos (evitando sujar o arquivo gerado com caracteres ilegíveis).
- **Suporte a Curingas**: Entende e processa caminhos com curingas (ex: `!src/*.js`).

## 🚀 Como Usar

1. Certifique-se de que o arquivo `.gitignore` existe na mesma pasta que os scripts.
2. Adicione as marcações de arquivos que deseja concatenar no seu `.gitignore`, prefixando-os com `!`.
   *Exemplo no `.gitignore`:*
   ```gitignore
   # Ignorar tudo
   *
   
   # Mas incluir estes:
   !concat_files.ps1
   !README.md
   !src/*.js
   ```
3. Execute o arquivo `concat_files.bat` (dando um clique duplo) **OU** rode o script PowerShell diretamente:
   ```powershell
   .\concat_files.ps1
   ```
4. Verifique o arquivo recém-criado `concat_files.md` na mesma pasta.

## 📝 Requisitos

- Windows com PowerShell instalado.
- Os arquivos `.gitignore`, `concat_files.ps1` e `concat_files.bat` devem estar no mesmo diretório base de onde a concatenação acontecerá.
