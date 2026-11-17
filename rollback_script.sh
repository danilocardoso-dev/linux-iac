#!/bin/bash

# ==============================================================================
# Script: rollback_script.sh
# Descrição: Exclusão completa da infraestrutura provisionada para testes
#            e reset do ambiente.
# Execução: sudo ./rollback_script.sh
# ==============================================================================

# Valida se o script está sendo executado como superusuário (root)
if [ "$EUID" -ne 0 ]; then
  echo "[ERRO] Este script deve ser executado como root. Utilize: sudo $0" >&2
  exit 1
fi

echo "=========================================================="
echo "Iniciando limpeza e reset da infraestrutura provisionada..."
echo "=========================================================="

# ------------------------------------------------------------------------------
# 1. Exclusão dos Usuários e Diretórios Home
# ------------------------------------------------------------------------------
echo -e "\n[1/3] Removendo usuários e respectivos diretórios /home..."
USUARIOS=("carlos" "maria" "joao_" "debora" "sebastiana" "roberto" "josefina" "amanda" "rogerio")

for user in "${USUARIOS[@]}"; do
    if id "$user" &>/dev/null; then
        userdel -r -f "$user"
        echo "Usuário '$user' removido com sucesso."
    else
        echo "Usuário '$user' não encontrado, ignorando..."
    fi
done

# ------------------------------------------------------------------------------
# 2. Exclusão dos Grupos
# ------------------------------------------------------------------------------
echo -e "\n[2/3] Removendo grupos de usuários..."
GRUPOS=("GRP_ADM" "GRP_VEN" "GRP_SEC")

for group in "${GRUPOS[@]}"; do
    if getent group "$group" &>/dev/null; then
        groupdel "$group"
        echo "Grupo '$group' removido com sucesso."
    else
        echo "Grupo '$group' não encontrado, ignorando..."
    fi
done

# ------------------------------------------------------------------------------
# 3. Exclusão dos Diretórios
# ------------------------------------------------------------------------------
echo -e "\n[3/3] Removendo diretórios /publico, /adm, /ven e /sec..."
rm -rf /publico /adm /ven /sec

echo "=========================================================="
echo "Ambiente resetado com sucesso!"
echo "=========================================================="
