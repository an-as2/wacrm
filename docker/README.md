Docker notes for WACRM (Next.js)

Overview
- This repository contains a production-ready multi-stage `Dockerfile` and a `docker-compose.yml` to run the Next.js web app.
- The image uses Node 20 for both build and runtime.

Required environment variables
- Provide your runtime env in a `.env` file at the repository root (not committed).
- Typical variables to set (project-specific names may vary):
  - `NEXT_PUBLIC_SUPABASE_URL`
  - `NEXT_PUBLIC_SUPABASE_ANON_KEY`
  - `SUPABASE_SERVICE_ROLE_KEY` (only if needed server-side)
  - `NEXT_PUBLIC_API_URL` or other app-specific keys
  - Any other env keys your `.env` currently contains

Build & run (Docker)

Build the image locally:

```bash
docker build -t wacrm-web:prod .
```

Run with your `.env`:

```bash
docker run --env-file .env -p 3000:3000 wacrm-web:prod
```

Compose (recommended for local orchestration)

```bash
docker-compose up --build
```

Notes
- The `docker-compose.yml` assumes Supabase is external. If you want a local Postgres/Supabase service for testing, I can add a sample service and wiring.
- For development with hot-reload, request a dev-specific Dockerfile and a `docker-compose.override.yml` that mounts volumes and runs `next dev`.
- For smaller runtime images, consider switching the runner to a distroless base or using Next's `output: 'standalone'` build and copying only the standalone output.

Security
- Never keep secrets in images or commit `.env` to source control. Use external secret stores in production.
