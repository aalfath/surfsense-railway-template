# Changelog

Breaking changes come first in each entry. Deployers get an "update available"
notice in Railway when a change lands on `main`, and choose when to apply it.

## 2.3.1 (2026-11-17)

- First release of the Railway template: SurfSense 2.3.1
  (`ghcr.io/modsetter/surfsense:2.3.1@sha256:106baa89d5f79168c1c5e9bce77655d3e99f2950250772a1d41508c04d73a4a0`).
- Caddy listens on Railway's `PORT` (8080); the start script hands the Railway
  volume at `/data` to the app's user (uid 1000) and drops root.
- The sign-in password comes from `SURFSENSE_PASSWORD`, generated at deploy time.
