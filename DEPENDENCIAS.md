# 📦 Dependências do Script `validador.sh`

Este script depende dos seguintes pacotes/utilitários do sistema para funcionar corretamente:

```
# Lista de dependências (comando | pacote Debian)
iw              # wireless-tools
nmcli           # network-manager
ip              # iproute2
ping            # iputils-ping
hostname        # hostname
scrot           # scrot (para capturas de tela)
```

---

## 🧰 Como instalar todas as dependências no Debian, Kali, Ubuntu e derivados

Você pode instalar todas de uma vez com o comando abaixo:

```bash
sudo apt update
sudo apt install -y wireless-tools network-manager iproute2 iputils-ping scrot hostname
```

---

## 💡 Observações

- O script pressupõe que a interface Wi-Fi está ativa e gerenciada pelo `NetworkManager`.
- O `scrot` salva screenshots do terminal para validação visual.
- A pasta raiz de validação precisa ter permissão de escrita (`/home/hugo/valid`).
- O script solicita o número do INEP e cria uma subpasta para armazenar os arquivos gerados.