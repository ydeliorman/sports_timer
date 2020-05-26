import 'package:flutter/material.dart';
import 'package:sportstimer/screens/start_screen.dart';
import 'package:sportstimer/utils/number_picker_formatter.dart';
import 'package:sportstimer/widgets/number_picker.dart';

import 'expanded_section.dart';

class WorkoutItem extends StatefulWidget {
  final Function toggleExpand;
  String value = "3";
  bool isExpanded = false;
  String name;
  StartScreenState parent;

  WorkoutItem({
    @required this.value,
    @required this.name,
    @required this.toggleExpand,
    @required this.isExpanded,
    @required this.parent,
  });

  @override
  WorkoutItemState createState() => WorkoutItemState();
}

class WorkoutItemState extends State<WorkoutItem> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        return Column(
          children: <Widget>[
            InkWell(
              onTap: () {
                if (widget.name == "SETS") {
                  widget.toggleExpand(1);
                } else if (widget.name == "WORK") {
                  widget.toggleExpand(2);
                } else {
                  widget.toggleExpand(3);
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    widget.name,
                    style: TextStyle(fontSize: constraints.maxWidth * 0.065),
                  ),
                  Spacer(),
                  widget.name == "SETS"
                      ? Text(
                          widget.value,
                          style: TextStyle(
                              fontSize: constraints.maxWidth * 0.065,
                              color: Colors.blueAccent),
                        )
                      : Text(
                          NumberPickerFormatter.gatherTimeForRichText(
                                  widget.value)[0] +
                              ":" +
                              NumberPickerFormatter.gatherTimeForRichText(
                                  widget.value)[1],
                          style: TextStyle(
                              fontSize: constraints.maxWidth * 0.065,
                              color: Colors.blueAccent),
                        ),
                ],
              ),
            ),
            ExpandedSection(
              expand: widget.isExpanded,
              child: StartScreenItem(
                widget.name,
                widget.value,
                this,
              ),
            ),
          ],
        );
      },
    );
  }
}
