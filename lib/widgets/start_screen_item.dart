import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:sportstimer/enums/StartScreenItemType.dart';
import 'package:sportstimer/providers/timer_detail_provider.dart';

class StartScreenItem extends StatefulWidget {
  final String title;
  String textFormFieldValue;

  StartScreenItem(
    this.title,
    this.textFormFieldValue,
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
            Container(
              width: 200,
              height: 140,
              child: widget.title == "SETS"
                  ? NumberPicker.integer(
                      initialValue: int.parse(widget.textFormFieldValue),
                      minValue: 1,
                      maxValue: 20,
                      infiniteLoop: true,
                      onChanged: (value) => setState(() {
                        widget.textFormFieldValue = value.toString();
                        Provider.of<TimerDetail>(context, listen: false)
                            .setTimerData(
                                value.toString(), StartScreenItemType.Sets);
                      }),
                    )
                  : NumberPicker.decimal(
                      initialValue: double.parse(widget.textFormFieldValue),
                      minValue: 0,
                      maxValue: 15,
                      decimalPlaces: 2,
                      onChanged: (value) => setState(
                        () {
                          widget.title == "WORK"
                              ? Provider.of<TimerDetail>(context, listen: false)
                                  .setTimerData(value.toString(),
                                      StartScreenItemType.Work)
                              : Provider.of<TimerDetail>(context, listen: false)
                                  .setTimerData(value.toString(),
                                      StartScreenItemType.Rest);
                          widget.textFormFieldValue = value.toString();
                        },
                      ),
                    ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
        ),
      ],
    );
  }
}
