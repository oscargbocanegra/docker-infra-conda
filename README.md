# 🐍 Conda Development Environment with Docker + GPU

> **Stack:** Miniconda + Mamba + JupyterLab + NVIDIA GPU on Docker  
> **Last Updated:** November 20, 2025  
> **Configuration:** Persistent envs + GPU Support + HuggingFace Cache

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
├── 📄 docker-compose.yml         # Active configuration (with GPU)
├── 📄 docker-compose-gpu.yml     # GPU-enabled configuration
├── 📄 docker-compose-backup.yml  # Backup (pre-GPU config)
├── 📄 Dockerfile                 # Base image
├── 📄 README.md                  # This file
├── 📘 COMPLETE_GUIDE.md          # Detailed usage guide (English)
├── 📘 TEST_GPU.md                # GPU testing guide
├── 🔧 .gitignore                 # Git ignore patterns
├── 📁 config/
│   └── .condarc                  # Conda configuration (conda-forge)
├── 📁 envs/                      # ✅ Persistent environments (gitignored)
├── 📁 pkgs/                      # ✅ Persistent package cache (gitignored)
└── 📁 scripts/                   # Management scripts

d:/dockerInfraProjects/
└── 📄 setup-gpu-wsl2.ps1         # GPU setup automation script
```

### Persistent Data (External to Git)

```
d:/dockerVolumes/conda/
├── 📁 notebooks/             # ✅ Persistent notebooks
│   ├── david/
│   ├── giova/
│   └── [other users]
└── 📁 hf_cache/              # ✅ HuggingFace models cache

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
| **PyTorch** | 2.5.1+cu121 | Deep learning with CUDA support |
| **CUDA** | 13.0 | GPU acceleration framework |
| **Conda-Forge** | - | Primary package channel |

### GPU Configuration

| Component | Specification |
|-----------|---------------|
| **GPU** | NVIDIA GeForce RTX 2080 Ti (11GB VRAM) |
| **Driver** | 581.80 (Windows) |
| **CUDA Version** | 13.0 |
| **Docker Backend** | WSL2 |
| **GPU Access** | All capabilities (compute, utility) |

### Resource Allocation

- **CPUs:** 6 cores (limit) / 3 cores (reservation)
- **RAM:** 12GB (limit) / 6GB (reservation)
- **GPU:** RTX 2080 Ti (11GB VRAM)
- **Storage:** Limited only by D:\ drive capacity

### Key Features

- ✅ **GPU Acceleration** - NVIDIA RTX 2080 Ti with CUDA 13.0
- ✅ **PyTorch with CUDA** - Pre-installed for deep learning
- ✅ **No token required** - Direct access in development mode
- ✅ **Network accessible** - Available across entire local network
- ✅ **Auto-restart** - Restarts automatically on system reboot
- ✅ **Persistent notebooks** - Never lost (dockerVolumes)
- ✅ **Persistent environments** - Survive container restarts
- ✅ **HuggingFace cache** - Models persist across restarts
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
│                                                              │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  HuggingFace Cache (✅ Persistent)                  │   │
│  │  /root/.cache/huggingface → d:/dockerVolumes/hf_cache/ │
│  │  - Transformers models                              │   │
│  │  - Tokenizers                                       │   │
│  └─────────────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────────┘
```

---

## 📚 Guides and Documentation

### For Users

- **[COMPLETE_GUIDE.md](COMPLETE_GUIDE.md)** - Complete usage guide (English)
  - Fundamental concepts
  - Quick commands with --copy flag
  - Step-by-step guide
  - Practical examples
  - Troubleshooting

- **[TEST_GPU.md](TEST_GPU.md)** - GPU testing and verification ✨ **NEW**
  - GPU verification scripts
  - PyTorch CUDA tests
  - Performance benchmarks
  - Example notebooks

### For Administrators

- **[.gitignore](.gitignore)** - Versioning strategy
- **[docker-compose.yml](docker-compose.yml)** - Active configuration (GPU-enabled)
- **[docker-compose-gpu.yml](docker-compose-gpu.yml)** - GPU configuration template
- **[Dockerfile](Dockerfile)** - Image definition
- **[setup-gpu-wsl2.ps1](../setup-gpu-wsl2.ps1)** - GPU setup automation script

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

### Create Deep Learning Environment with GPU

```bash
docker exec -it conda-jupyter bash -c "
source /opt/conda/etc/profile.d/conda.sh && \
conda create -n LLM python=3.11 --copy -y && \
conda activate LLM && \
conda install numpy pandas matplotlib jupyter ipykernel --copy -y && \
pip install transformers torch torchvision --index-url https://download.pytorch.org/whl/cu121 && \
python -m ipykernel install --user --name LLM --display-name 'Python (LLM)' && \
jupyter kernelspec list
"
```

**Note:** PyTorch with CUDA 12.1 support for GPU acceleration.

### Test GPU in Container

```bash
# Quick GPU test
docker exec -it conda-jupyter nvidia-smi

# PyTorch CUDA test
docker exec -it conda-jupyter python -c "import torch; print('CUDA available:', torch.cuda.is_available()); print('GPU:', torch.cuda.get_device_name(0) if torch.cuda.is_available() else 'N/A')"
```

### View Installed Environments and Kernels

```bash
# View environments
docker exec -it conda-jupyter bash -c "conda env list"

# View kernels
docker exec -it conda-jupyter bash -c "jupyter kernelspec list"
```

### Register Kernel for Existing Environment

If you have environments that don't appear in JupyterLab:

```bash
# Register kernel for existing environment
docker exec -it conda-jupyter bash -c "/opt/conda/envs/ENV_NAME/bin/python -m pip install ipykernel && /opt/conda/envs/ENV_NAME/bin/python -m ipykernel install --user --name ENV_NAME --display-name 'Python (DISPLAY_NAME)'"

# Verify registration
docker exec -it conda-jupyter bash -c "jupyter kernelspec list"
```

**Then refresh JupyterLab (F5) to see the new kernel.**

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

**⚠️ Warning:** Environments in `/opt/conda/envs/` will persist, but kernels in `/root/.local/` will be lost and need re-registration.

**Re-register kernels after rebuild:**
```bash
# IA environment
docker exec -it conda-jupyter bash -c "/opt/conda/envs/IA/bin/python -m pip install ipykernel && /opt/conda/envs/IA/bin/python -m ipykernel install --user --name IA --display-name 'Python (IA)'"

# LLM environment
docker exec -it conda-jupyter bash -c "/opt/conda/envs/LLM/bin/python -m pip install ipykernel && /opt/conda/envs/LLM/bin/python -m ipykernel install --user --name LLM --display-name 'Python (LLM)'"
```

---

## 🎮 GPU Configuration

### Current Setup

- ✅ **GPU:** NVIDIA GeForce RTX 2080 Ti (11GB VRAM)
- ✅ **Driver:** 581.80
- ✅ **CUDA:** 13.0
- ✅ **PyTorch:** 2.5.1+cu121 (pre-installed in base)
- ✅ **Backend:** WSL2

### Verify GPU

```bash
# From host (PowerShell)
wsl -d Ubuntu -e /usr/lib/wsl/lib/nvidia-smi

# From container
docker exec -it conda-jupyter nvidia-smi

# PyTorch test
docker exec -it conda-jupyter python -c "import torch; print('CUDA available:', torch.cuda.is_available())"
```

### GPU Setup (If Needed)

If you need to reconfigure GPU or set up on a new machine:

```powershell
cd d:\dockerInfraProjects
.\setup-gpu-wsl2.ps1
```

See **[TEST_GPU.md](TEST_GPU.md)** for detailed GPU testing examples.

---

## 📊 Current Configuration

### Preconfigured Environments

| Environment | Python | Main Packages | GPU | Use Case |
|---------|--------|---------------------|-----|----------|
| **base** | 3.11 | PyTorch 2.5.1+cu121, CUDA support | ✅ | General purpose with GPU |
| **IA** | 3.11 | numpy, pandas, scikit-learn, matplotlib, seaborn | ✅ | Machine Learning, Data Science |
| **LLM** | 3.11 | transformers, torch+CUDA, numpy, pandas | ✅ | Large Language Models, NLP |

### Available Kernels in JupyterLab

- 🟢 **Python (IA)** - Machine Learning environment with GPU
- 🟢 **Python (LLM)** - Deep Learning environment with GPU
- 🔵 **Python 3** - Base environment with PyTorch+CUDA

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

### Environment exists but kernel doesn't appear in JupyterLab

**Symptom:** You can see the environment with `conda env list` but not in JupyterLab's kernel selector.

**Cause:** The kernel was never registered or was lost after container rebuild.

**Solution:**
```bash
# Register kernel for existing environment
docker exec -it conda-jupyter bash -c "/opt/conda/envs/ENV_NAME/bin/python -m pip install ipykernel && /opt/conda/envs/ENV_NAME/bin/python -m ipykernel install --user --name ENV_NAME --display-name 'Python (DISPLAY_NAME)'"

# Verify registration
docker exec -it conda-jupyter bash -c "jupyter kernelspec list"
```

**Then refresh JupyterLab (F5).**

This commonly happens after:
- Container rebuild (`docker-compose up -d --build`)
- Switching docker-compose files
- System restart

---

### GPU not detected in container

**Symptom:** `nvidia-smi` command not found or CUDA not available in PyTorch.

**Solutions:**

1. **Verify Docker is using WSL2 backend:**
   - Docker Desktop → Settings → General
   - ✅ "Use the WSL 2 based engine"

2. **Verify GPU drivers in WSL:**
   ```powershell
   wsl -d Ubuntu -e /usr/lib/wsl/lib/nvidia-smi
   ```

3. **Rebuild container with GPU config:**
   ```powershell
   cd d:\dockerInfraProjects\conda
   docker-compose down
   docker-compose up -d
   ```

4. **Run full GPU setup:**
   ```powershell
   cd d:\dockerInfraProjects
   .\setup-gpu-wsl2.ps1
   ```

---

## 📝 Recent Changes

### November 20, 2025 - **GPU Support Added** 🎮

- ✅ NVIDIA RTX 2080 Ti GPU fully integrated
- ✅ CUDA 13.0 + PyTorch 2.5.1+cu121 installed
- ✅ Docker Desktop switched to WSL2 backend
- ✅ HuggingFace cache volume added
- ✅ Automatic kernel registration documented
- ✅ GPU testing guide created (TEST_GPU.md)
- ✅ Setup automation script (setup-gpu-wsl2.ps1)

### November 19, 2025

- ✅ Added HuggingFace cache volume (`d:/dockerVolumes/hf_cache` → `/root/.cache/huggingface`)
- ✅ Documented how to register kernels for existing environments
- ✅ Improved troubleshooting section for kernel visibility issues

### October 30, 2025

- ✅ Added persistent volumes for `envs/` and `pkgs/` (gitignored)
- ✅ Updated strategy: Use `conda --copy` instead of `mamba` to avoid symlink issues
- ✅ Environments now persist across container restarts
- ✅ Notebooks continue persisting in `d:/dockerVolumes/`
- ✅ Updated complete documentation to English
- ✅ Created IA and LLM preconfigured environments
- ✅ Unified documentation in COMPLETE_GUIDE.md

---

## 🔗 Useful Links

- **Local JupyterLab:** http://192.168.80.200:8888
- **Complete Guide (English):** [COMPLETE_GUIDE.md](COMPLETE_GUIDE.md)
- **GPU Testing Guide:** [TEST_GPU.md](TEST_GPU.md) ✨ **NEW**
- **Conda Documentation:** https://docs.conda.io
- **PyTorch Documentation:** https://pytorch.org/docs/
- **CUDA Toolkit:** https://developer.nvidia.com/cuda-toolkit
- **Conda-Forge:** https://conda-forge.org

---

## 📄 License

This project is for internal development use. Individual components (Conda, Mamba, JupyterLab, PyTorch) maintain their respective licenses.

---

**Created with ❤️ for efficient AI/ML development**  
**Last updated:** November 20, 2025  
**GPU-Accelerated Development Environment**

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
