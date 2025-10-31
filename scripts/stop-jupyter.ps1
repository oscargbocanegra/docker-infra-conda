# =====================================================
# Script: Detener Conda JupyterLab
# =====================================================

Write-Host "=== DETENIENDO CONDA JUPYTERLAB ===" -ForegroundColor Yellow

$projectPath = "d:\dockerProjects\conda"
Set-Location $projectPath

# Verificar si el contenedor esta corriendo
$containerRunning = docker ps --filter "name=conda-jupyter" --format "{{.Names}}"

if ($containerRunning) {
    Write-Host "`n[INFO] Deteniendo contenedor..." -ForegroundColor Cyan
    docker-compose down
    Write-Host "[OK] Contenedor detenido" -ForegroundColor Green
    Write-Host "[INFO] Los volumenes permanecen intactos" -ForegroundColor Gray
} else {
    Write-Host "`n[INFO] El contenedor no esta corriendo" -ForegroundColor Gray
}

Write-Host "`n=== FIN ===" -ForegroundColor Yellow
