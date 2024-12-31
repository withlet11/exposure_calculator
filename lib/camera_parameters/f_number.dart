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

import 'constants.dart';

final class FNumber extends AbstractParameter {
  // 1st value: f-number, 2nd value: aperture value
  static const List<(String, double)> _fullStopList = [
    ('0.7', -1.0),
    ('1.0', 0.0),
    ('1.4', 1.0),
    ('2.0', 2.0),
    ('2.8', 3.0),
    ('4.0', 4.0),
    ('5.6', 5.0),
    ('8.0', 6.0),
    ('11', 7.0),
    ('16', 8.0),
    ('22', 9.0),
    ('32', 10.0),
    ('45', 11.0),
    ('64', 12.0),
    ('90', 13.0),
    ('128', 14.0),
  ];

  static const List<(String, double)> _oneHalfStopList = [
    ('0.7', -1.0),
    ('0.8', -0.5),
    ('1.0', 0.0),
    ('1.2', 0.5),
    ('1.4', 1.0),
    ('1.7', 1.5),
    ('2.0', 2.0),
    ('2.4', 2.5),
    ('2.8', 3.0),
    ('3.3', 3.5),
    ('4.0', 4.0),
    ('4.8', 4.5),
    ('5.6', 5.0),
    ('6.7', 5.5),
    ('8.0', 6.0),
    ('9.5', 6.5),
    ('11', 7.0),
    ('13', 7.5),
    ('16', 8.0),
    ('19', 8.5),
    ('22', 9.0),
    ('27', 9.5),
    ('32', 10.0),
    ('38', 10.5),
    ('45', 11.0),
    ('54', 11.5),
    ('64', 12.0),
    ('76', 12.5),
    ('90', 13.0),
    ('107', 13.5),
    ('128', 14.0),
  ];

  static const List<(String, double)> _oneThirdStopList = [
    ('0.7', -1.00),
    ('0.8', -0.67),
    ('0.9', -0.33),
    ('1.0', 0.00),
    ('1.1', 0.33),
    ('1.2', 0.67),
    ('1.4', 1.00),
    ('1.6', 1.33),
    ('1.8', 1.67),
    ('2.0', 2.00),
    ('2.2', 2.33),
    ('2.5', 2.67),
    ('2.8', 3.00),
    ('3.2', 3.33),
    ('3.5', 3.67),
    ('4.0', 4.00),
    ('4.5', 4.33),
    ('5.0', 4.67),
    ('5.6', 5.00),
    ('6.3', 5.33),
    ('7.1', 5.67),
    ('8.0', 6.00),
    ('9.0', 6.33),
    ('10', 6.67),
    ('11', 7.00),
    ('13', 7.33),
    ('14', 7.67),
    ('16', 8.00),
    ('18', 8.33),
    ('20', 8.67),
    ('22', 9.00),
    ('25', 9.33),
    ('29', 9.67),
    ('32', 10.00),
    ('36', 10.33),
    ('40', 10.67),
    ('45', 11.00),
    ('51', 11.33),
    ('57', 11.67),
    ('64', 12.00),
    ('72', 12.33),
    ('80', 12.67),
    ('90', 13.00),
  ];

  FNumber()
      : super(_fullStopList, _oneHalfStopList, _oneThirdStopList,
            initFNumberStep, initApertureValueRange, initFNumberIndex);

  @override
  String get currentLabel => 'f/${list[currentIndex].$1}';

  static String findLabel({required double value}) =>
      AbstractParameter.findLabel(list: _fullStopList, value: value);
}
