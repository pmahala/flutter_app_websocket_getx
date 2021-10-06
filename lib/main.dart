import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({required this.title});

  final HomeScreenController controller = Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StreamBuilder(
              stream: controller._channel.stream,
              builder: (context, snapshot) {
                return Text(
                    snapshot.hasData ? '${snapshot.data}' : 'NOTHING!!');
              },
            ),
            Text('Press the button below to ping server'),
            TextButton(
              onPressed: () {
                controller.sendMessageToServer();
              },
              child: Container(
                color: Colors.green,
                width: 100,
                height: 50,
                child: Center(
                  child: Text(
                    'PING',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            Text(
              'You have pushed the button this many times:',
            ),
            Obx(
              () => Text(
                '${controller._counter}',
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class HomeScreenController extends GetxController {
  var _counter = 0.obs;

  final _channel = WebSocketChannel.connect(
    Uri.parse(
        'wss://free3.piesocket.com/v3/1?api_key=MiqAw3lDoclyG8MAuMNguVPof7CPtefqn0ybdCUh&notify_self'),
  );

  void incrementCounter() {
    _counter++;
  }

  void sendMessageToServer() {
    _channel.sink.add('PING FROM SERVER');
  }

  @override
  void onClose() {
    // TODO: implement onClose
    _channel.sink.close();
    super.onClose();
  }
}
