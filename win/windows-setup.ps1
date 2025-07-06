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
    Write-Host "✅ PowerShell execution policy set successfully" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Could not set execution policy: $($_.Exception.Message)" -ForegroundColor Yellow
}

# Install WSL2 with Ubuntu 24.04 LTS
Write-Host "Installing WSL2 with Ubuntu 24.04 LTS..." -ForegroundColor Yellow
wsl --install -d Ubuntu-24.04

# Install Windows applications via winget
Write-Host "Installing Windows applications..." -ForegroundColor Yellow

# Visual Studio Code
Write-Host "Installing Visual Studio Code..." -ForegroundColor Cyan
winget install Microsoft.VisualStudioCode

# Git for Windows
Write-Host "Installing Git for Windows..." -ForegroundColor Cyan
winget install Git.Git

# Terraform
Write-Host "Installing Terraform..." -ForegroundColor Cyan
winget install HashiCorp.Terraform

# Windows Terminal (if not already installed)
Write-Host "Installing Windows Terminal..." -ForegroundColor Cyan
winget install Microsoft.WindowsTerminal

# Docker Desktop (optional but useful)
Write-Host "Installing Docker Desktop..." -ForegroundColor Cyan
winget install Docker.DockerDesktop

# AWS CLI
Write-Host "Installing AWS CLI..." -ForegroundColor Cyan
winget install Amazon.AWSCLI

# Try to install Claude Code (may not be available yet)
Write-Host "Attempting to install Claude Code..." -ForegroundColor Cyan
try {
    winget install Anthropic.ClaudeCode
    Write-Host "Claude Code installed successfully!" -ForegroundColor Green
} catch {
    Write-Host "Claude Code not available via winget yet. Check Anthropic's documentation for manual installation." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Windows setup complete!" -ForegroundColor Green
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
Write-Host "📁 Current setup folder: $PWD" -ForegroundColor Yellow
Write-Host "💾 Remember this path for the Ubuntu setup step!" -ForegroundColor Yellow
