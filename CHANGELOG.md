# 📝 Changelog - Conda Docker Environment

All notable changes to this project will be documented in this file.

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

## [1.0.0] - 2025-10-28

### Initial Release

- ✅ Docker-based Conda environment
- ✅ JupyterLab 4.4.10
- ✅ Miniconda + Mamba
- ✅ Network access (192.168.80.200:8888)
- ✅ Persistent notebooks in `d:/dockerVolumes/`
- ✅ Spanish documentation (GUIA_COMPLETA.md)

---

**Maintained by:** oscargiovanni  
**Last updated:** October 30, 2025
