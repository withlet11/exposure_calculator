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

class ExposureSlider extends StatelessWidget {
  final String title;
  final double value;
  final String label;
  final int index;
  final int minIndex;
  final int maxIndex;
  final void Function(double)? onChanged;

  const ExposureSlider({
    super.key,
    required this.title,
    required this.value,
    required this.label,
    required this.index,
    required this.minIndex,
    required this.maxIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$title [${value.toStringAsFixed(1).padLeft(5)}]'),
          Text(label, style: Theme.of(context).textTheme.headlineSmall),
        ],
      ),
      Slider(
        value: (index - minIndex).toDouble(),
        max: (maxIndex - minIndex).toDouble(),
        divisions: maxIndex - minIndex,
        onChanged: onChanged,
      ),
    ]);
  }
}
