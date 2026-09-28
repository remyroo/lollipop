import { Link, Outlet } from "@tanstack/react-router";

export function RootLayout() {
  return (
    <>
      <a
        href="#main"
        className="sr-only focus:not-sr-only focus:absolute focus:bg-background focus:p-4"
      >
        Skip to content
      </a>
      <header className="border-b">
        <nav
          aria-label="Main navigation"
          className="mx-auto flex max-w-5xl flex-wrap items-center justify-between gap-4 px-6 py-5"
        >
          <Link to="/" className="font-semibold tracking-tight">
            Lollipop
          </Link>
          <Link
            to="/"
            activeProps={{ "aria-current": "page" }}
            className="text-sm underline-offset-4 hover:underline"
          >
            Dashboard
          </Link>
        </nav>
      </header>
      <main id="main" className="mx-auto max-w-5xl px-6 py-12 sm:py-20">
        <Outlet />
      </main>
    </>
  );
}

export function NotFoundPage() {
  return (
    <section className="space-y-4">
      <h1 className="text-3xl font-semibold">Page not found</h1>
      <Link to="/" className="underline underline-offset-4">
        Return to dashboard
      </Link>
    </section>
  );
}

export function RouteErrorPage() {
  return (
    <section role="alert" className="space-y-4">
      <h1 className="text-3xl font-semibold">Something went wrong</h1>
      <p>Please reload the page to try again.</p>
      <a href="/" className="underline underline-offset-4">
        Reload dashboard
      </a>
    </section>
  );
}
