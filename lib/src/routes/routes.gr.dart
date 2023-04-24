// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i5;
import 'package:blerio/main.dart' as _i4;
import 'package:blerio/src/ui/ble_status_screen.dart' as _i3;
import 'package:blerio/src/ui/device_interactor_screen.dart' as _i1;
import 'package:blerio/src/ui/device_list_screen.dart' as _i2;
import 'package:flutter/material.dart' as _i6;
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart' as _i7;

abstract class $AppRouter extends _i5.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i5.PageFactory> pagesMap = {
    DeviceInteractorRoute.name: (routeData) {
      final args = routeData.argsAs<DeviceInteractorRouteArgs>();
      return _i5.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.DeviceInteractorScreen(
          key: args.key,
          deviceId: args.deviceId,
        ),
      );
    },
    DeviceListRoute.name: (routeData) {
      return _i5.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.DeviceListScreen(),
      );
    },
    BleStatusRoute.name: (routeData) {
      final args = routeData.argsAs<BleStatusRouteArgs>();
      return _i5.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i3.BleStatusScreen(
          status: args.status,
          key: args.key,
        ),
      );
    },
    HomeRoute.name: (routeData) {
      return _i5.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.HomeScreen(),
      );
    },
  };
}

/// generated route for
/// [_i1.DeviceInteractorScreen]
class DeviceInteractorRoute
    extends _i5.PageRouteInfo<DeviceInteractorRouteArgs> {
  DeviceInteractorRoute({
    _i6.Key? key,
    required String deviceId,
    List<_i5.PageRouteInfo>? children,
  }) : super(
          DeviceInteractorRoute.name,
          args: DeviceInteractorRouteArgs(
            key: key,
            deviceId: deviceId,
          ),
          initialChildren: children,
        );

  static const String name = 'DeviceInteractorRoute';

  static const _i5.PageInfo<DeviceInteractorRouteArgs> page =
      _i5.PageInfo<DeviceInteractorRouteArgs>(name);
}

class DeviceInteractorRouteArgs {
  const DeviceInteractorRouteArgs({
    this.key,
    required this.deviceId,
  });

  final _i6.Key? key;

  final String deviceId;

  @override
  String toString() {
    return 'DeviceInteractorRouteArgs{key: $key, deviceId: $deviceId}';
  }
}

/// generated route for
/// [_i2.DeviceListScreen]
class DeviceListRoute extends _i5.PageRouteInfo<void> {
  const DeviceListRoute({List<_i5.PageRouteInfo>? children})
      : super(
          DeviceListRoute.name,
          initialChildren: children,
        );

  static const String name = 'DeviceListRoute';

  static const _i5.PageInfo<void> page = _i5.PageInfo<void>(name);
}

/// generated route for
/// [_i3.BleStatusScreen]
class BleStatusRoute extends _i5.PageRouteInfo<BleStatusRouteArgs> {
  BleStatusRoute({
    required _i7.BleStatus status,
    _i6.Key? key,
    List<_i5.PageRouteInfo>? children,
  }) : super(
          BleStatusRoute.name,
          args: BleStatusRouteArgs(
            status: status,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'BleStatusRoute';

  static const _i5.PageInfo<BleStatusRouteArgs> page =
      _i5.PageInfo<BleStatusRouteArgs>(name);
}

class BleStatusRouteArgs {
  const BleStatusRouteArgs({
    required this.status,
    this.key,
  });

  final _i7.BleStatus status;

  final _i6.Key? key;

  @override
  String toString() {
    return 'BleStatusRouteArgs{status: $status, key: $key}';
  }
}

/// generated route for
/// [_i4.HomeScreen]
class HomeRoute extends _i5.PageRouteInfo<void> {
  const HomeRoute({List<_i5.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i5.PageInfo<void> page = _i5.PageInfo<void>(name);
}
