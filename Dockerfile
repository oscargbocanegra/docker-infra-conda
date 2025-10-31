# =====================================================
# Dockerfile: Miniconda + Mamba + JupyterLab
# Optimizado para desarrollo con conda-forge
# =====================================================

FROM continuumio/miniconda3:latest

LABEL maintainer="Docker Conda Setup"
LABEL description="Miniconda con Mamba y JupyterLab optimizado"

# Variables de entorno
ENV CONDA_DIR=/opt/conda \
    SHELL=/bin/bash \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

# Actualizar sistema base y agregar dependencias
RUN apt-get update --fix-missing && \
    apt-get install -y --no-install-recommends \
    git \
    wget \
    curl \
    vim \
    build-essential \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Instalar uv (gestor de paquetes Python ultra-rapido)
RUN curl -LsSf https://astral.sh/uv/install.sh | sh && \
    echo 'export PATH="/root/.cargo/bin:$PATH"' >> /root/.bashrc

# Configurar conda para usar conda-forge como canal principal
RUN conda config --add channels conda-forge && \
    conda config --set channel_priority strict

# Instalar mamba (gestor de paquetes rapido)
RUN conda install -y mamba -n base -c conda-forge

# Instalar JupyterLab y extensiones utiles
RUN mamba install -y \
    jupyterlab \
    ipywidgets \
    jupyter-server-proxy \
    nodejs \
    && mamba clean -afy

# Instalar extensiones de JupyterLab
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager --no-build && \
    jupyter lab build --dev-build=False --minimize=True

# Instalar librerias cientificas basicas (opcional, descomentar si necesitas)
# RUN mamba install -y \
#     numpy \
#     pandas \
#     matplotlib \
#     seaborn \
#     scikit-learn \
#     scipy \
#     && mamba clean -afy

# Configurar directorio de trabajo
WORKDIR /workspace

# Exponer puerto de JupyterLab
EXPOSE 8888

# Crear script de inicio
RUN echo '#!/bin/bash' > /start.sh && \
    echo 'jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token="" --NotebookApp.password=""' >> /start.sh && \
    chmod +x /start.sh

# Comando por defecto
CMD ["/start.sh"]
