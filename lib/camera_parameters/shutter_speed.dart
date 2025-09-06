/*
 * shutter_speed.dart
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

final class ShutterSpeed extends AbstractParameter {
  // 1st value: shutter speed; 2nd value: time value
  static const List<LabelAndValuePair> _fullStopList = [
    LabelAndValuePair('30', -5.0), // Start value must be an integer
    LabelAndValuePair('15', -4.0), // Interval must be 1
    LabelAndValuePair('8', -3.0),
    LabelAndValuePair('4', -2.0),
    LabelAndValuePair('2', -1.0),
    LabelAndValuePair('1', 0.0),
    LabelAndValuePair('0.5', 1.0),
    LabelAndValuePair('1/4', 2.0),
    LabelAndValuePair('1/8', 3.0),
    LabelAndValuePair('1/15', 4.0),
    LabelAndValuePair('1/30', 5.0),
    LabelAndValuePair('1/60', 6.0),
    LabelAndValuePair('1/125', 7.0),
    LabelAndValuePair('1/250', 8.0),
    LabelAndValuePair('1/500', 9.0),
    LabelAndValuePair('1/1000', 10.0),
    LabelAndValuePair('1/2000', 11.0),
    LabelAndValuePair('1/4000', 12.0),
    LabelAndValuePair('1/8000', 13.0),
    LabelAndValuePair('1/16000', 14.0),
    LabelAndValuePair('1/32000', 15.0),
  ];

  static const List<LabelAndValuePair> _oneHalfStopList = [
    LabelAndValuePair('30', -5.0), // Start value must be an integer
    LabelAndValuePair('22', -4.5), // Interval must be 0.5
    LabelAndValuePair('15', -4.0),
    LabelAndValuePair('12', -3.5),
    LabelAndValuePair('8', -3.0),
    LabelAndValuePair('6', -2.5),
    LabelAndValuePair('4', -2.0),
    LabelAndValuePair('3', -1.5),
    LabelAndValuePair('2', -1.0),
    LabelAndValuePair('1.5', -0.5),
    LabelAndValuePair('1', 0.0),
    LabelAndValuePair('0.7', 0.5),
    LabelAndValuePair('0.5', 1.0),
    LabelAndValuePair('1/3', 1.5),
    LabelAndValuePair('1/4', 2.0),
    LabelAndValuePair('1/6', 2.5),
    LabelAndValuePair('1/8', 3.0),
    LabelAndValuePair('1/12', 3.5),
    LabelAndValuePair('1/15', 4.0),
    LabelAndValuePair('1/22', 4.5),
    LabelAndValuePair('1/30', 5.0),
    LabelAndValuePair('1/45', 5.5),
    LabelAndValuePair('1/60', 6.0),
    LabelAndValuePair('1/95', 6.5),
    LabelAndValuePair('1/125', 7.0),
    LabelAndValuePair('1/180', 7.5),
    LabelAndValuePair('1/250', 8.0),
    LabelAndValuePair('1/375', 8.5),
    LabelAndValuePair('1/500', 9.0),
    LabelAndValuePair('1/750', 9.5),
    LabelAndValuePair('1/1000', 10.0),
    LabelAndValuePair('1/1500', 10.5),
    LabelAndValuePair('1/2000', 11.0),
    LabelAndValuePair('1/3000', 11.5),
    LabelAndValuePair('1/4000', 12.0),
    LabelAndValuePair('1/6000', 12.5),
    LabelAndValuePair('1/8000', 13.0),
    LabelAndValuePair('1/12000', 13.5),
    LabelAndValuePair('1/16000', 14.0),
    LabelAndValuePair('1/23000', 14.5),
    LabelAndValuePair('1/32000', 15.0),
  ];

  static const List<LabelAndValuePair> _oneThirdStopList = [
    LabelAndValuePair('30', -5.00), // Start value must be an integer
    LabelAndValuePair('25', -4.67), // Interval must be 0.33
    LabelAndValuePair('20', -4.33),
    LabelAndValuePair('15', -4.00),
    LabelAndValuePair('13', -3.67),
    LabelAndValuePair('10', -3.33),
    LabelAndValuePair('8', -3.00),
    LabelAndValuePair('6', -2.67),
    LabelAndValuePair('5', -2.33),
    LabelAndValuePair('4', -2.00),
    LabelAndValuePair('3.2', -1.67),
    LabelAndValuePair('2.5', -1.33),
    LabelAndValuePair('2', -1.00),
    LabelAndValuePair('1.6', -0.67),
    LabelAndValuePair('1.3', -0.33),
    LabelAndValuePair('1', 0.00),
    LabelAndValuePair('0.8', 0.33),
    LabelAndValuePair('0.6', 0.67),
    LabelAndValuePair('0.5', 1.00),
    LabelAndValuePair('0.4', 1.33),
    LabelAndValuePair('0.3', 1.67),
    LabelAndValuePair('1/4', 2.00),
    LabelAndValuePair('1/5', 2.33),
    LabelAndValuePair('1/6', 2.67),
    LabelAndValuePair('1/8', 3.00),
    LabelAndValuePair('1/10', 3.33),
    LabelAndValuePair('1/13', 3.67),
    LabelAndValuePair('1/15', 4.00),
    LabelAndValuePair('1/20', 4.33),
    LabelAndValuePair('1/25', 4.67),
    LabelAndValuePair('1/30', 5.00),
    LabelAndValuePair('1/40', 5.33),
    LabelAndValuePair('1/50', 5.67),
    LabelAndValuePair('1/60', 6.00),
    LabelAndValuePair('1/80', 6.33),
    LabelAndValuePair('1/100', 6.67),
    LabelAndValuePair('1/125', 7.00),
    LabelAndValuePair('1/160', 7.33),
    LabelAndValuePair('1/200', 7.67),
    LabelAndValuePair('1/250', 8.00),
    LabelAndValuePair('1/320', 8.33),
    LabelAndValuePair('1/400', 8.67),
    LabelAndValuePair('1/500', 9.00),
    LabelAndValuePair('1/640', 9.33),
    LabelAndValuePair('1/800', 9.67),
    LabelAndValuePair('1/1000', 10.00),
    LabelAndValuePair('1/1250', 10.33),
    LabelAndValuePair('1/1600', 10.67),
    LabelAndValuePair('1/2000', 11.00),
    LabelAndValuePair('1/2500', 11.33),
    LabelAndValuePair('1/3200', 11.67),
    LabelAndValuePair('1/4000', 12.00),
    LabelAndValuePair('1/5000', 12.33),
    LabelAndValuePair('1/6400', 12.67),
    LabelAndValuePair('1/8000', 13.00),
    LabelAndValuePair('1/10000', 13.33),
    LabelAndValuePair('1/12500', 13.67),
    LabelAndValuePair('1/16000', 14.00),
    LabelAndValuePair('1/20000', 14.33),
    LabelAndValuePair('1/25000', 14.67),
    LabelAndValuePair('1/32000', 15.00),
  ];

  ShutterSpeed({
    FractionalStop step = initShutterSpeedStep,
    Range range = initTimeValueRange,
    double ev = preferShutterSpeedEv,
  }) : super(_fullStopList, _oneHalfStopList, _oneThirdStopList, step, range,
            ev);

  @override
  String get currentLabel => '${super.currentLabel} s';

  ShutterSpeed copyWith(
      {FractionalStop? step,
      Range? valueRange,
      double? currentValue,
      int? currentIndex}) {
    return ShutterSpeed(
      step: step ?? this.step,
      range: valueRange ?? this.valueRange.copyWith(),
      ev: currentValue ?? this.currentValue,
    )..currentIndex = currentIndex ?? this.currentIndex;
  }

  static String findLabel({required double value}) =>
      AbstractParameter.findLabel(list: _fullStopList, value: value);
}
