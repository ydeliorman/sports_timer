import 'package:flutter/material.dart';
import 'package:nice_button/nice_button.dart';
import 'package:provider/provider.dart';
import 'package:sportstimer/models/timer_detail_model.dart';
import 'package:sportstimer/providers/timer_detail_provider.dart';
import 'package:sportstimer/screens/timer_screen.dart';
import 'package:sportstimer/widgets/UtilityWidget.dart';
import 'package:sportstimer/widgets/start_screen_item.dart';

class StartScreen extends StatefulWidget {
  static String route = '/StartScreen';

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  TextEditingController _textFieldController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String presetName;
  String sets = "3";
  String work = "0.3";
  String rest = "0.05";
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
            Provider.of<TimerProvider>(context, listen: false).getTimerData());
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
                onPressed: ()  {
                  addTimerDetail();
                  Navigator.of(ctx).pop();
                }),
          ],
        ),
      ),
    );
  }

  void addTimerDetail() {
    _timerData = Provider.of<TimerProvider>(context, listen: false).getTimerData();

    TimerDetailModel timerDetailModel = TimerDetailModel(
      presetName: _textFieldController.text,
      sets: _timerData['sets'],
      restDuration: _timerData['rest'],
      workDuration: _timerData['work'],
    );

    Provider.of<TimerProvider>(context, listen: false).addTimerDetail(timerDetailModel);
  }

  @override
  Widget build(BuildContext context) {
    const firstColor = Color(0xff5b86e5);

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
                        child: (Provider.of<TimerProvider>(context)
                                    .getTimerDetailLength() >
                                0
                            ? Consumer<TimerProvider>(
                                builder: (context, timerDetails, child) =>
                                    ListView.builder(
                                      shrinkWrap: true,
                                  itemCount:
                                      timerDetails.getTimerDetailLength(),
                                  itemBuilder: (_, i) => Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          text("Name"),
                                          text(
                                              timerDetails
                                                  .timerDetails[i].presetName,
                                              textColor: Color(0XFF313384)),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          text("Sets"),
                                          text(
                                              timerDetails.timerDetails[i].sets,
                                              textColor: Color(0XFF313384)),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          text("Work"),
                                          text(
                                              timerDetails
                                                  .timerDetails[i].workDuration,
                                              textColor: Color(0XFF313384)),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          text("Rest"),
                                          text(
                                              timerDetails
                                                  .timerDetails[i].restDuration,
                                              textColor: Color(0XFF313384)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Container(child: Text('No Presets are saved.'),)),
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
