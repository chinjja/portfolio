import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/models/models.dart';
import 'package:portfolio/pages/pages.dart';

class AppRouter extends GoRouter {
  AppRouter({
    required WidgetRef ref,
    super.initialLocation,
  }) : super(
          routes: [
            ShellRoute(
              builder: (context, state, child) => HomePage(child: child),
              routes: [
                GoRoute(
                  path: '/dashboard',
                  builder: (context, state) => const DashboardPage(),
                ),
                GoRoute(
                  path: '/projects',
                  builder: (context, state) => const ProjectsPage(),
                  routes: [
                    GoRoute(
                      path: 'add',
                      builder: (context, state) => ProjectForm(),
                    ),
                    GoRoute(
                      path: 'edit',
                      builder: (context, state) =>
                          ProjectForm(initialValue: state.extra as Project),
                    ),
                    GoRoute(
                      path: ':id',
                      builder: (context, state) =>
                          ProjectPage(id: state.params['id']!),
                    ),
                  ],
                ),
                GoRoute(
                  path: '/chats',
                  builder: (context, state) => const ChatsPage(),
                  routes: [
                    GoRoute(
                      path: ':id',
                      builder: (context, state) =>
                          ChatPage(id: state.params['id']!),
                    ),
                  ],
                ),
              ],
            ),
            GoRoute(
              path: '/login',
              builder: (context, state) => const LoginPage(),
            ),
          ],
          redirect: (context, state) {
            final subloc = state.subloc;
            final loggedIn = ref.read(getCurrentUserProvider) != null;
            final loggingIn = subloc == '/login';

            if (subloc == '/') return '/dashboard';
            if (!loggingIn && !subloc.startsWith('/chats')) {
              return null;
            }
            final from = subloc == '/' ? '' : '?from=${state.location}';
            if (!loggedIn) {
              return loggingIn ? null : '/login$from';
            }
            if (loggingIn) {
              return state.queryParams['from'] ?? '/';
            }
            return null;
          },
          refreshListenable: ref.read(refreshRouterProvider),
        );
}
