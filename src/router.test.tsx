import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { createMemoryHistory, RouterProvider } from "@tanstack/react-router";
import { renderToString } from "react-dom/server";
import { describe, expect, it } from "vitest";
import { createAppRouter } from "@/router";

async function renderPath(path: string) {
  const queryClient = new QueryClient();
  const router = createAppRouter(queryClient);
  router.update({
    context: { queryClient },
    history: createMemoryHistory({ initialEntries: [path] }),
  });
  await router.load();
  return renderToString(
    <QueryClientProvider client={queryClient}>
      <RouterProvider router={router} />
    </QueryClientProvider>,
  );
}

describe("application routing", () => {
  it("loads the dashboard without backend configuration", async () => {
    const html = await renderPath("/");
    expect(html).toContain("A little space to learn.");
    expect(html).toContain("Welcome to Lollipop");
    expect(html).toContain('id="main"');
  });

  it("offers a way home from an unknown route", async () => {
    const html = await renderPath("/missing-page");
    expect(html).toContain("Page not found");
    expect(html).toContain("Return to dashboard");
    expect(html).toContain('href="/"');
  });
});
