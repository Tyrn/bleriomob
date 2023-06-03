// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;

// Project imports:
import 'package:bleriomob/src/ble/ble_device_connector.dart';
import 'package:bleriomob/src/ble/ble_device_interactor.dart';
import 'package:bleriomob/src/ble/ble_scanner.dart';
import 'package:bleriomob/src/ble/ble_status_monitor.dart';
import 'package:bleriomob/src/routes/routes.dart';
import 'package:bleriomob/src/ui/ble_status_screen.dart';
import 'package:bleriomob/src/ui/device_list_screen.dart';
import 'src/ble/ble_logger.dart';

const _themeColor = Colors.lightGreen;

final appRouter = AppRouter();

final bleLogger = BleLogger();
final ble = FlutterReactiveBle();
final scanner = BleScanner(ble: ble, logMessage: bleLogger.addToLog); // S
final monitor = BleStatusMonitor(ble); // S
final connector = BleDeviceConnector(
  ble: ble,
  logMessage: bleLogger.addToLog,
); // S
final serviceDiscoverer = BleDeviceInteractor(
  bleDiscoverServices: ble.discoverServices,
  readCharacteristic: ble.readCharacteristic,
  writeWithResponse: ble.writeCharacteristicWithResponse,
  writeWithOutResponse: ble.writeCharacteristicWithoutResponse,
  subscribeToCharacteristic: ble.subscribeToCharacteristic,
  logMessage: bleLogger.addToLog,
);

final bleScannerStateProvider =
    StreamProvider<BleScannerState?>((ref) => scanner.state);
final bleStatusProvider = StreamProvider<BleStatus?>((ref) => monitor.state);
final bleConnectionStateUpdateProvider =
    StreamProvider<ConnectionStateUpdate>((ref) => connector.state);

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ProviderScope(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: true,
        routerConfig: appRouter.config(),
        title: 'Bluetooth BLE Client',
        color: _themeColor,
        theme: ThemeData(primarySwatch: _themeColor),
      ),
    ),
  );
  FlutterError.demangleStackTrace = (StackTrace stack) {
    if (stack is stack_trace.Trace) return stack.vmTrace;
    if (stack is stack_trace.Chain) return stack.toTrace().vmTrace;
    return stack;
  };
}

@RoutePage()
class HomeScreen extends ConsumerWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(bleStatusProvider).value;
    if (status == BleStatus.ready) {
      return const DeviceListScreen();
    } else {
      return BleStatusScreen(status: status ?? BleStatus.unknown);
    }
  }
}
