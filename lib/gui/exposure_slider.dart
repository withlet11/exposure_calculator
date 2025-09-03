/*
 * exposure_slider.dart
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

import 'package:flutter/material.dart';

import 'sliding_scale_slider.dart';

class ExposureSlider extends StatefulWidget {
  final String title;
  final int initialIndex;
  final int initialMinIndex;
  final int initialMaxIndex;
  final int initialStep;
  final void Function(double)? onChanged;
  final String Function(int index) labelBuilder;
  final String Function(int index) indexToValueMapper;
  final double Function(int index) indexToEvMapper;

  const ExposureSlider({
    super.key,
    required this.title,
    required this.initialIndex,
    required this.initialMinIndex,
    required this.initialMaxIndex,
    required this.initialStep,
    required this.onChanged,
    required this.labelBuilder,
    required this.indexToValueMapper,
    required this.indexToEvMapper,
  });

  @override
  State<ExposureSlider> createState() => _ExposureSliderState();
}

class _ExposureSliderState extends State<ExposureSlider> {
  late double _currentValue;
  late int _currentMinIndex;
  late int _currentMaxIndex;
  late int _currentStep;
  late String _currentEvText;
  late String _currentValueText;

  @override
  void initState() {
    super.initState();
    _currentValue = 0.0; // It's a dummy value.
    _currentMinIndex = widget.initialMinIndex;
    _currentMaxIndex = widget.initialMaxIndex;
    _currentStep = widget.initialStep;
    _updateStateFromNewIndex(widget.initialIndex, notifyParent: false);
  }

  @override
  void didUpdateWidget(covariant ExposureSlider oldWidget) {
    super.didUpdateWidget(oldWidget);

    bool rangeChanged = (_currentMinIndex != widget.initialMinIndex ||
        _currentMaxIndex != widget.initialMaxIndex ||
        _currentStep != widget.initialStep);

    bool indexChanged = widget.initialIndex != oldWidget.initialIndex;

    if (rangeChanged || indexChanged) {
      _currentMinIndex = widget.initialMinIndex;
      _currentMaxIndex = widget.initialMaxIndex;
      _currentStep = widget.initialStep;
      _updateStateFromNewIndex(widget.initialIndex, notifyParent: false);
    } else if (widget.indexToValueMapper != oldWidget.indexToValueMapper ||
        widget.indexToEvMapper != oldWidget.indexToEvMapper) {
      setState(() {
        _currentEvText = _makeEVText(widget.initialIndex);
        _currentValueText = _makeValueText(widget.initialIndex);
      });
    }
  }

  void _updateStateFromNewIndex(int newIndex, {bool notifyParent = true}) {
    final clampedIndex = newIndex.clamp(_currentMinIndex, _currentMaxIndex);
    final newValue = clampedIndex.toDouble();

    if (_currentValue != newValue || !mounted) {
      final newEvText = _makeEVText(newIndex);
      final newValueText = _makeValueText(newIndex);

      if (mounted) {
        setState(() {
          _currentValue = newValue;
          _currentEvText = newEvText;
          _currentValueText = newValueText;
        });
      } else {
        _currentValue = newValue;
        _currentEvText = newEvText;
        _currentValueText = newValueText;
      }

      if (notifyParent && widget.onChanged != null) {
        widget.onChanged!(_currentValue);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(_currentEvText),
          Text(_currentValueText,
              style: Theme.of(context).textTheme.headlineSmall),
        ],
      ),
      SlidingScaleSlider(
        key: ValueKey('exposure_slider_${widget.title}'),
        initialValue: _currentValue,
        initialMinValue: _currentMinIndex.toDouble(),
        initialMaxValue: _currentMaxIndex.toDouble(),
        initialEvStep: _currentStep,
        onChanged: widget.onChanged == null
            ? null
            : (double sliderValue) {
                _updateStateFromNewIndex(sliderValue.round(),
                    notifyParent: true);
              },
        indexToValueMapper: widget.indexToValueMapper,
        indexToEvMapper: widget.indexToEvMapper,
      ),
    ]);
  }

  String _makeEVText(int index) => '${widget.title} '
      '[${widget.indexToEvMapper(index).toStringAsFixed(1).padLeft(5)}]';

  String _makeValueText(int index) => widget.labelBuilder(index);
}
