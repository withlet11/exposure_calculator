/*
 * iso_speed.dart
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

final class IsoSpeed extends AbstractParameter {
  // 1st value: ISO speed, 2nd value: sensitivity value
  static const List<LabelAndValuePair> _fullStopList = [
    LabelAndValuePair('12', -3.0), // Start value must be an integer
    LabelAndValuePair('25', -2.0), // Interval must be 1
    LabelAndValuePair('50', -1.0),
    LabelAndValuePair('100', 0.0),
    LabelAndValuePair('200', 1.0),
    LabelAndValuePair('400', 2.0),
    LabelAndValuePair('800', 3.0),
    LabelAndValuePair('1600', 4.0),
    LabelAndValuePair('3200', 5.0),
    LabelAndValuePair('6400', 6.0),
    LabelAndValuePair('12800', 7.0),
    LabelAndValuePair('25600', 8.0),
    LabelAndValuePair('51200', 9.0),
    LabelAndValuePair('102400', 10),
    LabelAndValuePair('204800', 11),
    LabelAndValuePair('409600', 12),
  ];

  static const List<LabelAndValuePair> _oneHalfStopList = [
    LabelAndValuePair('12', -3.0), // Start value must be an integer
    LabelAndValuePair('18', -2.5), // Interval must be 0.5
    LabelAndValuePair('25', -2.0),
    LabelAndValuePair('35', -1.5),
    LabelAndValuePair('50', -1.0),
    LabelAndValuePair('70', -0.5),
    LabelAndValuePair('100', 0.0),
    LabelAndValuePair('140', 0.5),
    LabelAndValuePair('200', 1.0),
    LabelAndValuePair('280', 1.5),
    LabelAndValuePair('400', 2.0),
    LabelAndValuePair('560', 2.5),
    LabelAndValuePair('800', 3.0),
    LabelAndValuePair('1100', 3.5),
    LabelAndValuePair('1600', 4.0),
    LabelAndValuePair('2200', 4.5),
    LabelAndValuePair('3200', 5.0),
    LabelAndValuePair('4500', 5.5),
    LabelAndValuePair('6400', 6.0),
    LabelAndValuePair('9000', 6.5),
    LabelAndValuePair('12800', 7.0),
    LabelAndValuePair('18000', 7.5),
    LabelAndValuePair('25600', 8.0),
    LabelAndValuePair('36000', 8.5),
    LabelAndValuePair('51200', 9.0), // Interval can be changed for large numbers
    LabelAndValuePair('102400', 10),
    LabelAndValuePair('204800', 11),
    LabelAndValuePair('409600', 12),
  ];

  static const List<LabelAndValuePair> _oneThirdStopList = [
    LabelAndValuePair('12', -3.00), // Start value must be an integer
    LabelAndValuePair('16', -2.67), // Interval must be 0.33
    LabelAndValuePair('20', -2.33),
    LabelAndValuePair('25', -2.00),
    LabelAndValuePair('32', -1.67),
    LabelAndValuePair('40', -1.33),
    LabelAndValuePair('50', -1.00),
    LabelAndValuePair('64', -0.67),
    LabelAndValuePair('80', -0.33),
    LabelAndValuePair('100', 0.00),
    LabelAndValuePair('125', 0.33),
    LabelAndValuePair('160', 0.67),
    LabelAndValuePair('200', 1.00),
    LabelAndValuePair('250', 1.33),
    LabelAndValuePair('320', 1.67),
    LabelAndValuePair('400', 2.00),
    LabelAndValuePair('500', 2.33),
    LabelAndValuePair('640', 2.67),
    LabelAndValuePair('800', 3.00),
    LabelAndValuePair('1000', 3.33),
    LabelAndValuePair('1250', 3.67),
    LabelAndValuePair('1600', 4.00),
    LabelAndValuePair('2000', 4.33),
    LabelAndValuePair('2500', 4.67),
    LabelAndValuePair('3200', 5.00),
    LabelAndValuePair('4000', 5.33),
    LabelAndValuePair('5000', 5.67),
    LabelAndValuePair('6400', 6.00),
    LabelAndValuePair('8000', 6.33),
    LabelAndValuePair('10000', 6.67),
    LabelAndValuePair('12800', 7.00),
    LabelAndValuePair('16000', 7.33),
    LabelAndValuePair('20000', 7.67),
    LabelAndValuePair('25600', 8.00),
    LabelAndValuePair('32000', 8.33),
    LabelAndValuePair('40000', 8.67),
    LabelAndValuePair('51200', 9.00), // Interval can be changed for large numbers
    LabelAndValuePair('102400', 10.00),
    LabelAndValuePair('204800', 11.00),
    LabelAndValuePair('409600', 12.00),
  ];

  IsoSpeed({
    FractionalStop step = initIsoSpeedStep,
    Range range = initSensitivityValueRange,
    double ev = preferIsoSpeedEv,
  }) : super(_fullStopList, _oneHalfStopList, _oneThirdStopList, step, range,
            ev);

  @override
  String get currentLabel => 'ISO ${super.currentLabel}';

  IsoSpeed copyWith(
      {FractionalStop? step,
      Range? valueRange,
      double? currentValue,
      int? currentIndex}) {
    return IsoSpeed(
      step: step ?? this.step,
      range: valueRange ?? this.valueRange.copyWith(),
      ev: currentValue ?? this.currentValue,
    )..currentIndex = currentIndex ?? this.currentIndex;
  }

  static String findLabel({required double value}) =>
      AbstractParameter.findLabel(list: _fullStopList, value: value);
}
