import 'package:flutter/material.dart';

class VoiceSlider extends StatefulWidget {
  double sliderValue = 0;

  VoiceSlider(this.sliderValue);

  @override
  _VoiceSliderState createState() => _VoiceSliderState();
}

class _VoiceSliderState extends State<VoiceSlider> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            'Volume',
            style: TextStyle(fontSize: constraints.maxWidth * 0.065),
          ),
          Spacer(),
          Container(
            width: constraints.maxWidth * 0.7,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.blue[700],
                inactiveTrackColor: Colors.blue[100],
                trackShape: RectangularSliderTrackShape(),
                trackHeight: 4.0,
                thumbColor: Colors.blueAccent,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                overlayColor: Colors.red.withAlpha(32),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
              ),
              child: Slider(
                value: widget.sliderValue,
                onChanged: (value) {
                  setState(() {
                    widget.sliderValue = value;
                  });
                },
              ),
            ),
          ),
        ],
      );
    });
  }
}
