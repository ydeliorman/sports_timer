import 'package:flutter/material.dart';
import 'package:nice_button/nice_button.dart';
import 'package:sportstimer/widgets/start_screen_item.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sports Timer'),
        ),
        body: new Material(
          child: new Center(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    StartScreenItem("SETS"),
                    StartScreenItem("WORK"),
                    StartScreenItem("REST"),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
