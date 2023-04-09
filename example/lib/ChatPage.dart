import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:horizontal_picker/horizontal_picker.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

double _value = 40;
int? _time;
int? time;
// ignore: non_constant_identifier_names
String? rec_d;
String? check;
String? data;
// ignore: unused_element
Timer? _timer;
double? datas;
String? mode = '1';
const JsonEncoder encoder = JsonEncoder.withIndent('  ');

class ChatPage extends StatefulWidget {
  final BluetoothDevice server;

  const ChatPage({required this.server});

  @override
  _ChatPage createState() => new _ChatPage();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _ChatPage extends State<ChatPage> {
  static final clientID = 0;
  BluetoothConnection? connection;

  List<_Message> messages = List<_Message>.empty(growable: true);
  String _messageBuffer = '';

  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();

  bool isConnecting = true;
  bool get isConnected => (connection?.isConnected ?? false);

  bool isDisconnecting = false;

  @override
  void initState() {
    super.initState();

    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      final check = {'check': 'Thinkfinitylabs'};
      _timer = new Timer(const Duration(milliseconds: 100), () {
        setState(() {
          _sendMessage(encoder.convert(check));
        });
      });
      print(check);
      print('Connected to the device');
      _sendMessage(encoder.convert(check));

      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

      connection!.input?.listen(_onDataReceived).onDone(() {
        // Example: Detect which side closed the connection
        // There should be `isDisconnecting` flag to show are we are (locally)
        // in middle of disconnecting process, should be set before calling
        // `dispose`, `finish` or `close`, which all causes to disconnect.
        // If we except the disconnection, `onDone` should be fired as result.
        // If we didn't except this (no flag set), it means closing by remote.
        if (isDisconnecting) {
          print('Disconnecting locally!');
          final check = {'check': 0};
          _timer = new Timer(const Duration(milliseconds: 400), () {
            setState(() {
              _sendMessage(encoder.convert(check));
              print(check);
            });
          });
        } else {
          print('Disconnected remotely!');
          final check = {'check': 0};
          _timer = new Timer(const Duration(milliseconds: 400), () {
            setState(() {
              _sendMessage(encoder.convert(check));
              print(check);
            });
          });
        }
        if (this.mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection?.dispose();
      connection = null;
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Row> list = messages.map((_message) {
      return Row(
        children: <Widget>[
          Container(
            child: Text(
                (text) {
                  return text == '/shrug' ? '¯\\_(ツ)_/¯' : text;
                }(_message.text.trim()),
                style: TextStyle(color: Colors.white)),
            padding: EdgeInsets.all(12.0),
            margin: EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
            width: 222.0,
            decoration: BoxDecoration(
                color:
                    _message.whom == clientID ? Colors.blueAccent : Colors.grey,
                borderRadius: BorderRadius.circular(7.0)),
          ),
        ],
        mainAxisAlignment: _message.whom == clientID
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
      );
    }).toList();

    final serverName = widget.server.name ?? "Unknown";
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.purple[500],
            title: (isConnecting
                ? Text('Connecting chat to ' + serverName + '...')
                : isConnected
                    ? Text('Live chat with ' + serverName)
                    : Text('Chat log with ' + serverName))),
        body: ListView(children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 370,
                height: 600,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    //// Here starts the code inside the card
                    ///
                    ///
                    Container(
                      margin: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 50,
                          ),
                          Text('Enter the number of cycles'),
                          Container(
                              margin: const EdgeInsets.only(top: 30),
                              padding: const EdgeInsets.all(5),
                              width: double.infinity,
                              child: SfSlider(
                                min: 20,
                                max: 200,
                                value: _value,
                                interval: 20,
                                stepSize: 20.0,
                                showTicks: true,
                                showLabels: true,
                                minorTicksPerInterval: 0,
                                onChanged: (dynamic value) {
                                  if (isConnected) {
                                    setState(() {
                                      _value = value;
                                    });
                                    if (_value == 20) {
                                      final speed1 = {'speed': _value};
                                      // _sendMessage(encoder.convert(speed1));
                                    } else if (_value == 40) {
                                      final speed1 = {'speed': _value};
                                      // _sendMessage(encoder.convert(speed1));
                                    } else if (_value == 60) {
                                      final speed1 = {'speed': _value};
                                      // _sendMessage(encoder.convert(speed1));
                                    } else if (_value == 80) {
                                      final speed1 = {'speed': _value};
                                      // _sendMessage(encoder.convert(speed1));
                                    } else if (_value == 100) {
                                      final speed1 = {'speed': _value};
                                      // _sendMessage(encoder.convert(speed1));
                                    } else if (_value == 120) {
                                      final speed1 = {'speed': _value};
                                      // _sendMessage(encoder.convert(speed1));
                                    } else if (_value == 140) {
                                      final speed1 = {'speed': _value};
                                      // _sendMessage(encoder.convert(speed1));
                                    } else if (_value == 160) {
                                      final speed1 = {'speed': _value};
                                      // _sendMessage(encoder.convert(speed1));
                                    } else if (_value == 180) {
                                      final speed1 = {'speed': _value};
                                      // _sendMessage(encoder.convert(speed1));
                                    } else if (_value == 200) {
                                      final speed1 = {'speed': _value};
                                      // _sendMessage(encoder.convert(speed1));
                                    }
                                  }
                                },
                              )),
                          // Divider(),

                          //neww

                          Column(
                            children: [
                              // SizedBox(
                              //   height: 30,
                              // )
                            ],
                          ),

                          Container(
                              margin: const EdgeInsets.all(8),
                              child: Column(
                                children: [
                                  // Text('Enter no. of cycles'),
                                  // HorizontalPicker(
                                  //   minValue: 1,
                                  //   maxValue: 200,
                                  //   divisions: 200,
                                  //   height: 80,
                                  //   // suffix: " \u00b0C",
                                  //   showCursor: false,
                                  //   backgroundColor: Colors.lightBlue.shade50,
                                  //   activeItemTextColor: Colors.blue.shade800,
                                  //   passiveItemsTextColor: Colors.blue.shade300,
                                  //   onChanged: (dynamic value) {
                                  //     if (isConnected) {
                                  //       setState(() {
                                  //         _time = time;
                                  //         final time2 = {'time': _time};
                                  //         _sendMessage(encoder.convert(time2));
                                  //       });
                                  //       _time = value;
                                  //       final datas = {
                                  //         'time': _time.toString()
                                  //       };
                                  //       // _sendMessage('time:'+_time.toString());
                                  //       // _sendMessage(encoder.convert(datas));
                                  //     }
                                  //   },
                                  // ),
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: 25,
                                      )
                                    ],
                                  ),
                                  // SpinBox(
                                  //   min: 1,
                                  //   max: 200,
                                  //   value: 30,
                                  //   // onChanged: (value) => print(value),
                                  //   onChanged: (dynamic value) {
                                  //     if (isConnected) {
                                  //       // setState(() {
                                  //       //   _time = time;
                                  //       //   final time2={'time':_time};
                                  //       //   _sendMessage(encoder.convert(time2));
                                  //       // });
                                  //       _time = value;
                                  //       final datas = {
                                  //         'time': _time.toString()
                                  //       };
                                  //       // _sendMessage('time:'+_time.toString());
                                  //       // _sendMessage(encoder.convert(datas));
                                  //     }
                                  //   },
                                  // ),
                                  Padding(padding: const EdgeInsets.all(16.0)),
                                  Text('Choose Exercise Mode'),
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: 25,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: RadioListTile(
                                          title: Text(
                                            "Slow",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          value: "1",
                                          groupValue: mode,
                                          onChanged: (value) {
                                            setState(() {
                                              mode = value.toString();
                                              final modev = {'mode': mode};
                                              // _sendMessage(encoder.convert(modev));
                                            });
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: RadioListTile(
                                          title: Text(
                                            "Med",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          value: "2",
                                          groupValue: mode,
                                          onChanged: (value) {
                                            setState(() {
                                              mode = value.toString();
                                              final modev = {'mode': mode};
                                              // _sendMessage(encoder.convert(modev));
                                            });
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: RadioListTile(
                                          title: Text(
                                            "Fast",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          value: "3",
                                          groupValue: mode,
                                          onChanged: (value) {
                                            setState(() {
                                              mode = value.toString();
                                              final modev = {'mode': mode};
                                              // _sendMessage(encoder.convert(modev));
                                            });
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              )),

                          Column(
                            children: [
                              SizedBox(
                                height: 20,
                              )
                            ],
                          ),

                          Container(
                            height: 50.0,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.purpleAccent,
                                  Colors.purpleAccent
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            child: InkWell(
                              onTap: () async {
                                if (isConnected) {
                                  final data2 = {
                                    'data': {
                                      'state': '1',
                                      // 'time': time,
                                      'mode': mode,
                                      'cycle': _value.toInt()
                                    }
                                  };
                                  _sendMessage(encoder.convert(data2));
                                  overflow:
                                  TextOverflow.ellipsis;

                                  print(data2);
                                }
                              },
                              child: Center(
                                child: Text(
                                  'Start',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // ElevatedButton(
                          //   onPressed: () async {
                          //     if (isConnected) {
                          //       final data2 = {
                          //         'data': {
                          //           'state': 'true',
                          //           'time': _time,
                          //           'mode': mode,
                          //           // 'cycle': _value
                          //         }
                          //       };
                          //       _sendMessage(encoder.convert(data2));

                          //       overflow:
                          //       TextOverflow.ellipsis;

                          //       print(data2);
                          //     }
                          //   },
                          //   child: Text('     Start     '),
                          //   style: ElevatedButton.styleFrom(
                          //     primary: Colors.white,
                          //     // shape: const RoundedRectangleBorder(
                          //     //     borderRadius: BorderRadius.all(
                          //     //         Radius.circular(10))),
                          //     fixedSize: Size(800, 50),
                          //     elevation: 5,
                          //     backgroundColor: Colors.purple[
                          //         400], //elevated btton background color
                          //   ),
                          // ),
                          SizedBox(height: 10),
                          // Text(_messageBuffer),

                          // FloatingActionButton(
                          //   onPressed: () {
                          //     setState(() {
                          //       _messageBuffer;
                          //     });
                          //     // Add your onPressed code here!
                          //   },
                          //   splashColor: Color.fromARGB(255, 255, 140, 0),
                          //   backgroundColor: Colors.green,
                          //   child: const Icon(Icons.refresh_rounded),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),

          //end of send data page

          //this is the code for result page
          // Column(
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
          //     Container(
          //       width: 370,
          //       height: 600,
          //       child: Card(
          //         elevation: 10,
          //         shape: RoundedRectangleBorder(
          //           side: BorderSide(
          //             color: Theme.of(context).colorScheme.outline,
          //           ),
          //           borderRadius: const BorderRadius.all(Radius.circular(12)),
          //         ),
          //         child: Column(
          //           mainAxisSize: MainAxisSize.min,
          //           children: <Widget>[
          //             SizedBox(height: 10),
          //             Text("Resutlt goes here"),
          //             Text(_messageBuffer),
          //             FloatingActionButton(
          //               onPressed: () {
          //                 setState(() {
          //                   _messageBuffer;
          //                 });
          //                 // Add your onPressed code here!
          //               },
          //               // splashColor: Color.fromARGB(255, 255, 140, 0),
          //               // backgroundColor: Colors.green,
          //               child: const Icon(Icons.refresh_rounded),
          //             ),
          //           ],
          //         ),
          //       ),
          //     )
          //   ],
          // )
        ]));
  }

  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(13);
    if (~index != 0) {
      setState(() {
        messages.add(
          _Message(
            1,
            backspacesCounter > 0
                ? _messageBuffer.substring(
                    0, _messageBuffer.length - backspacesCounter)
                : _messageBuffer + dataString.substring(0, index),
          ),
        );
        _messageBuffer = dataString.substring(index);
      });
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }
  }

  void _sendMessage(String text) async {
    text = text.trim();
    textEditingController.clear();

    if (text.length > 0) {
      try {
        connection!.output.add(Uint8List.fromList(utf8.encode(text + "\r\n")));
        await connection!.output.allSent;

        setState(() {
          messages.add(_Message(clientID, text));
        });

        Future.delayed(Duration(milliseconds: 333)).then((_) {
          listScrollController.animateTo(
              listScrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 333),
              curve: Curves.easeOut);
        });
      } catch (e) {
        // Ignore error, but notify state
        setState(() {});
      }
    }
  }
}
