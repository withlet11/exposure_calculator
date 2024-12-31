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

import 'constants.dart';

final class ShutterSpeed extends AbstractParameter {
  // 1st value: shutter speed; 2nd value: time value
  static const List<(String, double)> _fullStopList = [
    ('30', -5.0),
    ('15', -4.0),
    ('8', -3.0),
    ('4', -2.0),
    ('2', -1.0),
    ('1', 0.0),
    ('0.5', 1.0),
    ('1/4', 2.0),
    ('1/8', 3.0),
    ('1/15', 4.0),
    ('1/30', 5.0),
    ('1/60', 6.0),
    ('1/125', 7.0),
    ('1/250', 8.0),
    ('1/500', 9.0),
    ('1/1000', 10.0),
    ('1/2000', 11.0),
    ('1/4000', 12.0),
    ('1/8000', 13.0),
    ('1/16000', 14.0),
    ('1/32000', 15.0),
  ];

  static const List<(String, double)> _oneHalfStopList = [
    ('30', -5.0),
    ('22', -4.5),
    ('15', -4.0),
    ('12', -3.5),
    ('8', -3.0),
    ('6', -2.5),
    ('4', -2.0),
    ('3', -1.5),
    ('2', -1.0),
    ('1.5', -0.5),
    ('1', 0.0),
    ('0.7', 0.5),
    ('0.5', 1.0),
    ('1/3', 1.5),
    ('1/4', 2.0),
    ('1/6', 2.5),
    ('1/8', 3.0),
    ('1/12', 3.5),
    ('1/15', 4.0),
    ('1/22', 4.5),
    ('1/30', 5.0),
    ('1/45', 5.5),
    ('1/60', 6.0),
    ('1/95', 6.5),
    ('1/125', 7.0),
    ('1/180', 7.5),
    ('1/250', 8.0),
    ('1/375', 8.5),
    ('1/500', 9.0),
    ('1/750', 9.5),
    ('1/1000', 10.0),
    ('1/1500', 10.5),
    ('1/2000', 11.0),
    ('1/3000', 11.5),
    ('1/4000', 12.0),
    ('1/6000', 12.5),
    ('1/8000', 13.0),
    ('1/12000', 13.5),
    ('1/16000', 14.0),
    ('1/23000', 14.5),
    ('1/32000', 15.0),
  ];

  static const List<(String, double)> _oneThirdStopList = [
    ('30', -5.00),
    ('25', -4.67),
    ('20', -4.33),
    ('15', -4.00),
    ('13', -3.67),
    ('10', -3.33),
    ('8', -3.00),
    ('6', -2.67),
    ('5', -2.33),
    ('4', -2.00),
    ('3.2', -1.67),
    ('2.5', -1.33),
    ('2', -1.00),
    ('1.6', -0.67),
    ('1.3', -0.33),
    ('1', 0.00),
    ('0.8', 0.33),
    ('0.6', 0.67),
    ('0.5', 1.00),
    ('0.4', 1.33),
    ('0.3', 1.67),
    ('1/4', 2.00),
    ('1/5', 2.33),
    ('1/6', 2.67),
    ('1/8', 3.00),
    ('1/10', 3.33),
    ('1/13', 3.67),
    ('1/15', 4.00),
    ('1/20', 4.33),
    ('1/25', 4.67),
    ('1/30', 5.00),
    ('1/40', 5.33),
    ('1/50', 5.67),
    ('1/60', 6.00),
    ('1/80', 6.33),
    ('1/100', 6.67),
    ('1/125', 7.00),
    ('1/160', 7.33),
    ('1/200', 7.67),
    ('1/250', 8.00),
    ('1/320', 8.33),
    ('1/400', 8.67),
    ('1/500', 9.00),
    ('1/640', 9.33),
    ('1/800', 9.67),
    ('1/1000', 10.00),
    ('1/1250', 10.33),
    ('1/1600', 10.67),
    ('1/2000', 11.00),
    ('1/2500', 11.33),
    ('1/3200', 11.67),
    ('1/4000', 12.00),
    ('1/5000', 12.33),
    ('1/6400', 12.67),
    ('1/8000', 13.00),
    ('1/10000', 13.33),
    ('1/12500', 13.67),
    ('1/16000', 14.00),
    ('1/20000', 14.33),
    ('1/25000', 14.67),
    ('1/32000', 15.00),
  ];

  ShutterSpeed()
      : super(_fullStopList, _oneHalfStopList, _oneThirdStopList,
            initShutterSpeedStep, initTimeValueRange, initShutterSpeedIndex);

  @override
  String get currentLabel => '${list[currentIndex].$1} s';

  static String findLabel({required double value}) =>
      AbstractParameter.findLabel(list: _fullStopList, value: value);
}
