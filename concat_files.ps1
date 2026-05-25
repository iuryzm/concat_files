Write-Host "========================================" -ForegroundColor Cyan
Write-Host "CONCATENADOR DE ARQUIVOS DO .GITIGNORE" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "O QUE ESTE PROGRAMA FAZ:" -ForegroundColor Yellow
Write-Host "  - Le o arquivo .gitignore" -ForegroundColor White
Write-Host "  - Identifica arquivos marcados com '!' (nao ignorados)" -ForegroundColor White
Write-Host "  - Concatena o conteudo desses arquivos em concat_files.md" -ForegroundColor White
Write-Host "  - Adiciona cada arquivo em uma secao com blocos de codigo" -ForegroundColor White
Write-Host "  - Ignora arquivos binarios (imagens, executaveis, etc)" -ForegroundColor White
Write-Host ""
Write-Host "RECURSOS IMPLEMENTADOS:" -ForegroundColor Yellow
Write-Host "  [X] Ignora linhas de comentario (iniciadas com #)" -ForegroundColor Green
Write-Host "  [X] Ignora linhas vazias" -ForegroundColor Green
Write-Host "  [X] Ignora diretorios (terminados com /)" -ForegroundColor Green
Write-Host "  [X] Processa apenas arquivos marcados com !" -ForegroundColor Green
Write-Host "  [X] Cria secoes em Markdown com blocos de codigo" -ForegroundColor Green
Write-Host "  [X] Adiciona linha em branco apos cada arquivo" -ForegroundColor Green
Write-Host "  [X] Exibe avisos para arquivos nao encontrados" -ForegroundColor Green
Write-Host "  [X] Ignora arquivos binarios automaticamente" -ForegroundColor Green
Write-Host ""
Write-Host "Iniciando processamento..." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$output = "concat_files.md"

# Lista de extensões binárias conhecidas
$extensoesBinarias = @(
    '.ico', '.png', '.jpg', '.jpeg', '.gif', '.bmp', '.webp', '.svg',
    '.exe', '.dll', '.so', '.dylib', '.bin',
    '.zip', '.rar', '.7z', '.tar', '.gz',
    '.pdf', '.doc', '.docx', '.xls', '.xlsx', '.ppt', '.pptx',
    '.mp3', '.mp4', '.avi', '.mkv', '.wav',
    '.ttf', '.otf', '.woff', '.woff2', '.eot',
    '.class', '.jar', '.pyc', '.pyo',
    '.db', '.sqlite', '.mdb', '.parquet'
)

# Função para verificar se um arquivo é binário
function Test-IsBinaryFile {
    param([string]$filePath)
    
    # Verificar extensão primeiro
    $extension = [System.IO.Path]::GetExtension($filePath).ToLower()
    if ($extensoesBinarias -contains $extension) {
        return $true
    }
    
    # Ler primeiros 8KB para detectar bytes nulos (indicador de arquivo binário)
    try {
        $bytes = [System.IO.File]::ReadAllBytes($filePath)
        $sampleSize = [Math]::Min(8192, $bytes.Length)
        
        for ($i = 0; $i -lt $sampleSize; $i++) {
            if ($bytes[$i] -eq 0) {
                return $true
            }
        }
        
        return $false
    }
    catch {
        # Em caso de erro na leitura, considerar como binário por segurança
        return $true
    }
}

if (Test-Path $output) {
    Remove-Item $output
}

$arquivosProcessados = 0
$arquivosIgnorados = 0
$arquivosNaoEncontrados = 0

Get-Content ".gitignore" | ForEach-Object {
    $line = $_.Trim()

    if ($line -and $line[0] -ne '#') {
        if ($line[0] -eq '!') {
            $filepath = $line.Substring(1)

            # Ignorar diretórios (terminados com /)
            if ($filepath -match '/$') { return }

            $hasWildcard = ($filepath -match '[\*\?]')

            if (-not $hasWildcard) {
                # ===== caso arquivo único (sem curinga) =====
                if (Test-Path $filepath) {
                    if (Test-IsBinaryFile $filepath) {
                        Write-Host "IGNORADO (binario): $filepath"
                        $arquivosIgnorados++
                    } else {
                        Write-Host "Concatenando: $filepath"
                        $ext = [System.IO.Path]::GetExtension($filepath).TrimStart('.')
                        "### $filepath`r`n" + '````' + $ext | Out-File -Append -Encoding UTF8 $output
                        Get-Content -Path $filepath -Raw -Encoding UTF8 | Out-File -Append -Encoding UTF8 $output
                        "`r`n" + '````' + "`r`n" | Out-File -Append -Encoding UTF8 $output
                        $arquivosProcessados++
                    }
                } else {
                    Write-Host "AVISO: Arquivo nao encontrado - $filepath"
                    $arquivosNaoEncontrados++
                }
            }
            else {
                # ===== caso com curinga (ex.: dados/*.xlsx) =====
                $dir  = Split-Path $filepath -Parent
                $leaf = Split-Path $filepath -Leaf

                # CORREÇÃO: linha que estava incompleta
                if ([string]::IsNullOrEmpty($dir)) {
                    # Se não houver diretório (ex.: "*.txt" sem caminho), assume o diretório atual
                    $dir = "."
                }

                if (Test-Path $dir) {
                    $matches = Get-ChildItem -Path $dir -Filter $leaf -File -ErrorAction SilentlyContinue

                    if (-not $matches -or $matches.Count -eq 0) {
                        Write-Host "AVISO: Nenhum arquivo encontrado para - $filepath" -ForegroundColor Red
                        $arquivosNaoEncontrados++
                    }
                    else {
                        foreach ($f in $matches) {
                            $relative = $f.FullName

                            if (Test-IsBinaryFile $relative) {
                                Write-Host "IGNORADO (binario): $relative" -ForegroundColor Yellow
                                $arquivosIgnorados++
                            } else {
                                Write-Host "Concatenando: $relative"
                                $ext = [System.IO.Path]::GetExtension($relative).TrimStart('.')
                                "### $relative`r`n" + '````' + $ext | Out-File -Append -Encoding UTF8 $output
                                Get-Content -Path $relative -Raw -Encoding UTF8 | Out-File -Append -Encoding UTF8 $output
                                "`r`n" + '````' + "`r`n" | Out-File -Append -Encoding UTF8 $output
                                $arquivosProcessados++
                            }
                        }
                    }
                } else {
                    Write-Host "AVISO: Diretorio nao encontrado - $dir (da regra $filepath)" -ForegroundColor Red
                    $arquivosNaoEncontrados++
                }
            }
        }
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "RESUMO DO PROCESSAMENTO:" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Arquivos concatenados: $arquivosProcessados" -ForegroundColor Green
Write-Host "  Arquivos ignorados (binarios): $arquivosIgnorados" -ForegroundColor Yellow
Write-Host "  Arquivos nao encontrados: $arquivosNaoEncontrados" -ForegroundColor Red
Write-Host ""

if (Test-Path $output) {
    Write-Host "Processo concluido! Arquivo gerado: $output" -ForegroundColor Green
}
else {
    Write-Host "ERRO: Nenhum arquivo foi concatenado!" -ForegroundColor Red
}
