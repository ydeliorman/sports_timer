import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportstimer/providers/timer_detail_provider.dart';
import 'package:sportstimer/screens/start_screen.dart';
import 'package:sportstimer/screens/timer_screen.dart';

void main() => runApp(MaterialApp(
      home: MyApp(),
      theme: ThemeData(
        canvasColor: Colors.blueGrey,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        accentColor: Colors.pinkAccent,
        brightness: Brightness.dark,
      ),
    ));

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    ///if context is not used ChangeNotifierProvider.value can be used
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: TimerProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Sports Timer',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: StartScreen(),
        routes: {
          StartScreen.route: (ctx) => StartScreen(),
          TimerScreen.route: (ctx) => TimerScreen(),
        },
      ),
    );
  }
}
