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

import 'constants.dart';

final class IsoSpeed extends AbstractParameter {
  // 1st value: ISO speed, 2nd value: sensitivity value
  static const List<(String, double)> _fullStopList = [
    ('12', -3.0),
    ('25', -2.0),
    ('50', -1.0),
    ('100', 0.0),
    ('200', 1.0),
    ('400', 2.0),
    ('800', 3.0),
    ('1600', 4.0),
    ('3200', 5.0),
    ('6400', 6.0),
    ('12800', 7.0),
    ('25600', 8.0),
    ('51200', 9.0),
    ('102400', 10),
    ('204800', 11),
    ('409600', 12),
  ];

  static const List<(String, double)> _oneHalfStopList = [
    ('12', -3.0),
    ('18', -2.5),
    ('25', -2.0),
    ('35', -1.5),
    ('50', -1.0),
    ('70', -0.5),
    ('100', 0.0),
    ('140', 0.5),
    ('200', 1.0),
    ('280', 1.5),
    ('400', 2.0),
    ('560', 2.5),
    ('800', 3.0),
    ('1100', 3.5),
    ('1600', 4.0),
    ('2200', 4.5),
    ('3200', 5.0),
    ('4500', 5.5),
    ('6400', 6.0),
    ('9000', 6.5),
    ('12800', 7.0),
    ('18000', 7.5),
    ('25600', 8.0),
    ('36000', 8.5),
    ('51200', 9.0),
    ('102400', 10),
    ('204800', 11),
    ('409600', 12),
  ];

  static const List<(String, double)> _oneThirdStopList = [
    ('12', -3.00),
    ('16', -2.67),
    ('20', -2.33),
    ('25', -2.00),
    ('32', -1.67),
    ('40', -1.33),
    ('50', -1.00),
    ('64', -0.67),
    ('80', -0.33),
    ('100', 0.00),
    ('125', 0.33),
    ('160', 0.67),
    ('200', 1.00),
    ('250', 1.33),
    ('320', 1.67),
    ('400', 2.00),
    ('500', 2.33),
    ('640', 2.67),
    ('800', 3.00),
    ('1000', 3.33),
    ('1250', 3.67),
    ('1600', 4.00),
    ('2000', 4.33),
    ('2500', 4.67),
    ('3200', 5.00),
    ('4000', 5.33),
    ('5000', 5.67),
    ('6400', 6.00),
    ('8000', 6.33),
    ('10000', 6.67),
    ('12800', 7.00),
    ('16000', 7.33),
    ('20000', 7.67),
    ('25600', 8.00),
    ('32000', 8.33),
    ('40000', 8.67),
    ('51200', 9.00),
    ('102400', 10.00),
    ('204800', 11.00),
    ('409600', 12.00),
  ];

  IsoSpeed()
      : super(_fullStopList, _oneHalfStopList, _oneThirdStopList,
            initIsoSpeedStep, initSensitivityValueRange, initIsoSpeedIndex);

  @override
  String get currentLabel => 'ISO ${list[currentIndex].$1}';

  static String findLabel({required double value}) =>
      AbstractParameter.findLabel(list: _fullStopList, value: value);
}
