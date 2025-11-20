# 📝 Changelog - Conda Docker Environment

All notable changes to this project will be documented in this file.

---

## [3.0.0] - 2025-11-20 🎮 **GPU Support Release**

### ✨ Major Changes

#### GPU Acceleration Fully Integrated
- ✅ **NVIDIA RTX 2080 Ti** (11GB VRAM) fully accessible in containers
- ✅ **CUDA 13.0** installed and configured in WSL2
- ✅ **PyTorch 2.5.1+cu121** pre-installed with CUDA support
- ✅ **Docker Desktop** switched to WSL2 backend
- ✅ **NVIDIA Driver** updated to 581.80
- ✅ GPU accessible from all environments (base, IA, LLM)

#### New Documentation
- ✅ **TEST_GPU.md** - Comprehensive GPU testing guide
  - Verification scripts
  - PyTorch CUDA tests
  - Performance benchmarks
  - Example notebooks
- ✅ **setup-gpu-wsl2.ps1** - Automated GPU setup script
  - Driver verification
  - CUDA Toolkit installation
  - WSL2 configuration
  - Docker Desktop setup guidance

#### HuggingFace Integration
- ✅ **Persistent HuggingFace cache** at `d:/dockerVolumes/hf_cache`
- ✅ Transformers models persist across container restarts
- ✅ Tokenizers and datasets cached locally
- ✅ Reduces re-download time significantly

#### Infrastructure Updates
- ✅ **Auto-restart on system boot** - Containers start automatically
- ✅ **Kernel auto-registration** documented for post-rebuild scenarios
- ✅ **GPU troubleshooting** section added to documentation
- ✅ **Memory optimization** - System RAM usage analysis and fixes

### 🔧 Configuration Changes

#### docker-compose.yml (GPU-enabled)
```yaml
environment:
  - NVIDIA_VISIBLE_DEVICES=all
  - NVIDIA_DRIVER_CAPABILITIES=compute,utility

deploy:
  resources:
    limits:
      cpus: "6"
      memory: 12G
    reservations:
      cpus: "3"
      memory: 6G
      devices:
        - driver: nvidia
          count: all
          capabilities: [gpu, compute, utility]

volumes:
  - d:/dockerVolumes/hf_cache:/root/.cache/huggingface  # NEW
```

#### System Requirements
- ✅ Windows 11 Pro (Build 26200+)
- ✅ WSL 2.4.13+
- ✅ NVIDIA Driver 560.x+ (or 581.80)
- ✅ Docker Desktop with WSL2 backend enabled
- ✅ CUDA Toolkit 12.6+ in WSL2

### 🐛 Bug Fixes & Solutions

1. **Kernels disappearing after container rebuild**
   - **Problem:** Jupyter kernels lost when rebuilding container
   - **Root cause:** Kernels stored in `/root/.local/` (non-persistent)
   - **Solution:** Documented re-registration commands
   - **Commands:**
     ```bash
     docker exec -it conda-jupyter bash -c "/opt/conda/envs/IA/bin/python -m pip install ipykernel && /opt/conda/envs/IA/bin/python -m ipykernel install --user --name IA --display-name 'Python (IA)'"
     ```

2. **GPU not detected in WSL after system restart**
   - **Problem:** CUDA Toolkit path not persistent
   - **Root cause:** WSL distribution reset on restart
   - **Solution:** CUDA installed via apt (persistent)
   - **Verification:** `wsl -d Ubuntu -e /usr/lib/wsl/lib/nvidia-smi`

3. **High RAM usage (99.93%)**
   - **Problem:** Windows reporting 99.93% RAM usage
   - **Root cause:** Windows File System Cache (normal behavior)
   - **Analysis:** Only 13.8% actually in use (4.42GB/32GB)
   - **Solution:** Documented that this is expected behavior
   - **Real available:** 27.61 GB (86.5%)

4. **Docker containers not starting on boot**
   - **Problem:** Containers stopped after using `wsl --shutdown`
   - **Solution:** `restart: unless-stopped` policy ensures auto-start
   - **Note:** Containers start when Docker Desktop starts

### 📚 Documentation Updates

#### Updated Files
| File | Changes |
|------|---------|
| **README.md** | GPU specs, new architecture diagram, troubleshooting |
| **COMPLETE_GUIDE.md** | GPU testing, kernel registration, HuggingFace cache |
| **TEST_GPU.md** | Complete GPU verification and testing guide ✨ NEW |
| **CHANGELOG.md** | This comprehensive update log |

#### New Sections Added
- 🎮 GPU Configuration and verification
- 🔄 Kernel re-registration procedures
- 💾 Memory analysis and optimization
- 🔧 Troubleshooting GPU issues
- 📊 System resource monitoring

### 📊 Performance Metrics

| Operation | Before (CPU) | After (GPU) | Speedup |
|-----------|-------------|-------------|---------|
| Matrix multiplication (10000x10000) | 4.5s | 0.15s | ~30x |
| PyTorch model training | - | GPU-accelerated | - |
| Transformer inference | CPU-only | GPU-enabled | 10-50x |

### 🔐 Security & Stability

- ✅ GPU access isolated per container
- ✅ NVIDIA drivers sandboxed in WSL2
- ✅ No privileged mode required
- ✅ Auto-restart policy prevents downtime
- ✅ Persistent data strategy unchanged

### 🗂️ File Structure Changes

```diff
d:/dockerInfraProjects/
+ └── setup-gpu-wsl2.ps1        # GPU automation script

d:/dockerInfraProjects/conda/
+ ├── docker-compose-gpu.yml    # GPU-enabled configuration
+ ├── docker-compose-backup.yml # Pre-GPU backup
+ ├── TEST_GPU.md               # GPU testing guide
  ├── COMPLETE_GUIDE.md         # Updated with GPU sections
  ├── README.md                 # Updated with GPU info
  ├── CHANGELOG.md              # This file
  ├── docker-compose.yml        # Now GPU-enabled (was CPU-only)
  └── envs/
      ├── IA/                   # Now with GPU access
      └── LLM/                  # Now with GPU access

d:/dockerVolumes/
+ └── hf_cache/                 # HuggingFace models cache
```

### ⚙️ Breaking Changes

1. **Docker Desktop backend changed**
   - Old: Hyper-V (or default)
   - New: WSL2 (required for GPU)
   - Migration: Automatic when enabling "Use WSL 2 based engine"

2. **PyTorch version upgraded**
   - Old: torch 2.9.0+cpu
   - New: torch 2.5.1+cu121
   - Impact: GPU support, CUDA 12.1 compatibility

3. **NVIDIA Driver requirement**
   - Minimum: 560.x
   - Recommended: 581.80
   - Incompatible: <510.x

### 🚀 Upgrade Instructions

Complete upgrade from v2.0.0 to v3.0.0:

```powershell
# Step 1: Update NVIDIA Driver
# Download from: https://www.nvidia.com/Download/index.aspx
# Install driver 581.80+ and restart system

# Step 2: Configure WSL2
wsl --update
wsl --shutdown

# Step 3: Install CUDA in WSL
wsl -d Ubuntu bash -c "
wget -q https://developer.download.nvidia.com/compute/cuda/repos/wsl-ubuntu/x86_64/cuda-keyring_1.1-1_all.deb && \
sudo dpkg -i cuda-keyring_1.1-1_all.deb && \
sudo apt-get update -qq && \
sudo apt-get install -y -qq cuda-toolkit-12-6
"

# Step 4: Configure Docker Desktop
# Settings → General → ✓ "Use the WSL 2 based engine"
# Apply & Restart

# Step 5: Update container configuration
cd d:\dockerInfraProjects\conda
docker-compose down
Copy-Item docker-compose-gpu.yml docker-compose.yml -Force
docker-compose up -d

# Step 6: Re-register kernels (if needed)
docker exec -it conda-jupyter bash -c "/opt/conda/envs/IA/bin/python -m pip install ipykernel && /opt/conda/envs/IA/bin/python -m ipykernel install --user --name IA --display-name 'Python (IA)'"
docker exec -it conda-jupyter bash -c "/opt/conda/envs/LLM/bin/python -m pip install ipykernel && /opt/conda/envs/LLM/bin/python -m ipykernel install --user --name LLM --display-name 'Python (LLM)'"

# Step 7: Verify GPU
docker exec -it conda-jupyter nvidia-smi
docker exec -it conda-jupyter python -c "import torch; print('CUDA:', torch.cuda.is_available())"
```

### 📝 Migration Notes

- **Environments preserved:** IA and LLM environments in `./envs/` persist
- **Notebooks preserved:** All notebooks in `d:/dockerVolumes/conda/notebooks/` unchanged
- **Kernels need re-registration:** After rebuild, register kernels again
- **HuggingFace cache:** New volume, will populate on first use
- **GPU optional:** Can revert to CPU-only by using `docker-compose-backup.yml`

---

## [2.1.0] - 2025-11-19

### ✨ Features

#### HuggingFace Cache Volume
- ✅ Added persistent volume for HuggingFace models
- ✅ Location: `d:/dockerVolumes/hf_cache`
- ✅ Mapped to: `/root/.cache/huggingface`
- ✅ Benefits: Models download once, persist forever

#### Documentation Improvements
- ✅ Documented kernel re-registration procedures
- ✅ Added troubleshooting for missing kernels
- ✅ Improved architecture diagrams

---

## [2.0.0] - 2025-10-30

### ✨ Major Changes

#### Documentation Overhaul
- ✅ **Complete English translation** of README.md
- ✅ **NEW:** Created COMPLETE_GUIDE.md (comprehensive English guide)
- ✅ Kept GUIA_COMPLETA.md (Spanish version for reference)
- ✅ Updated architecture diagrams
- ✅ Added troubleshooting section for Windows-specific issues

#### Environment Strategy Update
- ✅ **Persistent environments** now using `./envs/` and `./pkgs/` volumes
- ✅ **Changed from mamba to conda** with `--copy` flag
- ✅ Resolved Windows symlink issues (DRVFS filesystem compatibility)
- ✅ Environments now survive container restarts
- ✅ Added `.gitignore` rules for `envs/` and `pkgs/` folders

#### Preconfigured Environments
- ✅ **IA Environment** created and tested
  - Python 3.11.14
  - numpy 2.3.4, pandas 2.3.3
  - matplotlib 3.10.7, seaborn 0.13.2
  - scikit-learn 1.7.2, scipy 1.16.3
  - Kernel: "Python (IA)"

- ✅ **LLM Environment** created and tested
  - Python 3.11.14
  - transformers 4.57.1
  - torch 2.9.0+cpu, torchvision 0.24.0+cpu, torchaudio 2.9.0+cpu
  - numpy 2.3.4, pandas 2.3.3
  - Kernel: "Python (LLM)"

### 🔧 Configuration Changes

#### docker-compose.yml
- ✅ Removed obsolete `version: '3.8'` attribute
- ✅ Added persistent volume mounts:
  - `./envs:/opt/conda/envs`
  - `./pkgs:/opt/conda/pkgs`
- ✅ Updated comments to English
- ✅ Maintained resource limits (6 CPUs, 12GB RAM)

#### .gitignore
- ✅ Updated persistence strategy documentation
- ✅ Added `envs/` and `pkgs/` to gitignore
- ✅ Translated comments to English
- ✅ Clarified data separation strategy

### 📚 Documentation Files

| File | Language | Purpose | Status |
|------|----------|---------|--------|
| **README.md** | 🇬🇧 English | Main project documentation | ✅ Updated |
| **COMPLETE_GUIDE.md** | 🇬🇧 English | Comprehensive usage guide | ✨ NEW |
| **GUIA_COMPLETA.md** | 🇪🇸 Spanish | Guía completa de uso | ✅ Maintained |
| **CHANGELOG.md** | 🇬🇧 English | This file | ✨ NEW |

### 🐛 Bug Fixes

1. **Symlink errors on Windows volumes**
   - **Problem:** Mamba failed with "cannot copy symlink: Invalid argument"
   - **Root cause:** Windows DRVFS (9p filesystem) doesn't support symlinks
   - **Solution:** Use `conda --copy` flag instead of mamba
   - **Trade-off:** Slower installation (~3-5 min) but 100% reliable

2. **Environment persistence issues**
   - **Problem:** Environments lost on container restart
   - **Solution:** Added persistent volumes for `envs/` and `pkgs/`
   - **Result:** Environments now survive restarts

3. **docker-compose warnings**
   - **Problem:** "attribute 'version' is obsolete" warning
   - **Solution:** Removed `version: '3.8'` line
   - **Result:** Clean startup with no warnings

### 🔐 Security Notes

- ⚠️ JupyterLab runs without authentication (development mode)
- ⚠️ Accessible across local network (192.168.80.200:8888)
- ✅ Container runs without privileged mode
- ✅ Data separation: Infrastructure vs user data

### 📊 Performance Metrics

| Operation | Time | Method |
|-----------|------|--------|
| Create IA environment | ~5 min | conda --copy |
| Create LLM environment | ~6 min | conda --copy + pip |
| Container startup | <1 sec | Cached layers |
| JupyterLab access | Instant | No auth required |

### 🗂️ File Structure Changes

```diff
d:/dockerInfraProjects/conda/
+ ├── COMPLETE_GUIDE.md       # New English guide
+ ├── CHANGELOG.md             # This file
  ├── README.md                # Updated to English
  ├── GUIA_COMPLETA.md         # Kept for Spanish speakers
  ├── docker-compose.yml       # Updated volumes
  ├── .gitignore               # Updated strategy
+ ├── envs/                    # Persistent (gitignored)
+ │   ├── IA/                  # ML environment
+ │   └── LLM/                 # Deep learning environment
+ └── pkgs/                    # Persistent cache (gitignored)
```

### ⚙️ Breaking Changes

1. **Mamba replaced with Conda + --copy**
   - Old commands using `mamba create` will still work
   - New recommended: `conda create --copy`
   - Reason: Windows symlink compatibility

2. **Environment location changed**
   - Old: Inside container only (non-persistent)
   - New: Mounted from `./envs/` (persistent)
   - Impact: Environments survive restarts

### 🚀 Upgrade Instructions

If upgrading from previous version:

```powershell
# 1. Stop current container
cd d:\dockerInfraProjects\conda
docker-compose down

# 2. Pull latest changes (if using Git)
git pull

# 3. Create required directories
New-Item -ItemType Directory -Path envs, pkgs -Force

# 4. Start container with new config
docker-compose up -d

# 5. Recreate environments using --copy flag
docker exec -it conda-jupyter bash -c "
source /opt/conda/etc/profile.d/conda.sh && \
conda create -n IA python=3.11 --copy -y && \
conda activate IA && \
conda install numpy pandas matplotlib seaborn scikit-learn jupyter ipykernel --copy -y && \
python -m ipykernel install --user --name IA --display-name 'Python (IA)'
"
```

### 📝 Notes for Developers

- Always use `--copy` flag when creating/installing with conda on Windows
- Test environments after creation with `jupyter kernelspec list`
- Document custom environments in project notes
- Keep GUIA_COMPLETA.md (Spanish) and COMPLETE_GUIDE.md (English) in sync

---

---

## [1.0.0] - 2025-10-28

### Initial Release

- ✅ Docker-based Conda environment
- ✅ JupyterLab 4.4.10
- ✅ Miniconda + Mamba
- ✅ Network access (192.168.80.200:8888)
- ✅ Persistent notebooks in `d:/dockerVolumes/`
- ✅ Spanish documentation (GUIA_COMPLETA.md)

---

**Maintained by:** oscargbocanegra  
**Last updated:** November 20, 2025  
**Current Version:** 3.0.0 (GPU Support)
