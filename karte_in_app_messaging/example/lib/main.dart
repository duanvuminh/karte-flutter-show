import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:karte_core/karte_core.dart';
import 'package:karte_in_app_messaging/karte_in_app_messaging.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: <String, WidgetBuilder>{
        '/a': (BuildContext context) => const MyPage(title: 'waite 5 minutes'),
      },
      home: Home(),
    );
  }
}

class MyPage extends StatelessWidget {
  final String title;

  const MyPage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(title),
    );
  }
}

class Home extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _Home();
}

class _Home extends State<Home>{
  bool _isPresenting = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    bool isPresenting;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      isPresenting = await InAppMessaging.isPresenting;
    } on PlatformException {
      isPresenting = false;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _isPresenting = isPresenting;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KARTE InAppMessaging example app'),
      ),
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('isPresenting:  $_isPresenting'),
            ElevatedButton(
              onPressed: () => initPlatformState(),
              child: Text("checkPresent"),
            ),
            ElevatedButton(
              onPressed: () => InAppMessaging.dismiss(),
              child: Text("dismiss"),
            ),
            ElevatedButton(
              onPressed: () => InAppMessaging.suppress(),
              child: Text("suppress"),
            ),
            ElevatedButton(
              onPressed: () => InAppMessaging.unsuppress(),
              child: Text("unsuppress"),
            ),
            ElevatedButton(
              onPressed: () => Tracker.view("hello"),
              child: Text("say hello"),
            ),
            ElevatedButton(
              onPressed: () => Tracker.identify({
                "user_id": "08020018"
              }),
              child: Text("login"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed("/a"),
              child: Text("Go page A"),
            ),
          ],
        ),
      ),
    );
  }
}