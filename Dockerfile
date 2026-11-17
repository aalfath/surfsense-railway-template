# SurfSense for Railway: the official image, pinned by version and digest,
# plus a Caddyfile that listens on Railway's PORT and a start script that
# hands the root-owned Railway volume to the app's user (uid 1000).
FROM ghcr.io/modsetter/surfsense:2.3.1@sha256:106baa89d5f79168c1c5e9bce77655d3e99f2950250772a1d41508c04d73a4a0

USER root
COPY Caddyfile /app/caddy/Caddyfile
COPY start.sh /usr/local/bin/surfsense-railway-start
RUN chmod 0755 /usr/local/bin/surfsense-railway-start

ENV PORT=8080
EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=180s --retries=3 \
    CMD ["node", "-e", "fetch('http://localhost:' + (process.env.PORT || 8080) + '/api/health').then((r) => process.exit(r.ok ? 0 : 1), () => process.exit(1))"]

ENTRYPOINT ["tini", "-g", "--", "/usr/local/bin/surfsense-railway-start"]
CMD ["node", "/app/surfsense_local/headless/main.ts"]
