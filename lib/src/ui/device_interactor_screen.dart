// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:bleriomob/main.dart';
import 'package:bleriomob/src/ble/ble_device_interactor.dart';

// import 'package:provider/provider.dart';


@RoutePage()
class DeviceInteractorScreen extends ConsumerWidget {
  final String deviceId;
  const DeviceInteractorScreen({Key? key, required this.deviceId})
      : super(key: key);

  dynamic _deviceInteractor(ConnectionStateUpdate connectionStateUpdate,
      BleDeviceInteractor deviceInteractor) {
    if (connectionStateUpdate.connectionState ==
        DeviceConnectionState.connected) {
      return DeviceInteractor(
        deviceId: deviceId,
        deviceInteractor: deviceInteractor,
      );
    } else if (connectionStateUpdate.connectionState ==
        DeviceConnectionState.connecting) {
      return const Text('connecting');
    } else {
      return const Text('error');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectionStateUpdate =
        ref.watch(bleConnectionStateUpdateProvider).value!;
    final deviceInteractor = serviceDiscoverer;
    return Scaffold(
      body: Center(
        child: _deviceInteractor(connectionStateUpdate, deviceInteractor),
      ),
    );
  }
}

class DeviceInteractor extends StatefulWidget {
  final BleDeviceInteractor deviceInteractor;

  final String deviceId;
  const DeviceInteractor(
      {Key? key, required this.deviceInteractor, required this.deviceId})
      : super(key: key);

  @override
  State<DeviceInteractor> createState() => _DeviceInteractorState();
}

class _DeviceInteractorState extends State<DeviceInteractor> {
  final Uuid _myServiceUuid =
      Uuid.parse("19b10000-e8f2-537e-4f6c-6969768a1214");
  final Uuid _myCharacteristicUuid =
      Uuid.parse("19b10001-e8f2-537e-4f6c-6969768a1214");

  Stream<List<int>>? subscriptionStream;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('connected'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: subscriptionStream != null
                  ? null
                  : () async {
                      setState(() {
                        subscriptionStream =
                            widget.deviceInteractor.subScribeToCharacteristic(
                          QualifiedCharacteristic(
                              characteristicId: _myCharacteristicUuid,
                              serviceId: _myServiceUuid,
                              deviceId: widget.deviceId),
                        );
                      });
                    },
              child: const Text('subscribe'),
            ),
            const SizedBox(
              width: 20,
            ),
            ElevatedButton(
              onPressed: () {
                context.router.pop();
              },
              child: const Text('disconnect'),
            ),
          ],
        ),
        subscriptionStream != null
            ? StreamBuilder<List<int>>(
                stream: subscriptionStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    print(snapshot.data);
                    return Text(snapshot.data.toString());
                  }
                  return const Text('No data yet');
                })
            : const Text('Stream not initialized')
      ],
    );
  }
}
