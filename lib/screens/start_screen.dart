import 'package:flutter/material.dart';
import 'package:nice_button/nice_button.dart';
import 'package:provider/provider.dart';
import 'package:sportstimer/providers/timer.dart';
import 'package:sportstimer/screens/timer_screen.dart';
import 'package:sportstimer/widgets/start_screen_item.dart';

class StartScreen extends StatefulWidget {
  static String route = '/StartScreen';

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    const firstColor = Color(0xff5b86e5);
    Map<String, String> timerData = Provider.of<TimerDetail>(context).getTimerData();

    return Scaffold(
        body: new Material(
      child: new Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                StartScreenItem(
                  "SETS",
                  timerData['sets'],
                ),
                StartScreenItem(
                  "WORK",
                  timerData['work'],
                ),
                StartScreenItem(
                  "REST",
                  timerData['rest'],
                ),
                Divider(),
                NiceButton(
                  width: 255,
                  elevation: 8.0,
                  radius: 52.0,
                  text: "Start",
                  background: firstColor,
                  icon: Icons.accessibility,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  _submit() {
    _formKey.currentState.save();

    Navigator.of(context)
        .pushNamed(TimerScreen.route, arguments: Provider.of<TimerDetail>(context, listen: false).getTimerData());
  }
}
