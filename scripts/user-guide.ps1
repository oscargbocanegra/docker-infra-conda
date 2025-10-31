# =====================================================
# Script: Guia de Usuarios - Conda Docker
# =====================================================

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "   CONDA DOCKER - GUIA MULTI-USUARIO" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "USUARIOS CONFIGURADOS:" -ForegroundColor Yellow
$users = @('david', 'giova', 'kamil', 'master')
foreach ($user in $users) {
    $notebookPath = "d:\dockerProjects\conda\notebooks\$user"
    $envPath = "d:\dockerProjects\conda\envs\$user"
    if ((Test-Path $notebookPath) -and (Test-Path $envPath)) {
        Write-Host "  [OK] $user" -ForegroundColor Green
    } else {
        Write-Host "  [!] $user (incompleto)" -ForegroundColor Yellow
    }
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "ACCESO A JUPYTERLAB" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "URL: http://192.168.80.200:8888/lab" -ForegroundColor White
Write-Host "Sin token requerido (modo desarrollo)`n" -ForegroundColor Gray

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "CREAR TU ENTORNO PERSONAL" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan

Write-Host "`n1. Conectar al contenedor:" -ForegroundColor White
Write-Host "   docker exec -it conda-jupyter bash`n" -ForegroundColor Gray

Write-Host "2. Crear tu entorno (reemplaza 'USUARIO' con tu nombre):" -ForegroundColor White
Write-Host "   mamba create -n USUARIO_env python=3.11 -y`n" -ForegroundColor Gray

Write-Host "3. Activar tu entorno:" -ForegroundColor White
Write-Host "   conda activate USUARIO_env`n" -ForegroundColor Gray

Write-Host "4. Instalar paquetes:" -ForegroundColor White
Write-Host "   mamba install numpy pandas matplotlib scikit-learn jupyter -y`n" -ForegroundColor Gray

Write-Host "5. Registrar kernel en JupyterLab:" -ForegroundColor White
Write-Host '   python -m ipykernel install --user --name USUARIO_env --display-name "Python (USUARIO)"' -ForegroundColor Gray
Write-Host "`n" -ForegroundColor Gray

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "DIRECTORIOS PERSONALES" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan

foreach ($user in $users) {
    Write-Host "`n$user" -ForegroundColor White -NoNewline
    Write-Host ":" -ForegroundColor Gray
    Write-Host "  Notebooks: notebooks/$user/" -ForegroundColor Gray
    Write-Host "  Entornos:  envs/$user/" -ForegroundColor Gray
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "COMANDOS UTILES" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan

Write-Host "`nIniciar JupyterLab:" -ForegroundColor White
Write-Host "  cd d:\dockerProjects\conda" -ForegroundColor Gray
Write-Host "  .\start-jupyter.ps1`n" -ForegroundColor Gray

Write-Host "Detener JupyterLab:" -ForegroundColor White
Write-Host "  .\stop-jupyter.ps1`n" -ForegroundColor Gray

Write-Host "Ver contenedores corriendo:" -ForegroundColor White
Write-Host "  docker ps`n" -ForegroundColor Gray

Write-Host "Ver logs:" -ForegroundColor White
Write-Host "  docker logs conda-jupyter -f`n" -ForegroundColor Gray

Write-Host "Listar entornos creados:" -ForegroundColor White
Write-Host "  docker exec -it conda-jupyter conda env list`n" -ForegroundColor Gray

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "PERMISOS VERIFICADOS" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan

# Verificar permisos
$acl = Get-Acl "d:\dockerProjects\conda"
Write-Host "`nDirectorio: d:\dockerProjects\conda" -ForegroundColor White
Write-Host "  Propietario: $($acl.Owner)" -ForegroundColor Gray

$usersPermission = $acl.Access | Where-Object {$_.IdentityReference -like "*Usuarios*" -or $_.IdentityReference -like "*Users*"}
if ($usersPermission) {
    Write-Host "  Acceso Usuarios: FullControl (OK)" -ForegroundColor Green
} else {
    Write-Host "  Acceso Usuarios: Limitado (REVISAR)" -ForegroundColor Yellow
}

Write-Host "`n========================================`n" -ForegroundColor Cyan
