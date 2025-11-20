# 🎯 Pruebas de GPU en JupyterLab

## ✅ GPU Configurada Exitosamente

**Fecha:** 20 de noviembre de 2025  
**GPU:** NVIDIA GeForce RTX 2080 Ti (11GB VRAM)  
**Driver:** 581.80  
**CUDA:** 13.0  
**PyTorch:** 2.5.1+cu121

---

## 🧪 Código de Prueba para JupyterLab

### 1. Verificar GPU con PyTorch

```python
import torch

print("=" * 60)
print("VERIFICACIÓN DE GPU")
print("=" * 60)

# Información básica
print(f"\nPyTorch Version: {torch.__version__}")
print(f"CUDA Available: {torch.cuda.is_available()}")
print(f"CUDA Version: {torch.version.cuda}")

if torch.cuda.is_available():
    print(f"\nGPU Count: {torch.cuda.device_count()}")
    print(f"Current GPU: {torch.cuda.current_device()}")
    print(f"GPU Name: {torch.cuda.get_device_name(0)}")
    
    # Memoria
    print(f"\nMemoria GPU:")
    print(f"  Total: {torch.cuda.get_device_properties(0).total_memory / 1024**3:.2f} GB")
    print(f"  Asignada: {torch.cuda.memory_allocated(0) / 1024**3:.2f} GB")
    print(f"  Cacheada: {torch.cuda.memory_reserved(0) / 1024**3:.2f} GB")
else:
    print("\n❌ GPU no disponible")
```

### 2. Prueba de Cálculo en GPU

```python
import torch
import time

# Crear tensores grandes
size = 10000
a = torch.randn(size, size)
b = torch.randn(size, size)

# CPU
print("\n🖥️  CPU Test:")
start = time.time()
c_cpu = torch.matmul(a, b)
cpu_time = time.time() - start
print(f"Tiempo: {cpu_time:.4f} segundos")

# GPU
if torch.cuda.is_available():
    print("\n🚀 GPU Test:")
    a_gpu = a.cuda()
    b_gpu = b.cuda()
    
    # Warm-up
    _ = torch.matmul(a_gpu, b_gpu)
    torch.cuda.synchronize()
    
    # Test real
    start = time.time()
    c_gpu = torch.matmul(a_gpu, b_gpu)
    torch.cuda.synchronize()
    gpu_time = time.time() - start
    
    print(f"Tiempo: {gpu_time:.4f} segundos")
    print(f"\n⚡ Speedup: {cpu_time/gpu_time:.2f}x más rápido")
```

### 3. Verificar nvidia-smi desde Notebook

```python
!nvidia-smi
```

### 4. Prueba de Modelo Simple (CNN)

```python
import torch
import torch.nn as nn

class SimpleCNN(nn.Module):
    def __init__(self):
        super(SimpleCNN, self).__init__()
        self.conv1 = nn.Conv2d(3, 64, 3, padding=1)
        self.conv2 = nn.Conv2d(64, 128, 3, padding=1)
        self.fc = nn.Linear(128 * 8 * 8, 10)
        self.pool = nn.MaxPool2d(2, 2)
        self.relu = nn.ReLU()
    
    def forward(self, x):
        x = self.pool(self.relu(self.conv1(x)))
        x = self.pool(self.relu(self.conv2(x)))
        x = x.view(-1, 128 * 8 * 8)
        x = self.fc(x)
        return x

# Crear modelo
model = SimpleCNN()

# Mover a GPU
if torch.cuda.is_available():
    model = model.cuda()
    print("✅ Modelo en GPU")
    
    # Datos de prueba
    x = torch.randn(32, 3, 32, 32).cuda()
    output = model(x)
    print(f"Output shape: {output.shape}")
else:
    print("❌ GPU no disponible")
```

---

## 📊 Resultados Esperados

- **Speedup típico:** 10-50x más rápido que CPU (depende del tamaño del problema)
- **Memoria GPU disponible:** ~11 GB
- **Uso recomendado:** Batch sizes de 32-128 para CNNs, 8-32 para modelos grandes

---

## 🚀 Frameworks con GPU

Ya puedes instalar y usar:

```bash
# En una celda de notebook con '!'
!pip install tensorflow-gpu
!pip install jax[cuda12]
!pip install transformers accelerate
```

---

## 📝 Notas

- PyTorch ya está instalado con soporte CUDA 12.1
- La GPU se comparte entre todos los notebooks abiertos
- Usa `torch.cuda.empty_cache()` para liberar memoria entre ejecuciones
- El contenedor reinicia automáticamente con el sistema
