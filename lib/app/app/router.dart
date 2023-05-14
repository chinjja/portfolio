import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/models/models.dart';
import 'package:portfolio/pages/dashboard/view/dashboard_form.dart';
import 'package:portfolio/pages/pages.dart';

part 'router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

@TypedShellRoute<HomeRoute>(
  routes: [
    TypedGoRoute<DashboardRoute>(
      path: '/dashboard',
      routes: [
        TypedGoRoute<DashboardFormRoute>(path: 'form'),
      ],
    ),
    TypedGoRoute<ProjectsRoute>(
      path: '/projects',
    ),
    TypedGoRoute<ChatsRoute>(
      path: '/chats',
      routes: [
        TypedGoRoute<ChatRoute>(path: ':chatId'),
      ],
    ),
  ],
)
class HomeRoute extends ShellRouteData {
  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    return HomePage(child: navigator);
  }
}

class DashboardRoute extends GoRouteData {
  const DashboardRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DashboardPage();
  }
}

class DashboardFormRoute extends GoRouteData {
  final Dashboard $extra;
  const DashboardFormRoute({required this.$extra});

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return MaterialPage(
      key: state.pageKey,
      fullscreenDialog: true,
      child: DashboardForm(initialValue: $extra),
    );
  }
}

class ProjectsRoute extends GoRouteData {
  const ProjectsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ProjectsPage();
  }
}

class ChatsRoute extends GoRouteData {
  const ChatsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ChatsPage();
  }
}

class ChatRoute extends GoRouteData {
  static final $parentNavigatorKey = _rootNavigatorKey;

  final String chatId;
  const ChatRoute({
    required this.chatId,
  });
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ChatPage(chatId: chatId);
  }
}

@TypedGoRoute<LoginRoute>(path: '/login')
class LoginRoute extends GoRouteData {
  const LoginRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LoginPage();
  }
}

@TypedGoRoute<MarkdownRoute>(path: '/markdown/:path')
class MarkdownRoute extends GoRouteData {
  static final $parentNavigatorKey = _rootNavigatorKey;

  final String path;
  const MarkdownRoute({
    required this.path,
  });
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return MarkdownPage(path: path);
  }
}

class AppRouter extends GoRouter {
  AppRouter({
    required WidgetRef ref,
    super.initialLocation,
  }) : super(
          navigatorKey: _rootNavigatorKey,
          routes: $appRoutes,
          redirect: (context, state) {
            final subloc = state.matchedLocation;
            final loggedIn = ref.read(getCurrentUserProvider) != null;
            final loggingIn = subloc == const LoginRoute().location;

            if (subloc == '/') return const DashboardRoute().location;
            if (!loggingIn && !subloc.startsWith('/chats')) {
              return null;
            }
            final from = subloc == '/' ? '' : '?from=${state.location}';
            if (!loggedIn) {
              return loggingIn ? null : '/login$from';
            }
            if (loggingIn) {
              return state.queryParameters['from'] ?? '/';
            }
            return null;
          },
          refreshListenable: ref.read(refreshRouterProvider),
        );
}
