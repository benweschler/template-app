import 'dart:async';

import 'package:template_app/main_app_scaffold.dart';
import 'package:template_app/screens/page_one.dart';
import 'package:template_app/screens/page_two.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:template_app/screens/splash_screen.dart';

import 'models/app_model.dart';

abstract class RoutePaths {
  static String splash = '/';
  static String pageOne = '/page-one';
  static String pageTwo = '/page-two';
}

class AppRouter {
  final AppModel appModel;
  final _rootNavigatorKey = GlobalKey<NavigatorState>();
  final _navBarNavigatorKey = GlobalKey<NavigatorState>();

  AppRouter(this.appModel);

  GoRouter get router {
    return GoRouter(
      initialLocation: RoutePaths.pageOne,
      navigatorKey: _rootNavigatorKey,
      refreshListenable: appModel.routerRefreshNotifier,
      redirect: redirectNavigation,
      routes: [
        ShellRoute(
          navigatorKey: _navBarNavigatorKey,
          builder: (_, __, child) => MainAppScaffold(body: child),
          routes: [
            AppRoute(
              path: RoutePaths.splash,
              builder: (_) => const SplashScreen(),
            ),
            AppRoute(
              path: RoutePaths.pageOne,
              builder: (_) => const PageOne(),
            ),
            AppRoute(
              path: RoutePaths.pageTwo,
              builder: (_) => const PageTwo(),
            ),
          ],
        ),
      ],
    );
  }

  String? redirectNavigation(BuildContext context, GoRouterState state) {
    final path = state.subloc;

    if (!appModel.isInitialized && path != RoutePaths.splash) {
      //TODO: initialize app here
      Future.delayed(const Duration(seconds: 2))
          .then((value) => appModel.isInitialized = true);
      return RoutePaths.splash;
    } else if (appModel.isInitialized && path == RoutePaths.splash) {
      return RoutePaths.pageOne;
    }

    return null;
  }
}

/// Custom GoRoute sub-class to make the router declaration easier to read.
class AppRoute extends GoRoute {
  /// Whether this route is the root route of a nav bar tab.
  ///
  /// If it is, do not use a page transition animation, meaning that switching
  /// tabs is instant.
  final bool isNavBarTab;

  AppRoute({
    required String path,
    Widget Function(GoRouterState state)? builder,
    Page Function(GoRouterState state)? pageBuilder,
    List<GoRoute> routes = const [],
    this.isNavBarTab = false,
  })  : assert((builder == null) ^ (pageBuilder == null)),
        assert(
          !(pageBuilder != null && isNavBarTab),
          'Passing a pageBuilder causes isNavBarTab to have no effect. Offending route: $path.',
        ),
        super(
          path: path,
          routes: routes,
          pageBuilder: (context, state) {
            if (pageBuilder != null) return pageBuilder(state);

            if (isNavBarTab) {
              return NoTransitionPage(
                key: state.pageKey,
                child: builder!(state),
              );
            }

            return CupertinoPage(child: builder!(state));
          },
        );
}

/// Appropriately appends to a route path in order to add [queryParams].
String _appendQueryParams(String path, Map<String, String?> queryParams) {
  if (queryParams.isEmpty) return path;
  path += '?';

  int index = 0;
  for (final entry in queryParams.entries) {
    if (entry.value == null) continue;
    path += '${entry.key}=${entry.value}';
    if (index < queryParams.length - 1) path += '&';
  }

  return path;
}

/// Converts a [Stream] to a [Listenable], which can then be passed as a
/// [refreshListenable] to a [GoRouter].
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
