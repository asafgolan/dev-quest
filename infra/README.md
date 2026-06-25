# Mac home server — reverse proxy

Caddy fronts the local services on this Mac. Tailscale handles TLS and remote
access; Caddy runs HTTP-only on `127.0.0.1:8080` and routes by path.

## One-time setup

    cp .env.example .env          # then edit .env and paste a real token
    openssl rand -hex 32          # use this value as LLM_BEARER_TOKEN
    chmod +x run.sh

## Run

    ./run.sh                      # starts Caddy on :8080
    tailscale serve --bg 8080     # expose privately to your tailnet (run once)

Reachable at `https://<machine>.<tailnet>.ts.net/` from your tailnet devices.

## Routes

| Path         | Backend           | Auth                            |
|--------------|-------------------|---------------------------------|
| `/llm/*`     | Ollama `:11434`   | `Authorization: Bearer <token>` |
| `/prefect/*` | Prefect `:4200`   | tailnet only                    |

## Notes

- **Prefect under a subpath** needs its base path set or its UI links break:
  `PREFECT_UI_SERVE_BASE=/prefect` (plus a matching `PREFECT_UI_API_URL`).
- Only `.env.example` is committed. The real `.env` holds the token and stays
  local (gitignored).
- Adding a service = one more `handle_path` block in the `Caddyfile`.
- Tailscale terminates TLS; keep Caddy HTTP-only here (`auto_https off`) so the
  two don't fight over certificates.
