#!/bin/bash

# ==============================================================================
# Script: iac_script.sh
# Descrição: Provisionamento automatizado de diretórios, grupos, usuários
#            e políticas de permissões no Linux (Desafio DIO - IaC).
# Execução: sudo ./iac_script.sh
# ==============================================================================

# Interrompe a execução caso ocorra qualquer erro crítico
set -e

# Valida se o script está sendo executado como superusuário (root)
if [ "$EUID" -ne 0 ]; then
  echo "[ERRO] Este script deve ser executado como root. Utilize: sudo $0" >&2
  exit 1
fi

echo "=========================================================="
echo "Iniciando provisionamento da Infraestrutura como Código..."
echo "=========================================================="

# ------------------------------------------------------------------------------
# 1. Criação dos Diretórios
# ------------------------------------------------------------------------------
echo -e "\n[1/4] Criando diretórios na raiz..."
mkdir -v -p /publico /adm /ven /sec

# ------------------------------------------------------------------------------
# 2. Criação dos Grupos Departamentais
# ------------------------------------------------------------------------------
echo -e "\n[2/4] Criando grupos de usuários..."
groupadd -f GRP_ADM
groupadd -f GRP_VEN
groupadd -f GRP_SEC

# ------------------------------------------------------------------------------
# 3. Criação e Configuração dos Usuários
# ------------------------------------------------------------------------------
echo -e "\n[3/4] Criando usuários e associando aos grupos..."

# Senha padrão criptografada em hash SHA-512 via openssl (Senha: Senha123)
SENHA_PADRAO=$(openssl passwd -6 "Senha123")

# Usuários do grupo GRP_ADM
useradd carlos -m -s /bin/bash -p "$SENHA_PADRAO" -G GRP_ADM
useradd maria -m -s /bin/bash -p "$SENHA_PADRAO" -G GRP_ADM
useradd joao_ -m -s /bin/bash -p "$SENHA_PADRAO" -G GRP_ADM

# Usuários do grupo GRP_VEN
useradd debora -m -s /bin/bash -p "$SENHA_PADRAO" -G GRP_VEN
useradd sebastiana -m -s /bin/bash -p "$SENHA_PADRAO" -G GRP_VEN
useradd roberto -m -s /bin/bash -p "$SENHA_PADRAO" -G GRP_VEN

# Usuários do grupo GRP_SEC
useradd josefina -m -s /bin/bash -p "$SENHA_PADRAO" -G GRP_SEC
useradd amanda -m -s /bin/bash -p "$SENHA_PADRAO" -G GRP_SEC
useradd rogerio -m -s /bin/bash -p "$SENHA_PADRAO" -G GRP_SEC

# ------------------------------------------------------------------------------
# 4. Definição de Proprietários (chown) e Permissões (chmod)
# ------------------------------------------------------------------------------
echo -e "\n[4/4] Definindo proprietários e políticas de permissões..."

# Atribuição de dono e grupo aos diretórios
chown root:root /publico
chown root:GRP_ADM /adm
chown root:GRP_VEN /ven
chown root:GRP_SEC /sec

# Configuração das permissões de acesso:
# /publico: total (777 - rwxrwxrwx)
chmod 777 /publico

# /adm, /ven, /sec: apenas root e membros do respectivo grupo (770 - rwxrwx---)
chmod 770 /adm
chmod 770 /ven
chmod 770 /sec

echo "=========================================================="
echo "Provisionamento da infraestrutura concluído com sucesso!"
echo "=========================================================="
