// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:bleriomob/main.dart';
import 'package:bleriomob/src/ble/ble_device_connector.dart';
import 'package:bleriomob/src/ble/ble_scanner.dart';
import 'package:bleriomob/src/routes/routes.gr.dart';
import 'package:bleriomob/src/ui/device_interactor_screen.dart';

@RoutePage()
class DeviceListScreen extends ConsumerWidget {
  const DeviceListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bleScanner = scanner;
    final bleScannerState = ref.watch(bleScannerStateProvider).value;
    final bleDeviceConnector = connector;
    return _DeviceList(
      scannerState: bleScannerState ??
          const BleScannerState(
            discoveredDevices: [],
            scanIsInProgress: false,
          ),
      startScan: bleScanner.startScan,
      stopScan: bleScanner.stopScan,
      deviceConnector: bleDeviceConnector,
    );
  }
}

class _DeviceList extends StatefulWidget {
  const _DeviceList({
    required this.scannerState,
    required this.startScan,
    required this.stopScan,
    required this.deviceConnector,
  });

  final BleDeviceConnector deviceConnector;
  final BleScannerState scannerState;
  final void Function(List<Uuid>) startScan;
  final VoidCallback stopScan;
  @override
  __DeviceListState createState() => __DeviceListState();
}

class __DeviceListState extends State<_DeviceList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: ListView(
                children: widget.scannerState.discoveredDevices
                    .map(
                      (device) => ListTile(
                        title: Text(device.name),
                        subtitle: Text("${device.id}\nRSSI: ${device.rssi}"),
                        leading: const Icon(Icons.bluetooth),
                        onTap: () async {
                          widget.stopScan();
                          widget.deviceConnector.connect(device.id);
                          await context.router
                              .push(DeviceInteractorRoute(deviceId: device.id));
                          widget.deviceConnector.disconnect(device.id);
                          widget.startScan([]);
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: !widget.scannerState.scanIsInProgress
                      ? () => widget.startScan([])
                      : null,
                  child: const Text('Scan'),
                ),
                ElevatedButton(
                  onPressed: widget.scannerState.scanIsInProgress
                      ? widget.stopScan
                      : null,
                  child: const Text('Stop'),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
    );
  }
}
