// Package imports:
import 'package:auto_route/auto_route.dart';

// Project imports:
import 'package:blerio/src/routes/routes.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends $AppRouter {
  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/',
          page: HomeRoute.page,
        ),
        AutoRoute(
          path: '/interactor',
          page: DeviceInteractorRoute.page,
        ),
        AutoRoute(
          path: '/list',
          page: DeviceListRoute.page,
        ),
      ];
}
