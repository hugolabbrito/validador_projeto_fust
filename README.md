# 🖥️ Script de Validação de Conexão Wi-Fi

Este script gera um relatório completo da conexão Wi-Fi atual e captura screenshots para validação.

## 📋 Funcionalidades

- Mostra dados como SSID, BSSID, canal, frequência, IPv4, gateway, segurança etc.
- Executa `ping` para 8.8.8.8 e salva a resposta.
- Captura duas imagens da tela (dados da rede e ping).
- Salva os arquivos em uma subpasta personalizada com base no número do INEP.

## 📂 Estrutura de Diretórios

```
/home/hugo/valid/
└── [INEP]
    ├── wifi_status_DD-MM-YYYY_HH-MM-SS.txt
    ├── wifi_status_DD-MM-YYYY_HH-MM-SS_ping.txt
    ├── wifi_status_DD-MM-YYYY_HH-MM-SS.png
    └── wifi_status_DD-MM-YYYY_HH-MM-SS_ping.png
```

## ⚙️ Execução

```bash
chmod +x validador.sh
./validador.sh
```

---

Para as dependências necessárias, veja [DEPENDENCIAS.md](./DEPENDENCIAS.md).