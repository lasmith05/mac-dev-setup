# Windows Dev Environment Setup Script
# Run this as Administrator in PowerShell

Write-Host "Setting up Windows Development Environment..." -ForegroundColor Green

# Check if running as Administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as Administrator!" -ForegroundColor Red
    Write-Host "Right-click PowerShell and select 'Run as Administrator'" -ForegroundColor Red
    exit 1
}

# Set execution policy to allow scripts to run
Write-Host "Setting PowerShell execution policy..." -ForegroundColor Yellow
try {
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Write-Host "PowerShell execution policy set successfully" -ForegroundColor Green
} catch {
    Write-Host "Warning: Could not set execution policy: $($_.Exception.Message)" -ForegroundColor Yellow
}

# Install WSL2 with Ubuntu 24.04 LTS
Write-Host "Installing WSL2 with Ubuntu 24.04 LTS..." -ForegroundColor Yellow
wsl --install -d Ubuntu-24.04

# Install Windows applications via winget
Write-Host "Installing Windows applications..." -ForegroundColor Yellow

# Visual Studio Code
Write-Host "Installing Visual Studio Code (silent)..." -ForegroundColor Cyan
winget install Microsoft.VisualStudioCode --silent --accept-source-agreements --accept-package-agreements
if ($LASTEXITCODE -eq 0) { Write-Host "✓ Visual Studio Code installed successfully" -ForegroundColor Green }

# Git for Windows
Write-Host "Installing Git for Windows (silent)..." -ForegroundColor Cyan
winget install Git.Git --silent --accept-source-agreements --accept-package-agreements
if ($LASTEXITCODE -eq 0) { Write-Host "✓ Git for Windows installed successfully" -ForegroundColor Green }

# Terraform
Write-Host "Installing Terraform (silent)..." -ForegroundColor Cyan
winget install HashiCorp.Terraform --silent --accept-source-agreements --accept-package-agreements
if ($LASTEXITCODE -eq 0) { Write-Host "✓ Terraform installed successfully" -ForegroundColor Green }

# Windows Terminal (if not already installed)
Write-Host "Installing Windows Terminal (silent)..." -ForegroundColor Cyan
winget install Microsoft.WindowsTerminal --silent --accept-source-agreements --accept-package-agreements
if ($LASTEXITCODE -eq 0) { Write-Host "✓ Windows Terminal installed successfully" -ForegroundColor Green }

# Docker Desktop (optional but useful)
Write-Host "Installing Docker Desktop (silent)..." -ForegroundColor Cyan
winget install Docker.DockerDesktop --silent --accept-source-agreements --accept-package-agreements
if ($LASTEXITCODE -eq 0) { Write-Host "✓ Docker Desktop installed successfully" -ForegroundColor Green }

# TeamViewer (remote control)
Write-Host "Installing TeamViewer (silent)..." -ForegroundColor Cyan
winget install TeamViewer.TeamViewer --silent --accept-source-agreements --accept-package-agreements
if ($LASTEXITCODE -eq 0) { Write-Host "✓ TeamViewer installed successfully" -ForegroundColor Green }

Write-Host ""
Write-Host "Windows setup complete!" -ForegroundColor Green
Write-Host "All applications were installed silently without user interaction." -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Restart your computer to complete WSL installation" -ForegroundColor White
Write-Host "2. After restart, open Windows Terminal" -ForegroundColor White
Write-Host "3. Type 'wsl' to enter Ubuntu" -ForegroundColor White
Write-Host "4. Run these commands in Ubuntu:" -ForegroundColor White
Write-Host "   cd ~" -ForegroundColor Cyan
Write-Host "   cp /mnt/c/$(Split-Path -Leaf $PWD)/* ." -ForegroundColor Cyan
Write-Host "   chmod +x ubuntu-setup.sh" -ForegroundColor Cyan
Write-Host "   ./ubuntu-setup.sh" -ForegroundColor Cyan
Write-Host ""
Write-Host "Current setup folder: $PWD" -ForegroundColor Yellow
Write-Host "Remember this path for the Ubuntu setup step!" -ForegroundColor Yellow
