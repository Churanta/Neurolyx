import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:scoped_model/scoped_model.dart';

import './BackgroundCollectedPage.dart';
import './BackgroundCollectingTask.dart';
import './ChatPage.dart';
import './DiscoveryPage.dart';
import './SelectBondedDevicePage.dart';

// import './helpers/LineChart.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPage createState() => new _MainPage();
}

class _MainPage extends State<MainPage> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

  String _address = "...";
  String _name = "...";

  Timer? _discoverableTimeoutTimer;
  int _discoverableTimeoutSecondsLeft = 0;

  BackgroundCollectingTask? _collectingTask;

  bool _autoAcceptPairingRequests = false;

  @override
  void initState() {
    super.initState();

    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    Future.doWhile(() async {
      // Wait if adapter not enabled
      if ((await FlutterBluetoothSerial.instance.isEnabled) ?? false) {
        return false;
      }
      await Future.delayed(Duration(milliseconds: 0xDD));
      return true;
    }).then((_) {
      // Update the address field
      FlutterBluetoothSerial.instance.address.then((address) {
        setState(() {
          _address = address!;
        });
      });
    });

    FlutterBluetoothSerial.instance.name.then((name) {
      setState(() {
        _name = name!;
      });
    });

    // Listen for futher state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;

        // Discoverable mode is disabled when Bluetooth gets disabled
        _discoverableTimeoutTimer = null;
        _discoverableTimeoutSecondsLeft = 0;
      });
    });
  }

  @override
  void dispose() {
    FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
    _collectingTask?.dispose();
    _discoverableTimeoutTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[500],
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text("Neurolyx"),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Divider(),
            // ListTile(title: const Text('Connect To Neurolyx')),
            SwitchListTile(
              title: const Text('Enable Bluetooth'),
              activeColor: Colors.purple[100],
              activeTrackColor: Colors.purple[300],
              inactiveThumbColor: Color.fromARGB(255, 252, 243, 233),
              inactiveTrackColor: Colors.purple[100],
              value: _bluetoothState.isEnabled,
              onChanged: (bool value) {
                // Do the request and update with the true value then
                future() async {
                  // async lambda seems to not working
                  if (value)
                    await FlutterBluetoothSerial.instance.requestEnable();
                  else
                    await FlutterBluetoothSerial.instance.requestDisable();
                }

                future().then((_) {
                  setState(() {});
                });
              },
            ),
            ListTile(
              title: const Text('Bluetooth status'),
              subtitle: Text(_bluetoothState.toString()),
              trailing: ElevatedButton(
                child: const Text('Settings'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.purple[500],
                ),
                onPressed: () {
                  FlutterBluetoothSerial.instance.openSettings();
                },
              ),
            ),
            // ListTile(
            //   title: const Text('Local adapter address'),
            //   subtitle: Text(_address),
            // ),
            ListTile(
              title: const Text('This Device Name'),
              subtitle: Text(_name),
              onLongPress: null,
            ),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                
                Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.purple[300]!, Colors.purple[700]!],
                      ),
                    ),
                    child: InkWell(
                      onTap: () async {
                        final BluetoothDevice? selectedDevice =
                            await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return SelectBondedDevicePage(
                                  checkAvailability: false);
                            },
                          ),
                        );

                        if (selectedDevice != null) {
                          print(
                              'Connect -> selected ' + selectedDevice.address);
                          _startChat(context, selectedDevice);
                        } else {
                          print('Connect -> no device selected');
                        }
                      },
                      child: SizedBox(
                        width: 150.0,
                        height: 150.0,
                        child: Center(
                          child: Text(
                            'Connect to \npaired device...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),


            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.purple[300]!, Colors.purple[700]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_collectingTask?.inProgress ?? false) {
                            await _collectingTask!.cancel();
                            setState(() {
                              /* Update for `_collectingTask.inProgress` */
                            });
                          } else {
                            final BluetoothDevice? selectedDevice =
                                await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return SelectBondedDevicePage(
                                      checkAvailability: false);
                                },
                              ),
                            );

                            if (selectedDevice != null) {
                              await _startBackgroundTask(
                                  context, selectedDevice);
                              setState(() {
                                /* Update for `_collectingTask.inProgress` */
                              });
                            }
                          }
                        },
                        child: ((_collectingTask?.inProgress ?? false)
                            ? const Text(
                                'Disconnect and stop background collecting')
                            : const Text('Connect to see status')),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          primary: Colors.transparent,
                          elevation: 0.0,
                          minimumSize: Size(150.0, 150.0),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.purple[300]!, Colors.purple[700]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ElevatedButton(
                        onPressed: (_collectingTask != null)
                            ? () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return ScopedModel<
                                          BackgroundCollectingTask>(
                                        model: _collectingTask!,
                                        child: BackgroundCollectedPage(),
                                      );
                                    },
                                  ),
                                );
                              }
                            : null,
                        child: const Text('View background collected data'),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          primary: Colors.transparent,
                          elevation: 0.0,
                          minimumSize: Size(150.0, 150.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            
          ],
        ),
      ),
    );
  }

  void _startChat(BuildContext context, BluetoothDevice server) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ChatPage(server: server);
        },
      ),
    );
  }

  Future<void> _startBackgroundTask(
    BuildContext context,
    BluetoothDevice server,
  ) async {
    try {
      _collectingTask = await BackgroundCollectingTask.connect(server);
      await _collectingTask!.start();
    } catch (ex) {
      _collectingTask?.cancel();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error occured while connecting'),
            content: Text("${ex.toString()}"),
            actions: <Widget>[
              new TextButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
