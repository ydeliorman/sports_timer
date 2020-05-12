import 'package:flutter/material.dart';
import 'package:nice_button/nice_button.dart';
import 'package:provider/provider.dart';
import 'package:sportstimer/models/timer_detail_model.dart';
import 'package:sportstimer/providers/timer_detail_provider.dart';
import 'package:sportstimer/screens/timer_screen.dart';
import 'package:sportstimer/utils/number_picker_formatter.dart';
import 'package:sportstimer/widgets/start_screen_item.dart';

class StartScreen extends StatefulWidget {
  static String route = '/StartScreen';

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String id;
  String sets = "3";
  String work = "0.3";
  String rest = "0.05";
  List<TimerDetailModel> timerDetails = [];

  void _startWorkout() {
    _formKey.currentState.save();

    Navigator.of(context).pushNamed(TimerScreen.route,
        arguments:
            Provider.of<TimerProvider>(context, listen: false).getTimerData());
  }

  void fetchSavedData() {
    timerDetails =
        Provider.of<TimerProvider>(context, listen: true).timerDetails;
    if (timerDetails.length > 0) {
      sets = timerDetails[0].sets;
      work = timerDetails[0].workDuration;
      rest = timerDetails[0].restDuration;
    }
  }

  void addTimerDetail() {
    int i = 1;

    TimerDetailModel timerDetailModel = TimerDetailModel(
      id: "Configuration $i/3",
      sets: sets,
      restDuration: rest,
      workDuration: work,
    );

    i++;

    Provider.of<TimerProvider>(context, listen: false).addTimerDetail(timerDetailModel);
  }

  @override
  void didChangeDependencies() {
    fetchSavedData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    const firstColor = Color(0xff5b86e5);

    return Scaffold(
      body: new SafeArea(
        child: new Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 50,
                      child: PageView(
                        children: <Widget>[
                          Slider(textName: "Configuration 1/3"),
                          Slider(textName: "Configuration 2/3"),
                          Slider(textName: "Configuration 3/3"),
                        ],
                        onPageChanged: (index) {
                          setState(() {
                            sets = timerDetails[index].sets;
                            work = timerDetails[index].workDuration;
                            rest = timerDetails[index].restDuration;
                          });
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text('Sets'),
                        Spacer(),
                        Text(sets),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text('Work'),
                        Spacer(),
                        Text(NumberPickerFormatter.gatherTimeForRichText(
                                work)[0] +
                            ":" +
                            NumberPickerFormatter.gatherTimeForRichText(
                                work)[1]),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text('Rest'),
                        Spacer(),
                        Text(NumberPickerFormatter.gatherTimeForRichText(
                                rest)[0] +
                            ":" +
                            NumberPickerFormatter.gatherTimeForRichText(
                                rest)[1]),
                      ],
                    ),
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
                    FloatingActionButton(onPressed: addTimerDetail,)
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

class Slider extends StatelessWidget {
  final String textName;

  Slider({Key key, @required this.textName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        height: 50,
        width: double.infinity,
        padding: EdgeInsets.only(left: 16, right: 16, top: 16),
        child: Text(
          textName,
          style: TextStyle(color: Colors.grey),
        ));
  }
}
