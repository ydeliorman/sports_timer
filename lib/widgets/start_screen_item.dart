import 'package:flutter/material.dart';
import 'package:nice_button/NiceButton.dart';

class StartScreenItem extends StatefulWidget {
  final String title;

  const StartScreenItem(this.title) ;

  @override
  _StartScreenItemState createState() => _StartScreenItemState();
}

class _StartScreenItemState extends State<StartScreenItem> {
  var firstColor = Color(0xff5b86e5),
      secondColor = Color(0xff36d1dc);


  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(
          child: Text(widget.title),
        ),
        Row(
          children: <Widget>[
            NiceButton(
              width: 25,
              radius: 20,
              elevation: 5,
              mini: true,
              icon: Icons.remove,
              gradientColors: [secondColor, firstColor],
              onPressed: () {},
            ),
            Expanded(
              child: TextFormField(
                initialValue: "5",
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {},
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a value.';
                  }
                  return null;
                },
              ),
            ),
            NiceButton(
              width: 25,
              radius: 20,
              elevation: 5,
              mini: true,
              icon: Icons.add,
              gradientColors: [secondColor, firstColor],
              onPressed: () {},
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
