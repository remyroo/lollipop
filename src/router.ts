import { createRootRouteWithContext, createRoute, createRouter } from '@tanstack/react-router'
import type { QueryClient } from '@tanstack/react-query'
import { DashboardPage } from '@/routes/dashboard'
import { NotFoundPage, RootLayout, RouteErrorPage } from '@/routes/root'

const rootRoute = createRootRouteWithContext<{ queryClient: QueryClient }>()({
  component: RootLayout,
  notFoundComponent: NotFoundPage,
  errorComponent: RouteErrorPage,
})

const indexRoute = createRoute({
  getParentRoute: () => rootRoute,
  path: '/',
  component: DashboardPage,
})

const routeTree = rootRoute.addChildren([indexRoute])

export function createAppRouter(queryClient: QueryClient) {
  return createRouter({ routeTree, context: { queryClient }, scrollRestoration: true })
}

declare module '@tanstack/react-router' {
  interface Register {
    router: ReturnType<typeof createAppRouter>
  }
}
