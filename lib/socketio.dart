import 'package:casting_chat_2/modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:laravel_echo/laravel_echo.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:developer' as div;
// ignore: implementation_imports
import 'package:laravel_echo/src/channel/private-channel.dart';
// ignore: implementation_imports
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
  String channelName = 'chat-channel.client';
  String event = 'message';

  @override
  void initState() {
    super.initState();

    echo = new Echo({
      'broadcaster': 'socket.io',
      'client': IO.io,
      'host': "https://s-markt.ga:6001/",
      'authEndpoint': '/broadcasting/auth',
      'auth': {
        'headers': {
          'Authorization':
              'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI5M2M2MzYzNC04MTQxLTQ4MjktOWUwZC0zYjEzYTVmMmY3OWMiLCJqdGkiOiJlYTFiMTg4Y2YxMTNiMWE2NDkzZTM0NGY5ZDcxNmI2YmVhN2I0MDdlYzE1NWVmMmNkM2E0MWE4MjQ1MjU4NTcxNTBiMTM3YzgyOWViZjZkMCIsImlhdCI6MTYyNDgwMDQ0MS4yMjMxNjQwODE1NzM0ODYzMjgxMjUsIm5iZiI6MTYyNDgwMDQ0MS4yMjMxNjY5NDI1OTY0MzU1NDY4NzUsImV4cCI6MTY1NjMzNjQ0MS4yMjA1Njg4OTUzMzk5NjU4MjAzMTI1LCJzdWIiOiIyIiwic2NvcGVzIjpbXX0.nN2_1FT1XwedBg0o0zo8xIKHzn-gjO_zkjUhIQ-R-5BchcTgNlsAri83dxj3D-9pRpPRchOXckBQ9CrzCyD-MWBIPL1z80ckpd35v4QFvX8tdAH0hKQWJvfiaqnDJkA0M2g0qjuOKEUDsRPA_bVaDX8i4DvlXdyEAsjAJuzjeKlMc1nnTsDrb527lZfDmB0qNdtcMFzfN9D1EmBwF-a20spdX0TAjEfwIPasmGMreVEgKHIMrLPe0uAySqSSIcIkkSPBChOnOVIsZQICgWGJziy6TZ8_fMtMheYWdiRc5J3BXDIS2fl10suNNUjBkNelFO1-_GYKBA9Y1Z7ysXkPAN43Nrn15Lqnwmed-WcQ93V0Gdfd5PLWcw-vuZB8x0XiVrF4aRwDqeNDYxaXFQ4d-qYCPnCEFVr6N6LzL-mzO_87VOrY10A3THvrkR_wq5RQYzb-j5xwt8hLqpNp5pYxSR5FglyGUXf3JS6DAuc4NPArKUen9KOBx_jFwOZCD6smiTwvLjDJsp54aUaWpHYN3tm5G3aq6NAJ77ClI7o8oc72HJfBcnLqAqF2X52J4t7nqEBqRSY8PcmgO_YEwKK-MNh5AtQTHwu8tzwtqJgcvDnz24KELiox1bCcZsU0UwwtvrPk6OFSKjOGqAxYzhG0B8VvuzPPZytQjSfuWlhlYrg',
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
      div.log("$data");
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
