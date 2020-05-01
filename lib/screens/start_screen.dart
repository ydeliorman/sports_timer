import 'package:flutter/material.dart';
import 'package:nice_button/nice_button.dart';
import 'package:provider/provider.dart';
import 'package:sportstimer/providers/timer.dart';
import 'package:sportstimer/screens/timer_screen.dart';
import 'package:sportstimer/widgets/T6Widget.dart';
import 'package:sportstimer/widgets/start_screen_item.dart';

class StartScreen extends StatefulWidget {
  static String route = '/StartScreen';

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  TextEditingController _textFieldController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Map<String, String> _timerData = {
    'presetName': '',
    'sets': '',
    'work': '',
    'rest': '',
  };

  void _startWorkout() {
    _formKey.currentState.save();

    Navigator.of(context).pushNamed(TimerScreen.route,
        arguments:
            Provider.of<TimerDetail>(context, listen: false).getTimerData());
  }

  void _showDialog() {
    showDialog<String>(
      context: context,
      builder: (ctx) => new _SystemPadding(
        child: new AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: new Row(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                  controller: _textFieldController,
                  autofocus: true,
                  decoration: new InputDecoration(labelText: 'Preset Name'),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            new FlatButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                }),
            new FlatButton(
                child: const Text('SAVE'),
                onPressed: () {
                  var presetName = _textFieldController.text;
                  Provider.of<TimerDetail>(context, listen: false)
                      .storeWorkOutInfo(presetName);
                  Navigator.of(ctx).pop();
                  setState(() {});
                }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const firstColor = Color(0xff5b86e5);
    Map<String, String> timerData =
        Provider.of<TimerDetail>(context, listen: false).getTimerData();

    String sets = timerData['sets'];
    String work = timerData['work'];
    String rest = timerData['rest'];

    return Scaffold(
      body: new Material(
        child: new Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    StartScreenItem(
                      "SETS",
                      sets,
                    ),
                    StartScreenItem(
                      "WORK",
                      work,
                    ),
                    StartScreenItem(
                      "REST",
                      rest,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.save),
                          onPressed: () {
                            _showDialog();
                          },
                        ),
                      ],
                    ),
                    const Divider(),
                    NiceButton(
                      width: 255,
                      elevation: 8.0,
                      radius: 52.0,
                      text: "Start",
                      background: firstColor,
                      icon: Icons.accessibility,
                      onPressed: _startWorkout,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 16, top: 16, right: 16),
                      decoration: boxDecoration(
                          radius: 16,
                          showShadow: true,
                          bgColor: Color(0XFFffffff)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            text(
                              "sets",
                              textColor: Color(0XFF464545),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                text("rest"),
                                text("rest value",
                                    textColor: Color(0XFF313384)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                text("rest"),
                                text("work", textColor: Color(0XFF313384)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SystemPadding extends StatelessWidget {
  final Widget child;

  _SystemPadding({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return new AnimatedContainer(
        padding: mediaQuery.viewInsets,
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}
