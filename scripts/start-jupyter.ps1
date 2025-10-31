# =====================================================
# Script: Iniciar Conda JupyterLab
# =====================================================

Write-Host "=== CONDA JUPYTERLAB DOCKER ===" -ForegroundColor Green

$projectPath = "d:\dockerProjects\conda"

# Verificar que Docker este corriendo
$dockerProcess = Get-Process -Name "Docker Desktop" -ErrorAction SilentlyContinue

if (-not $dockerProcess) {
    Write-Host "`n[WARNING] Docker Desktop no esta corriendo" -ForegroundColor Yellow
    Write-Host "[INFO] Iniciando Docker Desktop..." -ForegroundColor Cyan
    Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe"
    Write-Host "[INFO] Esperando a que Docker este listo..." -ForegroundColor Gray
    Start-Sleep -Seconds 15
}

# Cambiar al directorio del proyecto
Set-Location $projectPath

# Verificar si el contenedor ya existe
$containerExists = docker ps -a --filter "name=conda-jupyter" --format "{{.Names}}"

if ($containerExists) {
    Write-Host "`n[INFO] Contenedor existente encontrado" -ForegroundColor Cyan
    
    $containerRunning = docker ps --filter "name=conda-jupyter" --format "{{.Names}}"
    
    if ($containerRunning) {
        Write-Host "[OK] Contenedor ya esta corriendo" -ForegroundColor Green
    } else {
        Write-Host "[INFO] Iniciando contenedor existente..." -ForegroundColor Cyan
        docker start conda-jupyter
        Write-Host "[OK] Contenedor iniciado" -ForegroundColor Green
    }
} else {
    Write-Host "`n[INFO] Construyendo imagen por primera vez..." -ForegroundColor Cyan
    Write-Host "[INFO] Esto puede tardar varios minutos..." -ForegroundColor Yellow
    docker-compose up -d --build
    Write-Host "[OK] Contenedor creado e iniciado" -ForegroundColor Green
}

# Esperar a que JupyterLab este listo
Write-Host "`n[INFO] Esperando a que JupyterLab este listo..." -ForegroundColor Gray
Start-Sleep -Seconds 5

# Obtener logs para ver la URL de acceso
Write-Host "`n=== INFORMACION DE ACCESO ===" -ForegroundColor Cyan
docker logs conda-jupyter --tail 20

Write-Host "`n[OK] JupyterLab accesible en: http://192.168.80.200:8888" -ForegroundColor Green
Write-Host "[INFO] Sin token requerido (modo desarrollo)" -ForegroundColor Yellow

# Abrir en navegador
Write-Host "`n[INFO] Abriendo en navegador..." -ForegroundColor Cyan
Start-Sleep -Seconds 2
Start-Process "http://192.168.80.200:8888/lab"

Write-Host "`n=== COMANDOS UTILES ===" -ForegroundColor Yellow
Write-Host "Ver logs:        docker logs conda-jupyter -f" -ForegroundColor Gray
Write-Host "Ejecutar bash:   docker exec -it conda-jupyter bash" -ForegroundColor Gray
Write-Host "Detener:         docker stop conda-jupyter" -ForegroundColor Gray
Write-Host "Reiniciar:       docker restart conda-jupyter" -ForegroundColor Gray

Write-Host "`n=== FIN ===" -ForegroundColor Green
