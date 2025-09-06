/*
 * f_number.dart
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

import 'package:exposure_calculator/camera_parameters/abstract_parameter.dart';

import '../utilities/range.dart';
import 'constants.dart';

final class FNumber extends AbstractParameter {
  // 1st value: f-number, 2nd value: aperture value
  static const List<LabelAndValuePair> _fullStopList = [
    LabelAndValuePair('0.7', -1.0), // Start value must be an integer
    LabelAndValuePair('1.0', 0.0), // interval must be 1
    LabelAndValuePair('1.4', 1.0),
    LabelAndValuePair('2.0', 2.0),
    LabelAndValuePair('2.8', 3.0),
    LabelAndValuePair('4.0', 4.0),
    LabelAndValuePair('5.6', 5.0),
    LabelAndValuePair('8.0', 6.0),
    LabelAndValuePair('11', 7.0),
    LabelAndValuePair('16', 8.0),
    LabelAndValuePair('22', 9.0),
    LabelAndValuePair('32', 10.0),
    LabelAndValuePair('45', 11.0),
    LabelAndValuePair('64', 12.0),
    LabelAndValuePair('90', 13.0),
    LabelAndValuePair('128', 14.0),
  ];

  static const List<LabelAndValuePair> _oneHalfStopList = [
    LabelAndValuePair('0.7', -1.0), // Start value must be an integer
    LabelAndValuePair('0.8', -0.5), // Interval must be 0.5
    LabelAndValuePair('1.0', 0.0),
    LabelAndValuePair('1.2', 0.5),
    LabelAndValuePair('1.4', 1.0),
    LabelAndValuePair('1.7', 1.5),
    LabelAndValuePair('2.0', 2.0),
    LabelAndValuePair('2.4', 2.5),
    LabelAndValuePair('2.8', 3.0),
    LabelAndValuePair('3.3', 3.5),
    LabelAndValuePair('4.0', 4.0),
    LabelAndValuePair('4.8', 4.5),
    LabelAndValuePair('5.6', 5.0),
    LabelAndValuePair('6.7', 5.5),
    LabelAndValuePair('8.0', 6.0),
    LabelAndValuePair('9.5', 6.5),
    LabelAndValuePair('11', 7.0),
    LabelAndValuePair('13', 7.5),
    LabelAndValuePair('16', 8.0),
    LabelAndValuePair('19', 8.5),
    LabelAndValuePair('22', 9.0),
    LabelAndValuePair('27', 9.5),
    LabelAndValuePair('32', 10.0),
    LabelAndValuePair('38', 10.5),
    LabelAndValuePair('45', 11.0),
    LabelAndValuePair('54', 11.5),
    LabelAndValuePair('64', 12.0),
    LabelAndValuePair('76', 12.5),
    LabelAndValuePair('90', 13.0),
    LabelAndValuePair('107', 13.5),
    LabelAndValuePair('128', 14.0),
  ];

  static const List<LabelAndValuePair> _oneThirdStopList = [
    LabelAndValuePair('0.7', -1.00), // Start value must be an integer
    LabelAndValuePair('0.8', -0.67), // Interval must be 0.33
    LabelAndValuePair('0.9', -0.33),
    LabelAndValuePair('1.0', 0.00),
    LabelAndValuePair('1.1', 0.33),
    LabelAndValuePair('1.2', 0.67),
    LabelAndValuePair('1.4', 1.00),
    LabelAndValuePair('1.6', 1.33),
    LabelAndValuePair('1.8', 1.67),
    LabelAndValuePair('2.0', 2.00),
    LabelAndValuePair('2.2', 2.33),
    LabelAndValuePair('2.5', 2.67),
    LabelAndValuePair('2.8', 3.00),
    LabelAndValuePair('3.2', 3.33),
    LabelAndValuePair('3.5', 3.67),
    LabelAndValuePair('4.0', 4.00),
    LabelAndValuePair('4.5', 4.33),
    LabelAndValuePair('5.0', 4.67),
    LabelAndValuePair('5.6', 5.00),
    LabelAndValuePair('6.3', 5.33),
    LabelAndValuePair('7.1', 5.67),
    LabelAndValuePair('8.0', 6.00),
    LabelAndValuePair('9.0', 6.33),
    LabelAndValuePair('10', 6.67),
    LabelAndValuePair('11', 7.00),
    LabelAndValuePair('13', 7.33),
    LabelAndValuePair('14', 7.67),
    LabelAndValuePair('16', 8.00),
    LabelAndValuePair('18', 8.33),
    LabelAndValuePair('20', 8.67),
    LabelAndValuePair('22', 9.00),
    LabelAndValuePair('25', 9.33),
    LabelAndValuePair('29', 9.67),
    LabelAndValuePair('32', 10.00),
    LabelAndValuePair('36', 10.33),
    LabelAndValuePair('40', 10.67),
    LabelAndValuePair('45', 11.00),
    LabelAndValuePair('51', 11.33),
    LabelAndValuePair('57', 11.67),
    LabelAndValuePair('64', 12.00),
    LabelAndValuePair('72', 12.33),
    LabelAndValuePair('80', 12.67),
    LabelAndValuePair('90', 13.00),
    LabelAndValuePair('102', 13.33),
    LabelAndValuePair('114', 13.67),
    LabelAndValuePair('128', 14.00),
  ];

  FNumber({
    FractionalStop step = initFNumberStep,
    Range range = initApertureValueRange,
    double ev = preferFNumberEv,
  }) : super(_fullStopList, _oneHalfStopList, _oneThirdStopList, step, range,
            ev);

  @override
  String get currentLabel => 'f/${super.currentLabel}';

  FNumber copyWith(
      {FractionalStop? step,
      Range? valueRange,
      double? currentValue,
      int? currentIndex}) {
    return FNumber(
      step: step ?? this.step,
      range: valueRange ?? this.valueRange.copyWith(),
      ev: currentValue ?? this.currentValue,
    )..currentIndex = currentIndex ?? this.currentIndex;
  }

  static String findLabel({required double value}) =>
      AbstractParameter.findLabel(list: _fullStopList, value: value);
}
