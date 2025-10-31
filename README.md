# 🐍 Conda Development Environment with Docker

> **Stack:** Miniconda + Mamba + JupyterLab on Docker  
> **Last Updated:** October 30, 2025  
> **Configuration:** Persistent local envs + Persistent notebooks

---

## 🚀 Quick Start

### Access JupyterLab

```
http://192.168.80.200:8888
```

No password (development mode)

### Start Container

```powershell
cd d:\dockerInfraProjects\conda
docker-compose up -d
```

### Stop Container

```powershell
cd d:\dockerInfraProjects\conda
docker-compose down
```

---

## 📁 Project Structure

```
d:/dockerInfraProjects/conda/
├── 📄 docker-compose.yml     # Docker configuration (6 CPUs, 12GB RAM)
├── 📄 Dockerfile             # Base image
├── 📄 README.md              # This file
├── 📘 GUIA_COMPLETA.md       # Detailed usage guide (Spanish)
├── 🔧 .gitignore             # Git ignore patterns
├── 📁 config/
│   └── .condarc              # Conda configuration (conda-forge)
├── 📁 envs/                  # ✅ Persistent environments (gitignored)
├── 📁 pkgs/                  # ✅ Persistent package cache (gitignored)
└── 📁 scripts/               # Management scripts
```

### Persistent Data (External to Git)

```
d:/dockerVolumes/conda/
└── 📁 notebooks/             # ✅ Persistent notebooks
    ├── david/
    ├── giova/
    └── [other users]

d:/dockerInfraProjects/conda/
├── 📁 envs/                  # ✅ Persistent environments (not versioned)
└── 📁 pkgs/                  # ✅ Persistent package cache (not versioned)
```

**✅ Strategy:** Environments and packages are persistent but excluded from Git using .gitignore  
**⚠️ Note:** Use `--copy` flag when creating environments to avoid Windows symlink issues

---

## 🎯 Features

### Technology Stack

| Component | Version | Description |
|------------|---------|-------------|
| **Miniconda** | Latest | Minimal Conda installation |
| **Mamba** | Latest | Ultra-fast package manager (10x faster than Conda) |
| **JupyterLab** | 4.4.10 | Interactive IDE for notebooks |
| **Python** | 3.11 | Base for all environments |
| **Conda-Forge** | - | Primary package channel |

### Resource Allocation

- **CPUs:** 6 cores (40% of 16-core host)
- **RAM:** 12GB (40% of 32GB host)
- **Storage:** Limited only by D:\ drive capacity

### Key Features

- ✅ **No token required** - Direct access in development mode
- ✅ **Network accessible** - Available across entire local network
- ✅ **Auto-restart** - Restarts automatically on failure
- ✅ **Persistent notebooks** - Never lost
- ✅ **Persistent environments** - Survive container restarts (with --copy flag)
- ✅ **Multi-user** - Each user has their own folder
- ✅ **Isolated environments** - No dependency conflicts
- ✅ **Mamba included** - Ultra-fast package installation

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Windows Host                              │
│                 192.168.80.200:8888                          │
└─────────────────┬───────────────────────────────────────────┘
                  │
                  │ Docker Volume Mounts
                  │
┌─────────────────▼───────────────────────────────────────────┐
│              Docker Container: conda-jupyter                 │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  JupyterLab Server                                  │   │
│  │  - Port 8888                                        │   │
│  │  - No authentication                                │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                              │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  Conda Environments (✅ Persistent with --copy)     │   │
│  │  /opt/conda/envs/ → d:/dockerInfraProjects/envs/    │   │
│  │  - IA (ML + Data Science)                           │   │
│  │  - LLM (Transformers + PyTorch)                     │   │
│  │  - [your custom environments]                       │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                              │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  Workspace (✅ Persistent)                          │   │
│  │  /workspace → d:/dockerVolumes/conda/notebooks/     │   │
│  │  - All users' notebooks                             │   │
│  │  - Data and results                                 │   │
│  └─────────────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────────┘
```

---

## 📚 Guides and Documentation

### For Users

- **[COMPLETE_GUIDE.md](COMPLETE_GUIDE.md)** - Complete usage guide (English) ✨ **NEW**
  - Fundamental concepts
  - Quick commands with --copy flag
  - Step-by-step guide
  - Practical examples
  - Troubleshooting
  
- **[GUIA_COMPLETA.md](GUIA_COMPLETA.md)** - Complete usage guide (Spanish)
  - Same content in Spanish
  - Conceptos fundamentales
  - Comandos rápidos
  - Guía paso a paso

### For Administrators

- **[.gitignore](.gitignore)** - Versioning strategy
- **[docker-compose.yml](docker-compose.yml)** - Resource configuration
- **[Dockerfile](Dockerfile)** - Image definition

---

## 🎓 Common Usage Examples

### Create Machine Learning Environment

```bash
docker exec -it conda-jupyter bash -c "
source /opt/conda/etc/profile.d/conda.sh && \
conda create -n IA python=3.11 --copy -y && \
conda activate IA && \
conda install numpy pandas matplotlib seaborn scikit-learn jupyter ipykernel --copy -y && \
python -m ipykernel install --user --name IA --display-name 'Python (IA)' && \
jupyter kernelspec list
"
```

**Note:** Using `conda` with `--copy` flag instead of `mamba` to avoid Windows symlink issues.

### Create Deep Learning Environment

```bash
docker exec -it conda-jupyter bash -c "
source /opt/conda/etc/profile.d/conda.sh && \
conda create -n LLM python=3.11 --copy -y && \
conda activate LLM && \
conda install numpy pandas matplotlib jupyter ipykernel --copy -y && \
pip install transformers && \
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu && \
python -m ipykernel install --user --name LLM --display-name 'Python (LLM)' && \
jupyter kernelspec list
"
```

### View Installed Environments and Kernels

```bash
# View environments
docker exec -it conda-jupyter bash -c "conda env list"

# View kernels
docker exec -it conda-jupyter bash -c "jupyter kernelspec list"
```

---

## 🛠️ Container Management

### Basic Commands

```powershell
# Start
cd d:\dockerInfraProjects\conda
docker-compose up -d

# Stop
docker-compose down

# Restart
docker-compose restart

# View logs
docker logs conda-jupyter --tail 50 --follow

# Check status
docker ps -a --filter name=conda-jupyter

# Access terminal
docker exec -it conda-jupyter bash
```

### Full Rebuild

If you need to rebuild the image:

```powershell
cd d:\dockerInfraProjects\conda
docker-compose down
docker-compose up -d --build
```

**⚠️ Warning:** Environments in `/opt/conda/envs/` (mounted from `./envs/`) will persist, but ensure you have backups.

---

## 📊 Current Configuration

### Preconfigured Environments

| Environment | Python | Main Packages | Use Case |
|---------|--------|---------------------|-----|
| **IA** | 3.11 | numpy, pandas, scikit-learn, matplotlib, seaborn | Machine Learning, Data Science |
| **LLM** | 3.11 | transformers, torch (CPU), numpy, pandas | Large Language Models, NLP |

### Available Kernels in JupyterLab

- 🟢 **Python (IA)** - Machine Learning environment
- 🟢 **Python (LLM)** - Deep Learning environment
- 🔵 **Python 3** - Base environment

---

## 🔐 Security

### Current Configuration

- ⚠️ **No authentication** - Development mode only
- ⚠️ **Network accessible** - Available across entire local network
- ✅ **Unprivileged container** - Doesn't require root on host

### Production Recommendations

If exposing outside your local network:

1. **Enable authentication** - Add token/password to JupyterLab
2. **Configure HTTPS** - Use SSL/TLS
3. **Firewall** - Limit access by IP
4. **Review volumes** - Ensure critical data is backed up

---

## 🚨 Troubleshooting

### Container won't start

```powershell
# View logs
docker logs conda-jupyter

# Check ports
netstat -ano | findstr :8888

# Restart Docker Desktop
Restart-Service Docker
```

### Can't access JupyterLab

1. Verify the container is running:
   ```powershell
   docker ps --filter name=conda-jupyter
   ```

2. Verify the correct URL:
   ```
   http://192.168.80.200:8888
   ```

3. Check logs:
   ```powershell
   docker logs conda-jupyter --tail 50
   ```

### Symlink errors when creating environments

**Cause:** Windows filesystem (DRVFS) doesn't support symlinks in Docker volumes.

**Solution:** Use `--copy` flag with conda:
```bash
conda create -n ENV_NAME python=3.11 --copy -y
conda install PACKAGES --copy -y
```

**Note:** This is slower but works reliably on Windows volumes.

---

## 📝 Recent Changes

### October 30, 2025

- ✅ Added persistent volumes for `envs/` and `pkgs/` (gitignored)
- ✅ Updated strategy: Use `conda --copy` instead of `mamba` to avoid symlink issues
- ✅ Environments now persist across container restarts
- ✅ Notebooks continue persisting in `d:/dockerVolumes/`
- ✅ Updated complete documentation to English
- ✅ Created IA and LLM preconfigured environments
- ✅ Unified documentation in GUIA_COMPLETA.md (Spanish)

---

## 🔗 Useful Links

- **Local JupyterLab:** http://192.168.80.200:8888
- **Complete Guide (English):** [COMPLETE_GUIDE.md](COMPLETE_GUIDE.md) ✨ **NEW**
- **Conda Documentation:** https://docs.conda.io
- **Mamba Documentation:** https://mamba.readthedocs.io
- **Conda-Forge:** https://conda-forge.org

---

## 📄 License

This project is for internal development use. Individual components (Conda, Mamba, JupyterLab) maintain their respective licenses.

---

**Created with ❤️ for efficient scientific development**  
**Last updated:** October 30, 2025
