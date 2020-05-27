import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:sportstimer/enums/StartScreenItemType.dart';
import 'package:sportstimer/providers/timer_detail_provider.dart';
import 'package:sportstimer/widgets/workout_item.dart';

class StartScreenItem extends StatefulWidget {
  final String title;
  String textFormFieldValue;
  WorkoutItemState parent;

  StartScreenItem(
    this.title,
    this.textFormFieldValue,
    this.parent,
  );

  @override
  _StartScreenItemState createState() => _StartScreenItemState();
}

class _StartScreenItemState extends State<StartScreenItem> {
  var firstColor = Color(0xff5b86e5), secondColor = Color(0xff36d1dc);

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Text(widget.title),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            widget.title == "SETS"
                ? NumberPicker.integer(
                    initialValue: int.parse(widget.textFormFieldValue),
                    minValue: 1,
                    maxValue: 20,
                    infiniteLoop: true,
                    onChanged: (value) {
                      setState(() {
                        widget.textFormFieldValue = value.toString();
                        Provider.of<TimerProvider>(context, listen: false)
                            .setTimerData(
                                value.toString(), StartScreenItemType.Sets);
                      });
                      widget.parent.setState(() {
                        widget.parent.widget.value = value.toString();
                        widget.parent.widget.parent.sets = value.toString();
                      });
                    },
                  )
                : NumberPicker.decimal(
                    initialValue: double.parse(widget.textFormFieldValue),
                    minValue: 0,
                    maxValue: 15,
                    decimalPlaces: 2,
                    onChanged: (value) {
                      if (widget.title == "WORK") {
                        setState(() {
                          Provider.of<TimerProvider>(context, listen: false)
                              .setTimerData(
                                  value.toString(), StartScreenItemType.Work);
                        });
                        widget.parent.setState(() {
                          widget.parent.widget.value = value.toString();
                          widget.parent.widget.parent.work = value.toString();
                        });
                      } else {
                        setState(() {
                          Provider.of<TimerProvider>(context, listen: false)
                              .setTimerData(
                                  value.toString(), StartScreenItemType.Rest);
                        });
                        widget.parent.setState(() {
                          widget.parent.widget.value = value.toString();
                          widget.parent.widget.parent.rest = value.toString();
                        });
                      }
                      widget.textFormFieldValue = value.toString();
                    },
                  ),
          ],
        ),
      ],
    );
  }
}
