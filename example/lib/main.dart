import 'package:example/increment_counter_event.dart';
import 'package:flutter/material.dart';
import 'package:mtc_analytics/mtc_analytics.dart';

void main() {
  AnalyticsService analyticsService = AnalyticsService.instance;
  List<Tracker> trackers = [ConsoleTracker()];
  analyticsService.init(trackers);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Analytics Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Analytics Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  void initState() {
    AnalyticsService.instance.setUserProperties(
      {
        "name": "MTC - Flutter Team",
        "email": "team@mtc-flutter.com",
      },
    );

    super.initState();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });

    AnalyticsService.instance.track(
      IncrementCounterEvent(count: _counter),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
