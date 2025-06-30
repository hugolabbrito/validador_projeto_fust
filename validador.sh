#!/bin/bash

# Caminho base para salvar os arquivos
BASE_DIR="/home/hugo/valid"

# Solicita o número do INEP
read -p "Insira o número do INEP: " INEP

# Verifica se o número foi digitado
if [[ -z "$INEP" ]]; then
  echo "⚠️  Nenhum número de INEP fornecido. Abortando."
  exit 1
fi

# Cria a pasta de destino
DEST_DIR="${BASE_DIR}/${INEP}"
mkdir -p "$DEST_DIR"

# Nome da interface Wi-Fi
IFACE=$(iw dev | awk '$1=="Interface"{print $2}' | head -n1)
if [ -z "$IFACE" ]; then
  echo "Nenhuma interface Wi-Fi encontrada."
  exit 1
fi

# Data e hora formatadas
DATAHORA=$(date "+%d/%m/%Y %H:%M:%S")
NOW=$(date "+%d-%m-%Y_%H-%M-%S")
HOST=$(hostname)

# Segurança da conexão
ACTIVE_CON=$(nmcli -t -f NAME,DEVICE connection show --active | grep "$IFACE" | cut -d':' -f1)
SECURITY=$(nmcli -g 802-11-wireless-security.key-mgmt connection show "$ACTIVE_CON" 2>/dev/null)
SECURITY=${SECURITY:-Indefinida}

# Frequência e canal
FREQ_GHZ=$(iw dev $IFACE link | awk '/freq:/ {printf "%.3f\n", $2/1000}')
CANAL=$(iwlist $IFACE channel | grep "Current Frequency:${FREQ_GHZ} GHz" | sed -E 's/.*\(Channel ([0-9]+)\).*/\1/')

# Nomes dos arquivos (salvos dentro da pasta do INEP)
BASENAME="wifi_status_${NOW}"
TXTFILE="${DEST_DIR}/${BASENAME}.txt"
IMG1="${DEST_DIR}/${BASENAME}_1_resumo.png"
IMG2="${DEST_DIR}/${BASENAME}_2_detalhes.png"
IMG3="${DEST_DIR}/${BASENAME}_3_ping.png"

# Relatório principal (resumo)
OUTPUT=$(cat <<EOF
===============================================
      RELATÓRIO DE STATUS DA CONEXÃO WI-FI     
        HOST: $HOST     DATA: $DATAHORA        
===============================================
Interface           : $IFACE
Estado              : $(cat /sys/class/net/$IFACE/operstate)
SSID                : $(iwgetid -r)
BSSID               : $(iw dev $IFACE link | awk '/Connected to/ {print $3}')
Frequência (GHz)    : $FREQ_GHZ
Canal               : $CANAL
Taxa de Transmissão : $(iw dev $IFACE link | awk '/tx bitrate:/ {print $3, $4}')
Sinal (dBm)         : $(iw dev $IFACE link | awk '/signal:/ {print $2, $3}')
Endereço MAC        : $(cat /sys/class/net/$IFACE/address)
IPv4                : $(ip -4 addr show $IFACE | grep inet | awk '{print $2}')
Gateway             : $(ip route | grep default | grep $IFACE | awk '{print $3}')
Segurança           : $SECURITY
===============================================
EOF
)

# Detalhes técnicos e ping
DETAILS=$(nmcli device show "$IFACE")
PING_OUTPUT=$(ping -c 4 8.8.8.8)

# Salva o relatório completo no .txt
{
  echo "$OUTPUT"
  echo
  echo "🔍 Detalhes da Interface (nmcli device show $IFACE):"
  echo "---------------------------------------------------"
  echo "$DETAILS"
  echo
  echo "📡 Resultado do ping para 8.8.8.8:"
  echo "---------------------------------------------------"
  echo "$PING_OUTPUT"
} > "$TXTFILE"

# Função para exibir e capturar uma tela
print_screen() {
  local content="$1"
  local image="$2"
  local title="$3"

  clear
  echo "$content"
  sleep 1

  if command -v scrot >/dev/null 2>&1; then
    scrot -u "$image"
    echo "✅ Captura da tela '$title' salva como $image"
  else
    echo "⚠️  'scrot' não está instalado. Execute: sudo apt install scrot"
  fi

  sleep 1
}

# Tela 1: Resumo
print_screen "$OUTPUT" "$IMG1" "Resumo da Conexão Wi-Fi"

# Tela 2: Detalhes técnicos
print_screen "🔍 Detalhes da Interface:\n$DETAILS" "$IMG2" "Detalhes Técnicos"

# Tela 3: Ping
print_screen "📡 Resultado do ping para 8.8.8.8:\n$PING_OUTPUT" "$IMG3" "Ping para 8.8.8.8"

echo "✅ Relatório completo salvo em: $TXTFILE"
