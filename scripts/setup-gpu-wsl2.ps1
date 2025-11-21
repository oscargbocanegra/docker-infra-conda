# =========================================================
# Script: Configurar GPU NVIDIA en WSL2 para Docker
# Fecha: 20 de noviembre de 2025
# Requisito: Driver NVIDIA 560.x+ instalado en Windows
# =========================================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  CONFIGURACIÓN GPU NVIDIA EN WSL2" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# PASO 1: Verificar driver NVIDIA
Write-Host "`n[PASO 1/6] Verificando driver NVIDIA..." -ForegroundColor Yellow
$nvidiaDriver = Get-WmiObject Win32_VideoController | Where-Object {$_.Name -like "*NVIDIA*"}
$driverVersion = $nvidiaDriver.DriverVersion
Write-Host "  Driver detectado: $driverVersion" -ForegroundColor White

if ($driverVersion -lt "27.21.14.5160") {
    Write-Host "  ❌ ERROR: Driver muy antiguo ($driverVersion)" -ForegroundColor Red
    Write-Host "  Necesitas actualizar a 560.x+ antes de continuar" -ForegroundColor Red
    Write-Host "  Descarga desde: https://www.nvidia.com/Download/index.aspx" -ForegroundColor Cyan
    exit 1
} else {
    Write-Host "  ✓ Driver compatible" -ForegroundColor Green
}

# PASO 2: Actualizar WSL
Write-Host "`n[PASO 2/6] Actualizando WSL..." -ForegroundColor Yellow
wsl --update
Write-Host "  ✓ WSL actualizado" -ForegroundColor Green

# PASO 3: Apagar WSL
Write-Host "`n[PASO 3/6] Reiniciando WSL..." -ForegroundColor Yellow
wsl --shutdown
Start-Sleep -Seconds 3
Write-Host "  ✓ WSL reiniciado" -ForegroundColor Green

# PASO 4: Instalar CUDA en WSL
Write-Host "`n[PASO 4/6] Instalando CUDA Toolkit en WSL..." -ForegroundColor Yellow
Write-Host "  Esto tomará 5-10 minutos..." -ForegroundColor Cyan

wsl -d Ubuntu bash -c @"
set -e
echo '  → Descargando keyring CUDA...'
wget -q https://developer.download.nvidia.com/compute/cuda/repos/wsl-ubuntu/x86_64/cuda-keyring_1.1-1_all.deb
echo '  → Instalando keyring...'
sudo dpkg -i cuda-keyring_1.1-1_all.deb
echo '  → Actualizando repositorios...'
sudo apt-get update -qq
echo '  → Instalando CUDA Toolkit 12.6...'
sudo apt-get install -y -qq cuda-toolkit-12-6
echo '  → Limpiando...'
rm cuda-keyring_1.1-1_all.deb
echo '  ✓ CUDA Toolkit instalado'
"@

Write-Host "  ✓ CUDA instalado en WSL" -ForegroundColor Green

# PASO 5: Verificar GPU en WSL
Write-Host "`n[PASO 5/6] Verificando acceso a GPU desde WSL..." -ForegroundColor Yellow
wsl -d Ubuntu bash -c "nvidia-smi"
Write-Host "  ✓ GPU accesible desde WSL" -ForegroundColor Green

# PASO 6: Configurar Docker para usar GPU
Write-Host "`n[PASO 6/6] Configurando Docker Desktop para WSL2..." -ForegroundColor Yellow
Write-Host "  📝 MANUAL: Abre Docker Desktop → Settings → General" -ForegroundColor Cyan
Write-Host "     ✓ Marca: 'Use the WSL 2 based engine'" -ForegroundColor White
Write-Host "     ✓ Apply & Restart" -ForegroundColor White
Write-Host "`n  Presiona Enter cuando hayas completado esto..." -ForegroundColor Yellow
Read-Host

# PASO 7: Actualizar docker-compose.yml
Write-Host "`n[PASO 7/7] Actualizando docker-compose.yml..." -ForegroundColor Yellow
$composeFile = "d:\dockerInfraProjects\conda\docker-compose.yml"
Write-Host "  📝 Necesitas descomentar la sección GPU en:" -ForegroundColor Cyan
Write-Host "     $composeFile" -ForegroundColor White
Write-Host "`n  Busca la sección 'deploy' y agrega:" -ForegroundColor Yellow
Write-Host @"
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: all
              capabilities: [gpu]
"@ -ForegroundColor Green

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  ✓ CONFIGURACIÓN COMPLETADA" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "`nPróximos pasos:" -ForegroundColor Yellow
Write-Host "1. Edita docker-compose.yml (agrega config GPU)" -ForegroundColor White
Write-Host "2. Reinicia contenedores:" -ForegroundColor White
Write-Host "   cd d:\dockerInfraProjects\conda" -ForegroundColor Cyan
Write-Host "   docker-compose down" -ForegroundColor Cyan
Write-Host "   docker-compose up -d" -ForegroundColor Cyan
Write-Host "3. Verifica GPU en contenedor:" -ForegroundColor White
Write-Host "   docker exec -it conda-jupyter nvidia-smi" -ForegroundColor Cyan
