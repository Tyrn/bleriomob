// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:blerio/src/ble/ble_device_connector.dart';
import 'package:blerio/src/ble/ble_device_interactor.dart';
import 'package:blerio/src/ble/ble_scanner.dart';
import 'package:blerio/src/ble/ble_status_monitor.dart';
import 'package:blerio/src/routes/routes.dart';
import 'package:blerio/src/ui/ble_status_screen.dart';
import 'package:blerio/src/ui/device_list_screen.dart';
import 'src/ble/ble_logger.dart';

const _themeColor = Colors.lightGreen;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

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
  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: scanner),
        Provider.value(value: monitor),
        Provider.value(value: connector),
        Provider.value(value: serviceDiscoverer),
        Provider.value(value: bleLogger),
        StreamProvider<BleScannerState?>(
          create: (_) => scanner.state,
          initialData: const BleScannerState(
            discoveredDevices: [],
            scanIsInProgress: false,
          ),
        ),
        StreamProvider<BleStatus?>(
          create: (_) => monitor.state,
          initialData: BleStatus.unknown,
        ),
        StreamProvider<ConnectionStateUpdate>(
          create: (_) => connector.state,
          initialData: const ConnectionStateUpdate(
            deviceId: 'Unknown device',
            connectionState: DeviceConnectionState.disconnected,
            failure: null,
          ),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: true,
        routerConfig: appRouter.config(),
        title: 'Bluetooth BLE Client',
        color: _themeColor,
        theme: ThemeData(primarySwatch: _themeColor),
      ),
    ),
  );
}

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<BleStatus?>(
        builder: (_, status, __) {
          if (status == BleStatus.ready) {
            return const DeviceListScreen();
          } else {
            return BleStatusScreen(status: status ?? BleStatus.unknown);
          }
        },
      );
}
