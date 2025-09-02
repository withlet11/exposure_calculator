/*
 * sliding_scale_slider.dart
 *
 * Copyright 2025 Yasuhiro Yamakawa <withlet11@gmail.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software
 * and associated documentation files (the "Software"), to deal in the Software without restriction,
 * including without limitation the rights to use, copy, modify, merge, publish, distribute,
 * sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or
 * substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
 * BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
 * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import 'dart:math';

import 'package:flutter/material.dart';

const evStepVisualRatio = 1 / 3.5;

class _SlidingScalePainter extends CustomPainter {
  final double value;
  final double minValue;
  final double maxValue;
  final int evStep;
  final String Function(int index) indexToValueMapper;

  static const double _defaultTextMaxWidth = 40.0;
  static const int _stripeInterval = 3;
  static const int _stripeLightnessMax = 32;
  static const int _labelLightnessMax = 255;

  final _backgroundPaint = Paint()
    ..color = Colors.black26
    ..style = PaintingStyle.fill;

  final _backgroundStroke = Paint()
    ..color = Colors.white24
    ..strokeWidth = 1.0
    ..style = PaintingStyle.stroke;

  final _centerLineStroke = Paint()
    ..color = Colors.white
    ..strokeWidth = 1.5
    ..style = PaintingStyle.stroke;

  final _stripePainter = Paint()
    ..strokeWidth = 1.0
    ..style = PaintingStyle.stroke;

  final _textPainter = TextPainter(
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
  );

  _SlidingScalePainter({
    required this.value,
    required this.minValue,
    required this.maxValue,
    required this.evStep,
    required this.indexToValueMapper,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final center = width * 0.5;

    final currentIndex = value.round();
    final shift = currentIndex - value;
    final evStepInterval = width * evStepVisualRatio;

    // Draw the background
    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), _backgroundPaint);

    // Draw stripes
    const stripeInterval = _stripeInterval;

    for (double x =
            -center + (shift / evStep * evStepInterval) % stripeInterval;
        x < center;
        x += stripeInterval) {
      final lightness =
          _lightnessFromCenter(x, evStepInterval, _stripeLightnessMax);
      _stripePainter.color =
          Color.fromARGB(_labelLightnessMax, lightness, lightness, lightness);

      canvas.drawLine(
          Offset(center + x, 0), Offset(center + x, height), _stripePainter);
    }

    // Draw the frame
    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), _backgroundStroke);

    // Draw the center line
    canvas.drawLine(
        Offset(center, 0), Offset(center, height), _centerLineStroke);

    // Draw value labels
    for (int i = -evStep; i <= evStep; ++i) {
      final index = currentIndex + i;
      if (index >= minValue && index <= maxValue) {
        final x = (i + shift) / evStep * evStepInterval;
        final text = index % evStep == 0 ? indexToValueMapper(index) : '\u2022';
        final fontSize = text.length < 4 ? 18.0 : 72 / text.length;
        final lightness = _lightnessFromCenter(x, evStepInterval, 255);

        final textStyle = TextStyle(
          color: Color.fromARGB(255, lightness, lightness, lightness),
          fontSize: fontSize,
          fontWeight: FontWeight.w300,
        );

        final textSpan = TextSpan(text: text, style: textStyle);
        _textPainter.text = textSpan;
        _textPainter.layout(minWidth: 0, maxWidth: _defaultTextMaxWidth);

        final offset = Offset(center - _textPainter.width * 0.5 + x,
            (height - _textPainter.height) * 0.5);

        _textPainter.paint(canvas, offset);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SlidingScalePainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.minValue != minValue ||
        oldDelegate.maxValue != maxValue ||
        oldDelegate.evStep != evStep ||
        oldDelegate.indexToValueMapper != indexToValueMapper;
  }

  int _lightnessFromCenter(double x, double base, int maxValue) =>
      max(maxValue * cos(x / base), 0.0).toInt();
}

class SlidingScaleSlider extends StatefulWidget {
  final double initialValue;
  final double initialMinValue;
  final double initialMaxValue;
  final int initialEvStep;
  final void Function(double value)? onChanged;
  final String Function(int index) indexToValueMapper;
  final double Function(int index) indexToEvMapper;

  const SlidingScaleSlider({
    super.key,
    required this.initialValue,
    required this.initialMinValue,
    required this.initialMaxValue,
    required this.initialEvStep,
    required this.onChanged,
    required this.indexToValueMapper,
    required this.indexToEvMapper,
  });

  @override
  State<SlidingScaleSlider> createState() => _SlidingScaleSliderState();
}

class _SlidingScaleSliderState extends State<SlidingScaleSlider> {
  late double _currentValue;
  late double _currentMinValue;
  late double _currentMaxValue;
  late int _currentEvStep;
  double _dragStartValue = 0.0;
  double? _dragStartPositionX;

  static const double _defaultHeight = 40.0;

  @override
  void initState() {
    super.initState();
    _currentValue = 0.0; // It's a dummy value.
    _currentMinValue = widget.initialMinValue;
    _currentMaxValue = widget.initialMaxValue;
    _currentEvStep = widget.initialEvStep;
    _updateStateFromNewValue(widget.initialValue, notifyParent: false);
  }

  @override
  void didUpdateWidget(covariant SlidingScaleSlider oldWidget) {
    super.didUpdateWidget(oldWidget);

    bool rangeOrStepChanged = _currentMinValue != widget.initialMinValue ||
        _currentMaxValue != widget.initialMaxValue ||
        _currentEvStep != widget.initialEvStep;

    bool externalValueChanged = widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != _currentValue.roundToDouble();

    if (rangeOrStepChanged) {
      _currentMinValue = widget.initialMinValue;
      _currentMaxValue = widget.initialMaxValue;
      _currentEvStep = widget.initialEvStep;
      _updateStateFromNewValue(widget.initialValue, notifyParent: false);
    } else if (externalValueChanged) {
      _updateStateFromNewValue(widget.initialValue, notifyParent: false);
    }
  }

  void _updateStateFromNewValue(double newValue, {bool notifyParent = true}) {
    final clampedValue = newValue.clamp(_currentMinValue, _currentMaxValue);

    if (_currentValue != clampedValue) {
      setState(() {
        _currentValue = clampedValue;
      });

      if (notifyParent && widget.onChanged != null) {
        widget.onChanged!(clampedValue);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final sliderWidth = constraints.maxWidth;
        final evStepWidth = sliderWidth * evStepVisualRatio;

        void handleInteraction(Offset localPosition) {
          double newIndex = _dragStartPositionX == null
              ? _currentValue
              : _dragStartValue -
                  ((localPosition.dx - _dragStartPositionX!) /
                      (evStepWidth / _currentEvStep));

          final clampedNewIndex =
              newIndex.clamp(_currentMinValue, _currentMaxValue);

          if (_currentValue != clampedNewIndex) {
            setState(() {
              _currentValue = clampedNewIndex;
            });
            if (widget.onChanged != null) {
              widget.onChanged!(clampedNewIndex);
            }
          }
        }

        return GestureDetector(
          onPanStart: (DragStartDetails details) {
            final RenderBox renderBox = context.findRenderObject() as RenderBox;
            _dragStartPositionX =
                renderBox.globalToLocal(details.globalPosition).dx;
            _dragStartValue = _currentValue;
          },
          onPanUpdate: (DragUpdateDetails details) {
            final RenderBox renderBox = context.findRenderObject() as RenderBox;
            final Offset localPosition =
                renderBox.globalToLocal(details.globalPosition);
            handleInteraction(localPosition);
          },
          onPanEnd: (DragEndDetails details) {
            _dragStartPositionX = null;
            final double snappedValue =
                _currentValue.roundToDouble(); // Or custom snapping logic
            if (_currentValue != snappedValue) {
              _updateStateFromNewValue(snappedValue, notifyParent: true);
            }
          },
          onPanCancel: () {
            _dragStartPositionX = null;
          },
          child: CustomPaint(
            size: Size(sliderWidth, _defaultHeight),
            painter: _SlidingScalePainter(
              value: _currentValue,
              minValue: _currentMinValue,
              maxValue: _currentMaxValue,
              evStep: _currentEvStep,
              indexToValueMapper: widget.indexToValueMapper,
            ),
          ),
        );
      },
    );
  }
}
