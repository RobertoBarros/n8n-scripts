# n8n

n8n local com Docker Compose e acesso público via Cloudflare Tunnel.

## Requisitos

- Docker com Compose, em execução.
- `cloudflared` instalado.
- Zsh no macOS.

## Iniciar

```zsh
./start.zsh
```

Cria um túnel, atualiza as URLs no `compose.yml` e inicia o n8n em primeiro plano. A URL pública aparece no terminal, é copiada para a área de transferência e muda a cada execução.

O acesso local fica em http://localhost:5678. Para encerrar o n8n e o túnel, pressione `Ctrl+C`.

## Atualizar

Encerre a execução anterior com `Ctrl+C` e execute:

```zsh
./update.zsh
```

Baixa a imagem `n8nio/n8n:latest` e executa o script de início.

## Dados

Os dados persistem no volume Docker `n8n_data`. Faça backup antes de atualizar.
