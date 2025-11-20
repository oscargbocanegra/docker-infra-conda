# 📘 Complete Guide: Virtual Environments with Conda + Docker + GPU

> **Last Updated:** November 20, 2025  
> **Configuration:** Persistent environments + GPU Support (NVIDIA RTX 2080 Ti)

---

## 📋 Table of Contents

1. [Fundamental Concepts](#fundamental-concepts)
2. [GPU Configuration](#gpu-configuration)
3. [Quick Commands](#quick-commands)
4. [Step-by-Step Guide](#step-by-step-guide)
5. [Docker Management](#docker-management)
6. [Practical Examples](#practical-examples)
7. [Troubleshooting](#troubleshooting)

---

## 🎯 Fundamental Concepts

### What is a Virtual Environment?

It's an **isolated directory** that contains:
- ✅ A specific version of Python
- ✅ Installed libraries and packages
- ✅ Project dependencies

**Benefits:**
- Dependency isolation
- No conflicts between projects
- Easy replication

### What is an IPyKernel?

It's the **bridge** that connects your virtual environment with JupyterLab:

```
Virtual Environment (IA)   →   IPyKernel (ia)     →     JupyterLab
    ↓                              ↓                        ↓
[Python 3.11]              [Registered kernel]      [Select kernel]
[pandas 2.3]       ←────→  [/opt/conda/envs/IA] ←────→  [Execute code]
[numpy 2.3]                [Visible in Jupyter]      [In your notebook]
```

**Without the registered kernel, JupyterLab CANNOT see your environment.**

### Available Tools

| Tool | Speed | Recommended Use |
|-------------|-----------|-----------------|
| **Conda with --copy** | 🐢 Slow but reliable | **ALL packages** (avoids Windows symlink issues) |
| **Mamba** | ⚡ Ultra fast | Only on Linux/Mac (has symlink issues on Windows) |
| **Pip** | ⚡ Fast | Pure PyPI packages (transformers, etc.) |

**⚠️ IMPORTANT:** On Windows with Docker volumes, always use `conda --copy` instead of `mamba`.

### GPU Support

This environment includes **NVIDIA GPU acceleration**:

- **GPU:** NVIDIA GeForce RTX 2080 Ti (11GB VRAM)
- **CUDA:** 13.0
- **PyTorch:** 2.5.1+cu121 (pre-installed in base environment)
- **Driver:** 581.80 (Windows)

All environments (base, IA, LLM) have access to GPU for accelerated computing.

---

## 🎮 GPU Configuration

### Verify GPU Access

```bash
# Quick GPU check
docker exec -it conda-jupyter nvidia-smi

# PyTorch CUDA test
docker exec -it conda-jupyter python -c "import torch; print('CUDA available:', torch.cuda.is_available()); print('GPU:', torch.cuda.get_device_name(0) if torch.cuda.is_available() else 'N/A')"
```

### Expected Output

```
CUDA available: True
GPU: NVIDIA GeForce RTX 2080 Ti
```

### GPU in Notebooks

Use GPU in your Jupyter notebooks:

```python
import torch

# Check GPU availability
print(f"CUDA available: {torch.cuda.is_available()}")
print(f"GPU name: {torch.cuda.get_device_name(0)}")

# Move tensors to GPU
x = torch.randn(1000, 1000).cuda()
y = torch.randn(1000, 1000).cuda()
z = torch.matmul(x, y)  # Computed on GPU
```

See **[TEST_GPU.md](TEST_GPU.md)** for comprehensive testing examples.

---

## 🚀 Quick Commands

### Create Complete Environment (ALL-IN-ONE)

```bash
docker exec -it conda-jupyter bash -c "
source /opt/conda/etc/profile.d/conda.sh && \
conda create -n MY_ENV python=3.11 --copy -y && \
conda activate MY_ENV && \
conda install numpy pandas matplotlib seaborn scikit-learn jupyter ipykernel --copy -y && \
python -m ipykernel install --user --name MY_ENV --display-name 'Python (MY NAME)' && \
jupyter kernelspec list
"
```

**⚠️ Replace:**
- `MY_ENV` → Technical environment name (e.g., `sentiment`, `ia`, `web`)
- `MY NAME` → Display name in JupyterLab (e.g., `Sentiment Analysis`, `IA`, `Web`)

**After:** Refresh JupyterLab (F5) to see the new kernel

---

### Query Environments and Kernels

```bash
# View installed environments
docker exec -it conda-jupyter bash -c "source /opt/conda/etc/profile.d/conda.sh && conda env list"

# View Jupyter kernels
docker exec -it conda-jupyter bash -c "jupyter kernelspec list"

# View packages in an environment
docker exec -it conda-jupyter bash -c "source /opt/conda/etc/profile.d/conda.sh && conda activate MY_ENV && conda list"
```

---

### Delete Environments and Kernels

```bash
# Delete kernel
docker exec -it conda-jupyter bash -c "jupyter kernelspec uninstall MY_ENV -f"

# Delete environment
docker exec -it conda-jupyter bash -c "source /opt/conda/etc/profile.d/conda.sh && conda env remove -n MY_ENV -y"

# Delete both (complete cleanup)
docker exec -it conda-jupyter bash -c "
source /opt/conda/etc/profile.d/conda.sh && \
jupyter kernelspec uninstall MY_ENV -f && \
conda env remove -n MY_ENV -y
"
```

---

## 📖 Step-by-Step Guide

### 1️⃣ Create the Environment

```bash
docker exec -it conda-jupyter bash -c "
source /opt/conda/etc/profile.d/conda.sh && \
conda create -n MY_ENV python=3.11 --copy -y
"
```

**What it does:**
- Creates a new isolated directory in `/opt/conda/envs/MY_ENV`
- Installs Python 3.11
- Uses `--copy` flag to physically copy files (avoids symlinks)

**Time:** ~2-3 minutes (slower than mamba but reliable)

---

### 2️⃣ Activate the Environment

```bash
docker exec -it conda-jupyter bash -c "
source /opt/conda/etc/profile.d/conda.sh && \
conda activate MY_ENV
"
```

**What it does:**
- Switches the active Python to your environment's version
- Modifies PATH to use packages from this environment

---

### 3️⃣ Install Packages

```bash
docker exec -it conda-jupyter bash -c "
source /opt/conda/etc/profile.d/conda.sh && \
conda activate MY_ENV && \
conda install numpy pandas matplotlib jupyter ipykernel --copy -y
"
```

**Available options:**
- **Conda packages (with --copy):** Most scientific libraries
- **Pip packages:** If not available in conda-forge

**Example with pip:**
```bash
docker exec -it conda-jupyter bash -c "
source /opt/conda/etc/profile.d/conda.sh && \
conda activate MY_ENV && \
pip install transformers torch
"
```

---

### 4️⃣ Register the Kernel in JupyterLab

```bash
docker exec -it conda-jupyter bash -c "
source /opt/conda/etc/profile.d/conda.sh && \
conda activate MY_ENV && \
python -m ipykernel install --user --name MY_ENV --display-name 'Python (MY NAME)'
"
```

**What it does:**
- Creates a kernel spec in `/root/.local/share/jupyter/kernels/MY_ENV/`
- Makes the environment visible in JupyterLab
- Displays as "Python (MY NAME)" in the kernel selector

---

### 5️⃣ Verify Installation

```bash
docker exec -it conda-jupyter bash -c "jupyter kernelspec list"
```

**Expected output:**
```
Available kernels:
  my_env     /root/.local/share/jupyter/kernels/my_env
  python3    /opt/conda/share/jupyter/kernels/python3
```

---

### 6️⃣ Use in JupyterLab

1. Open JupyterLab: http://192.168.80.200:8888
2. Create a new notebook
3. Select kernel: **"Python (MY NAME)"**
4. Start coding!

**If you don't see the kernel:**
- Refresh the page (F5)
- Check that step 4 completed successfully
- Run `jupyter kernelspec list` to verify

---

## 🐳 Docker Management

### Basic Commands

```powershell
# Start container
cd d:\dockerInfraProjects\conda
docker-compose up -d

# Stop container
docker-compose down

# Restart container
docker-compose restart

# View logs
docker logs conda-jupyter --tail 50 --follow

# Access interactive shell
docker exec -it conda-jupyter bash
```

---

### Check Container Status

```powershell
# Check if running
docker ps --filter name=conda-jupyter

# Check all (including stopped)
docker ps -a --filter name=conda-jupyter

# View resource usage
docker stats conda-jupyter --no-stream
```

---

### Rebuild Image (Advanced)

```powershell
cd d:\dockerInfraProjects\conda
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

**⚠️ Note:** Environments in `./envs/` persist, but kernels in `/root/.local/` will be lost.

**To re-register kernels after rebuild:**
```bash
docker exec -it conda-jupyter bash -c "/opt/conda/envs/ENV_NAME/bin/python -m pip install ipykernel && /opt/conda/envs/ENV_NAME/bin/python -m ipykernel install --user --name ENV_NAME --display-name 'Python (DISPLAY_NAME)'"
```

---

## 💡 Practical Examples

### Example 1: Machine Learning Environment

```bash
docker exec -it conda-jupyter bash -c "
source /opt/conda/etc/profile.d/conda.sh && \
conda create -n IA python=3.11 --copy -y && \
conda activate IA && \
conda install numpy pandas matplotlib seaborn scikit-learn scipy statsmodels jupyter ipykernel --copy -y && \
python -m ipykernel install --user --name IA --display-name 'Python (IA)' && \
jupyter kernelspec list
"
```

**Packages included:**
- `numpy` → Numerical arrays
- `pandas` → DataFrames
- `matplotlib` + `seaborn` → Visualizations
- `scikit-learn` → Machine learning algorithms
- `scipy` → Scientific computing
- `statsmodels` → Statistical models

**Use case:** Data analysis, regression models, classification, clustering

---

### Example 2: Deep Learning / LLM Environment with GPU

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

**Packages included:**
- `transformers` → Hugging Face models (BERT, GPT, etc.)
- `torch` → PyTorch with CUDA 12.1 support (GPU-accelerated)
- `torchvision` → Vision utilities with GPU support

**Use case:** Natural Language Processing, sentiment analysis, text generation, fine-tuning LLMs

**GPU Benefits:**
- ✅ 10-50x faster inference
- ✅ Larger batch sizes
- ✅ Fine-tuning large models
- ✅ Real-time processing

**Note:** Models downloaded with `transformers` are cached in `d:/dockerVolumes/hf_cache` and persist across container restarts.

---

### Example 3: Web Scraping Environment

```bash
docker exec -it conda-jupyter bash -c "
source /opt/conda/etc/profile.d/conda.sh && \
conda create -n WEB python=3.11 --copy -y && \
conda activate WEB && \
conda install jupyter ipykernel --copy -y && \
pip install requests beautifulsoup4 selenium pandas && \
python -m ipykernel install --user --name WEB --display-name 'Python (Web Scraping)' && \
jupyter kernelspec list
"
```

**Packages included:**
- `requests` → HTTP requests
- `beautifulsoup4` → HTML parsing
- `selenium` → Browser automation
- `pandas` → Data storage

**Use case:** Web scraping, data extraction, automated browsing

---

## 🚨 Troubleshooting

### Problem: Symlink error when creating environment

**Error message:**
```
critical libmamba filesystem error: cannot copy symlink: Invalid argument
```

**Cause:** Windows filesystem (DRVFS) in Docker doesn't support symlinks

**Solution:** Always use `conda --copy` flag:
```bash
conda create -n ENV --copy -y
conda install PACKAGES --copy -y
```

---

### Problem: Environment exists but kernel doesn't appear in JupyterLab

**Symptom:** You can see the environment with `conda env list` but not in JupyterLab's kernel selector.

**Possible causes:**

1. **Kernel not registered** (most common after container rebuild)
   ```bash
   # Register kernel using environment's Python directly
   docker exec -it conda-jupyter bash -c "/opt/conda/envs/MY_ENV/bin/python -m pip install ipykernel && /opt/conda/envs/MY_ENV/bin/python -m ipykernel install --user --name MY_ENV --display-name 'Python (MY NAME)'"
   ```

2. **JupyterLab cache**
   - Refresh page (F5)
   - Clear browser cache (Ctrl+Shift+Del)

3. **Verify kernel exists**
   ```bash
   docker exec -it conda-jupyter bash -c "jupyter kernelspec list"
   ```

**Example for IA and LLM environments:**
```bash
# Register IA kernel
docker exec -it conda-jupyter bash -c "/opt/conda/envs/IA/bin/python -m pip install ipykernel && /opt/conda/envs/IA/bin/python -m ipykernel install --user --name IA --display-name 'Python (IA)'"

# Register LLM kernel
docker exec -it conda-jupyter bash -c "/opt/conda/envs/LLM/bin/python -m pip install ipykernel && /opt/conda/envs/LLM/bin/python -m ipykernel install --user --name LLM --display-name 'Python (LLM)'"
```

---

### Problem: Environment creation is very slow

**Cause:** Using `conda --copy` physically copies all files (slower than symlinks)

**Solutions:**

1. **Accept the wait** (~3-5 minutes is normal)
2. **Reduce packages** (install only what you need)
3. **Use package cache** (second installs are faster)

**Why not use mamba?**
- Mamba is 10x faster BUT creates symlinks
- Symlinks fail on Windows Docker volumes
- `conda --copy` is slower but reliable

---

### Problem: "No space left on device"

**Causes:**
- Package cache full (`/opt/conda/pkgs/`)
- Disk D:\ full

**Solutions:**

```bash
# Clean package cache
docker exec -it conda-jupyter bash -c "conda clean --all -y"

# Check disk space on host
Get-PSDrive D
```

---

### Problem: Environment disappeared after restart

**This should NOT happen** with current configuration (persistent volumes).

**Verify:**
```bash
docker exec -it conda-jupyter bash -c "conda env list"
```

**If missing:**
1. Check volume mounts in `docker-compose.yml`
2. Verify `./envs/` folder exists on host
3. Recreate environment using documented commands

---

### Problem: HuggingFace models re-downloading every time

**Symptom:** Transformers models download on every container restart.

**Cause:** HuggingFace cache not persisted.

**Solution:** Ensure HuggingFace cache volume is mounted in `docker-compose.yml`:
```yaml
volumes:
  - d:/dockerVolumes/hf_cache:/root/.cache/huggingface
```

This volume is already configured in the current setup. Models are cached in `d:/dockerVolumes/hf_cache` and persist across container restarts.

---

## 📊 Environment Comparison

| Environment | Python | GPU | Time to Create | Main Packages | Use Case |
|-------------|--------|-----|----------------|---------------|----------|
| **base** | 3.11 | ✅ | Included | PyTorch+CUDA | General purpose with GPU |
| **IA** | 3.11 | ✅ | ~5 min | numpy, pandas, scikit-learn | Machine Learning |
| **LLM** | 3.11 | ✅ | ~6 min | transformers, torch+CUDA | NLP, LLMs with GPU |
| **WEB** | 3.11 | ✅ | ~2 min | requests, beautifulsoup4 | Web Scraping |

---

## 🎯 Best Practices

### ✅ DO:
- Always use `--copy` flag on Windows
- Document your environments (save package lists)
- Use descriptive kernel names
- Refresh JupyterLab after creating kernels
- Keep notebooks in `/workspace` (persistent)
- Test GPU availability after creating new environments
- Use `torch.cuda.empty_cache()` to free GPU memory between runs

### ❌ DON'T:
- Use `mamba` on Windows volumes (symlink issues)
- Create environments without registering kernels
- Store important data inside containers (use volumes)
- Delete environments without checking dependencies
- Forget to re-register kernels after container rebuild

---

## 🔄 Backup and Restore

### Export Environment

```bash
docker exec -it conda-jupyter bash -c "
source /opt/conda/etc/profile.d/conda.sh && \
conda activate MY_ENV && \
conda env export > /workspace/MY_ENV_backup.yml
"
```

**File saved to:** `d:/dockerVolumes/conda/notebooks/MY_ENV_backup.yml`

---

### Restore Environment

```bash
docker exec -it conda-jupyter bash -c "
source /opt/conda/etc/profile.d/conda.sh && \
conda env create -f /workspace/MY_ENV_backup.yml --copy && \
conda activate MY_ENV && \
python -m ipykernel install --user --name MY_ENV --display-name 'Python (MY NAME)'
"
```

---

## 📚 Additional Resources

- **GPU Testing Guide:** [TEST_GPU.md](TEST_GPU.md) - Comprehensive GPU verification
- **Conda Cheat Sheet:** https://docs.conda.io/projects/conda/en/latest/user-guide/cheatsheet.html
- **Jupyter Kernels:** https://jupyter-client.readthedocs.io/en/stable/kernels.html
- **PyTorch Documentation:** https://pytorch.org/docs/
- **CUDA Toolkit:** https://developer.nvidia.com/cuda-toolkit
- **Docker Compose:** https://docs.docker.com/compose/
- **Conda-Forge:** https://conda-forge.org/

---

**Last updated:** November 20, 2025  
**Version:** 3.0.0 (GPU Support)

---

**Created with ❤️ for efficient data science workflows**  
**Last updated:** October 30, 2025
