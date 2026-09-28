# Lollipop

A personal study curriculum app. This increment provides the frontend foundation described in [the PRD](docs/PRD.md).

## Local development

Use Node.js 22.12+ (an LTS release is recommended) and pnpm 12.6.0.

```sh
pnpm install --frozen-lockfile
pnpm dev
```

The starter dashboard runs without environment variables. Supabase JS is installed, but authentication, the client connection, database schema, migrations, and data access are deferred. When connecting Supabase, copy `.env.example` to `.env.local` and supply only the project URL and browser-safe publishable key. Generate database types from the schema before adding typed queries.

## Commands

| Command          | Purpose                                       |
| ---------------- | --------------------------------------------- |
| `pnpm dev`       | Start Vite with hot reload                    |
| `pnpm build`     | Typecheck and build static files into `dist/` |
| `pnpm preview`   | Preview the production build locally          |
| `pnpm typecheck` | Check application and tooling TypeScript      |
| `pnpm lint`      | Run ESLint with zero warnings allowed         |
| `pnpm test`      | Run routing smoke tests with Vitest           |
| `pnpm audit`     | Check installed dependencies for advisories   |

## Foundation

- React and TypeScript, built with Vite.
- Code-based TanStack Router routes in `src/router.ts`, with QueryClient available in route context and React's Query provider. Only a public placeholder dashboard is present; add authentication guards before introducing user data.
- TanStack Form and Zod are installed for future feature forms; no placeholder business forms are implemented.
- Tailwind CSS v4 uses the Vite plugin and CSS theme tokens in `src/index.css`.
- shadcn/ui is manually configured with `components.json`, the `@/` alias, the `cn` utility, and a local Card component. Only Card's utility dependencies (`clsx` and `tailwind-merge`) are installed. Add primitive, variant, icon, and animation packages when components actually need them; no CLI dependency is required for this setup.
- `.env` files, build output, dependencies, and local files are ignored by Git.

Package security lives in `pnpm-workspace.yaml`: seven-day minimum release age, strict release-age checks, blocked exotic subdependencies, exact direct versions, and only esbuild allowed to execute dependency build scripts. The legacy `onlyBuiltDependencies` entry was removed because pnpm 12 uses `allowBuilds`.

The routing tests render components in Node for smoke coverage; they do not replace browser or responsive visual testing. No application SSR is configured.
