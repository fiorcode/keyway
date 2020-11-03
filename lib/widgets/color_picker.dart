import 'package:flutter/material.dart';

class ColorPicker extends StatefulWidget {
  ColorPicker(this.color, this.change);

  final Function change;
  final int color;

  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  double _value;
  Color _color;

  _setColor(double val) {
    setState(() {
      if (val <= 85)
        _color = Color.fromARGB(255, 255, 0, (val * 3).toInt());
      else if (val <= 170)
        _color = Color.fromARGB(255, 255 - ((val - 85) * 3).toInt(), 0, 255);
      else if (val <= 255)
        _color = Color.fromARGB(255, 0, ((val - 170) * 3).toInt(), 255);
      else if (val <= 340)
        _color = Color.fromARGB(255, 0, 255, 255 - ((val - 255) * 3).toInt());
      else if (val <= 425)
        _color = Color.fromARGB(255, ((val - 340) * 3).toInt(), 255, 0);
      else if (val <= 510)
        _color = Color.fromARGB(255, 255, 255 - ((val - 425) * 3).toInt(), 0);
    });
  }

  _setValue(Color col) {
    setState(() {
      if (col.red == 255 && col.green == 0) _value = col.blue / 3;
      if (col.blue == 255 && col.green == 0) _value = (col.red / 3) + 85;
      if (col.blue == 255 && col.red == 0) _value = (col.green / 3) + 170;
      if (col.green == 255 && col.red == 0) _value = (col.blue / 3) + 255;
      if (col.green == 255 && col.blue == 0) _value = (col.red / 3) + 340;
      if (col.red == 255 && col.blue == 0) _value = (col.green / 3) + 425;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _color = Color(widget == null ? 0 : widget.color);
      _setValue(_color);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackShape: GradientRectSliderTrackShape(),
        trackHeight: 4.0,
        thumbColor: Colors.white,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
      ),
      child: Slider(
        min: 0,
        max: 510,
        value: _value == null ? 0 : _value,
        onChanged: (value) {
          setState(() {
            _value = value;
            _setColor(value);
            widget.change(_color.value);
          });
        },
      ),
    );
  }
}

class GradientRectSliderTrackShape extends SliderTrackShape
    with BaseSliderTrackShape {
  /// Create a slider track that draws two rectangles with rounded outer edges.
  const GradientRectSliderTrackShape();

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    @required RenderBox parentBox,
    @required SliderThemeData sliderTheme,
    @required Animation<double> enableAnimation,
    @required TextDirection textDirection,
    @required Offset thumbCenter,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 2,
  }) {
    assert(context != null);
    assert(offset != null);
    assert(parentBox != null);
    assert(sliderTheme != null);
    assert(sliderTheme.disabledActiveTrackColor != null);
    assert(sliderTheme.disabledInactiveTrackColor != null);
    assert(sliderTheme.activeTrackColor != null);
    assert(sliderTheme.inactiveTrackColor != null);
    assert(sliderTheme.thumbShape != null);
    assert(enableAnimation != null);
    assert(textDirection != null);
    assert(thumbCenter != null);
    // If the slider [SliderThemeData.trackHeight] is less than or equal to 0,
    // then it makes no difference whether the track is painted or not,
    // therefore the painting  can be a no-op.
    if (sliderTheme.trackHeight <= 0) {
      return;
    }

    LinearGradient gradient = LinearGradient(colors: [
      Colors.red,
      Colors.purple,
      Colors.blue,
      Colors.cyan,
      Colors.green,
      Colors.yellow,
      Colors.red,
    ]);

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    // Assign the track segment paints, which are leading: active and
    // trailing: inactive.
    final ColorTween activeTrackColorTween = ColorTween(
        begin: sliderTheme.disabledActiveTrackColor,
        end: sliderTheme.activeTrackColor);
    final ColorTween inactiveTrackColorTween = ColorTween(
        begin: sliderTheme.disabledActiveTrackColor,
        end: sliderTheme.activeTrackColor);
    final Paint activePaint = Paint()
      ..shader = gradient.createShader(trackRect)
      ..color = activeTrackColorTween.evaluate(enableAnimation);
    final Paint inactivePaint = Paint()
      ..shader = gradient.createShader(trackRect)
      ..color = inactiveTrackColorTween.evaluate(enableAnimation);
    Paint leftTrackPaint;
    Paint rightTrackPaint;
    switch (textDirection) {
      case TextDirection.ltr:
        leftTrackPaint = activePaint;
        rightTrackPaint = inactivePaint;
        break;
      case TextDirection.rtl:
        leftTrackPaint = inactivePaint;
        rightTrackPaint = activePaint;
        break;
    }

    final Radius trackRadius = Radius.circular(trackRect.height / 2);
    final Radius activeTrackRadius = Radius.circular(trackRect.height / 2 + 1);

    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        trackRect.left,
        (textDirection == TextDirection.ltr)
            ? trackRect.top - (additionalActiveTrackHeight / 2)
            : trackRect.top,
        thumbCenter.dx,
        (textDirection == TextDirection.ltr)
            ? trackRect.bottom + (additionalActiveTrackHeight / 2)
            : trackRect.bottom,
        topLeft: (textDirection == TextDirection.ltr)
            ? activeTrackRadius
            : trackRadius,
        bottomLeft: (textDirection == TextDirection.ltr)
            ? activeTrackRadius
            : trackRadius,
      ),
      leftTrackPaint,
    );
    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        thumbCenter.dx,
        (textDirection == TextDirection.rtl)
            ? trackRect.top - (additionalActiveTrackHeight / 2)
            : trackRect.top,
        trackRect.right,
        (textDirection == TextDirection.rtl)
            ? trackRect.bottom + (additionalActiveTrackHeight / 2)
            : trackRect.bottom,
        topRight: (textDirection == TextDirection.rtl)
            ? activeTrackRadius
            : trackRadius,
        bottomRight: (textDirection == TextDirection.rtl)
            ? activeTrackRadius
            : trackRadius,
      ),
      rightTrackPaint,
    );
  }
}
