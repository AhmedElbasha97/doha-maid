import 'package:flutter/material.dart';

class AppRouteTracker extends RouteObserver<PageRoute<dynamic>> {
  final List<Route<dynamic>> routeStack = [];

  @override
  void didPush(Route route, Route? previousRoute) {
    routeStack.add(route);
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    routeStack.remove(route);
    super.didPop(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    if (oldRoute != null) routeStack.remove(oldRoute);
    if (newRoute != null) routeStack.add(newRoute);
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}

/// ✅ SINGLE GLOBAL INSTANCE
final AppRouteTracker appRouteObserver = AppRouteTracker();