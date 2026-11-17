[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/surfsense-1?utm_medium=integration&utm_source=button&utm_campaign=surfsense)

# SurfSense on Railway

A Railway template for [SurfSense](https://github.com/MODSetter/SurfSense), the
open-source, privacy-focused NotebookLM alternative: an AI agent that researches,
transforms and edits your documents.

**Version:** SurfSense 2.3.1, from the official image
`ghcr.io/modsetter/surfsense:2.3.1@sha256:106baa89d5f79168c1c5e9bce77655d3e99f2950250772a1d41508c04d73a4a0`
(linux/amd64).

## What it deploys

One service, built from this repository's `Dockerfile`:

- the official SurfSense container (Caddy, the API, the workers and the local
  model servers, managed by SurfSense's own supervisor);
- a Railway volume at `/data` for everything SurfSense keeps: its SQLite
  databases, the secret that encrypts stored provider keys, the sign-in
  password hash, uploaded documents, downloaded models and backups;
- a public Railway domain, with the health check on `/api/health`.

The wrapper is small: `Caddyfile` makes Caddy listen on Railway's `PORT` (Railway
terminates HTTPS), and `start.sh` hands the root-owned volume to the app's user
(uid 1000) before it starts SurfSense as that user.

## Variables

| Variable | Default | What it does |
|---|---|---|
| `SURFSENSE_PASSWORD` | `${{secret(24)}}` | The sign-in password, generated at deploy time. Read it in the service's Variables tab. Set at every start, so changing it here and redeploying resets it |
| `PORT` | `8080` | The port Caddy listens on and the domain points to |

Optional settings from SurfSense's
[`.env.example`](https://github.com/MODSetter/SurfSense/blob/main/docker/surfsense/.env.example)
can be added as variables: `SURFSENSE_ALLOWED_HOSTS` (restrict the host names it
answers on) and `SURFSENSE_SECRET` (keep the encryption secret outside the
volume). Leave `SURFSENSE_TLS` and `SURFSENSE_DOMAIN` unset: Railway already
serves HTTPS. Model providers (OpenAI, Anthropic, Ollama and others) are added
in the app's settings.

## Updates

Changes reach deployers through this repository: a merge to `main` (a new pinned
SurfSense version or a wrapper fix) makes Railway show an "update available"
notice on every project deployed from the template, and each deployer chooses
when to apply it. Read `CHANGELOG.md` first: breaking changes are listed first.
SurfSense backs up its database to `/data/backups` before it migrates.
