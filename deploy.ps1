# Deploie jardinagebalcon.fr en PRODUCTION via Cloudflare Pages (wrangler local).
# Usage : depuis le dossier site\, lancer  .\deploy.ps1
# Prerequis : etre connecte a wrangler (npx wrangler whoami doit afficher ton compte).

$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

# 1. Construire un dossier propre (sans .git/.github/cache) = le contenu reel du site
Remove-Item -Recurse -Force dist -ErrorAction SilentlyContinue
New-Item -ItemType Directory dist | Out-Null
robocopy . dist /E /XD .git .github dist .wrangler node_modules /NFL /NDL /NJH /NJS | Out-Null
if ($LASTEXITCODE -ge 8) { throw "robocopy a echoue (code $LASTEXITCODE)" }
$global:LASTEXITCODE = 0

# 2. Deployer en production (branche main = branche de prod du projet)
Write-Host "Deploiement Cloudflare Pages en cours..." -ForegroundColor Cyan
npx wrangler pages deploy dist --project-name=jardinagebalcon --branch=main

Write-Host "`nTermine. Le site est en ligne sur https://jardinagebalcon.fr" -ForegroundColor Green
