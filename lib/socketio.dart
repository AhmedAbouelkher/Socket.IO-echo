import 'dart:convert';

import 'package:casting_chat_2/modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:laravel_echo/laravel_echo.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:developer' as div;
import 'package:laravel_echo/src/channel/private-channel.dart';
import 'package:laravel_echo/src/connector/socketio-connector.dart';

class SocketioPage extends StatefulWidget {
  _SocketioPage createState() => _SocketioPage();
}

class _SocketioPage extends State<SocketioPage> {
  // ignore: deprecated_member_use
  List<String> _logs = new List();
  Echo echo;
  bool isConnected = false;
  String channelType = 'private';
  String channelName = 'chat-channel.payer.1007';
  String event = 'message';

  @override
  void initState() {
    super.initState();

    echo = new Echo({
      'broadcaster': 'socket.io',
      'client': IO.io,
      'host': 'https://wc-extra.smarian.com:6001/',
      'auth': {
        'headers': {
          'Authorization':
              'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiNGNlZDNiYzhiMGIzNjQ4Yzg3NjljNzA1NDU1NGY1MWExYTJiYzRlZGNhOTQwMDdlNTk3YWE2M2RjMWMyNDUwNTEzNGM4OWJkMTRjZTY5ZGEiLCJpYXQiOjE2MjA4MTk4MzYuMDI0MDgyLCJuYmYiOjE2MjA4MTk4MzYuMDI0MDg1LCJleHAiOjE2NTIzNTU4MzYuMDIxOTY4LCJzdWIiOiIxMDA3Iiwic2NvcGVzIjpbXX0.OBN3L4iUWr3oCU49p-04BeSGvmx3vaRFEh1ZksnqofADCnkkbbVQmoDfKHgS955ogefzCP79OqEIK_E5mq_VFsf6ZKxrrLZtkEQTsRN1o9uQCeyLu9GAhZ_rkOtfAHrJkWjC9BecyKqH9eLOTTrpuMIkLnJ3HMKstD7wq13SiVAZGOn0eWfBaNyhHdxs6kBoilAEPdp0kJ7MF9t6DzNAkpMgy-Ur_xvi16rMX_FMXCIJH0dVzL-cRH2PVnolM82dQfjrEW5yoBTuGp6lUvy0YOkNeqk2LoIe9bRhSwlTMjXGJOS8z04Sp_TjLGvEmd61_KU0t-lbYUXvMy4LpRIQIlrX0vwGLFiGnx6V1_edegDj8e0tTb27l4PpNk_X0J3Nu1rYUcBrB_yuJP5aUhzJxrS9VQreSiWIEcJv0Exofgks2E5zQ9YlljU7lOeUJshSLzCFmkHJn856pYCLeXNrzdp1NK8Jix5QkKUs2zTdFNjcuzpV9dCdfmvCJdriOE3Qu9t0ZKsVCWZ1sJ-vcaFXf7jaz7jAy22innG6uDw5sAAwn5xkDD9Kko2HUIxSsSWKkKsMO0USKGkWyhcFHneTKos-vANcsKBcBCQJSkFMQaEdOtnNs58x7cvFZNc0WZCKkBjvAdbqvnUcDIbplWSyYDWfK-fx9hyH0GyhGkt4TQo',
        }
      }
    });

    echo.socket.on('connect', (_) {
      log('connected');
      setState(() => isConnected = true);
    });

    echo.socket.on('disconnect', (_) {
      log('disconnected');

      setState(() => isConnected = false);
    });
  }

  log(String event) {
    var now = new DateTime.now();
    String formatted =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";

    setState(() {
      _logs.insert(0, "$formatted $event");
    });
  }

  void _listenToChannel(String type, String name, String event) {
    PrivateChannel _channel = echo.private(channelName);

    final _co = echo.connector as SocketIoConnector;

    print("id: ${_co.socketId()}");
    print("options: ${_co.options}");

    // final _socket = _co.socket as IO.Socket;

    // _socket.on("message", (_) {

    // });

    _channel.listen('.$event', (data) {
      div.log("${jsonEncode(data["data"])}");
    });
    print("Litening...");
  }

  // void _listenToChannel(String type, String name, String event) {
  //   dynamic channel;

  //   if (type == 'public') {
  //     channel = echo.channel(name);
  //   } else if (type == 'private') {
  //     channel = echo.private(name);
  //     final PrivateChannel _channel = channel;

  //     final _co = echo.connector as SocketIoConnector;
  //     final __ = _co.socket as IO.Socket;
  //     print("id: ${_co.socketId()}");
  //     print("options: ${_co.options}");
  //   } else if (type == 'presence') {
  //     channel = echo.join(name).here((users) {
  //       print(users);
  //     }).joining((user) {
  //       print(user);
  //     }).leaving((user) {
  //       print(user);
  //     });
  //   }
  //   print('channel: $name, event: $event, type: $type');

  //   channel.listen(event, (e) {
  //     div.log('channel: $name, event: $event');
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Flexible(
              child: Container(
                padding: EdgeInsets.all(15),
                color: Colors.grey[100],
                child: ListView.builder(
                  reverse: true,
                  itemCount: _logs.length,
                  itemBuilder: (BuildContext context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Text(_logs[index]),
                    );
                  },
                ),
              ),
            ),
            Container(
              height: 70,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey[300]),
                ),
              ),
              child: Center(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    CupertinoButton(
                      onPressed: () {
                        _listenToChannel(channelType, channelName, event);
                        return;
                        showCupertinoModalPopup<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return ChannelModal(
                              listen: true,
                              type: channelType,
                              name: channelName,
                              onTypeChanged: (value) {
                                setState(() {
                                  channelType = value;
                                });
                              },
                              onNameChanged: (value) {
                                setState(() {
                                  channelName = value;
                                });
                              },
                              onEventChanged: (value) {
                                setState(() {
                                  event = value;
                                });
                              },
                              onSubmit: () {
                                log('Listening to channel: $channelName');
                                _listenToChannel(channelType, channelName, event);
                                Navigator.of(context).pop();
                              },
                            );
                          },
                        );
                      },
                      child: Text('listen to channel'),
                    ),
                    CupertinoButton(
                      onPressed: () {
                        echo.leave(channelName);
                        print("Left...");
                        // showCupertinoModalPopup<void>(
                        //   context: context,
                        //   builder: (BuildContext context) {
                        //     return ChannelModal(
                        //       listen: false,
                        //       name: channelName,
                        //       onNameChanged: (value) {
                        //         setState(() {
                        //           channelName = value;
                        //         });
                        //       },
                        //       onSubmit: () {
                        //         log('Leaving channel: $channelName');
                        //         echo.leave(channelName);
                        //         Navigator.of(context).pop();
                        //       },
                        //     );
                        //   },
                        // );
                      },
                      child: Text('leave channel'),
                    ),
                    Visibility(
                      visible: !isConnected,
                      child: CupertinoButton(
                        onPressed: () {
                          log('connecting');
                          echo.socket.connect();
                        },
                        child: Text('connect'),
                      ),
                    ),
                    Visibility(
                      visible: isConnected,
                      child: CupertinoButton(
                        onPressed: () {
                          log('disconnecting');
                          echo.socket.disconnect();
                        },
                        child: Text('disconnect'),
                      ),
                    ),
                    CupertinoButton(
                      onPressed: () {
                        dynamic id = echo.sockedId();
                        log('socket_id: $id');
                      },
                      child: Text('get socket-id'),
                    ),
                    CupertinoButton(
                      onPressed: () {
                        setState(() {
                          _logs = [];
                        });
                      },
                      child: Text('clear log'),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
