/*
 * abstract_parameter.dart
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

import '../utilities/range.dart';
import 'constants.dart';

/// This class is an base class of [FNumber], [ShutterSpeed] and [IsoSpeed].
///
/// Values and ranges are adjust accordingly when changing.
///
/// Some parameter value labels used commonly cannot be calculated by equations.
/// Each label of the parameter values should be prepared in advance.
/// example:
///   AV (aperture value) 3⅔ -> F 3.5 (2^(3.667 / 2) = 3.564 ~ 3.6)
///   TV (time value) 7 -> 1/125 s ((1/2)^7 = 1/128)
///   SV (sensitivity value) ⅓ -> ISO 125 (100 * 2^(1/3) = 125.99 ~ 126)
abstract class AbstractParameter {
  final List<(String, double)> _fullStopList;
  final List<(String, double)> _oneHalfStopList;
  final List<(String, double)> _oneThirdStopList;
  FractionalStop _step;
  Range _valueRange;
  final double _preferValue;
  late int currentIndex;
  late int _preferIndex;

  AbstractParameter(
    this._fullStopList,
    this._oneHalfStopList,
    this._oneThirdStopList,
    this._step,
    this._valueRange,
    this._preferValue,
  ) {
    _preferIndex = _findClosestIndex(_preferValue);
    currentIndex = _preferIndex;
  }

  /// The minimum adjustment unit of each exposure parameter.
  ///
  /// When setting the step, adjusts [currentIndex] to the closest value of the
  /// previous one.
  FractionalStop get step => _step;

  set step(FractionalStop fractionalStop) {
    if (_step != fractionalStop) {
      double target = _computeTarget(currentValue, fractionalStop);
      _step = fractionalStop;
      int index = list.indexWhere((e) => e.$2 >= target);
      currentIndex = index < 0 ? list.length - 1 : index;
      _preferIndex = _findClosestIndex(_preferValue).clamp(minIndex, maxIndex);
    }
  }

  /// The available range of each exposure parameter.
  ///
  /// Adjusts [currentIndex] after setting the range, if needed .
  Range get valueRange => _valueRange;

  set valueRange(Range range) {
    _valueRange = range;
    currentIndex = currentIndex.clamp(minIndex, maxIndex);
  }

  /// The maximum value in the selected range of the current list.
  int get maxIndex {
    double max = valueRange.max;
    int index = list.lastIndexWhere((e) => e.$2 <= max);
    return index < 0 ? list.length - 1 : index;
  }

  /// The minimum value in the selected range of the current list.
  int get minIndex {
    double min = valueRange.min;
    int index = list.indexWhere((e) => e.$2 >= min);
    return index < 0 ? 0 : index;
  }

  /// The label of the current selected value.
  String get currentLabel => list[currentIndex].$1;

  /// The current selected value.
  double get currentValue => list[currentIndex].$2;

  /// The current prefer value.
  // double get preferValue => list[_preferIndex].$2;
  double get preferValue => _preferValue;

  /// The mapper index to parameter value.
  String Function(int) get indexToValueMapper => (int index) => list[index].$1;

  /// The mapper index to exposure value.
  double Function(int) get indexToEvMapper => (int index) => list[index].$2;

  /// Sets current index with the prefer value
  void setCurrentIndexWithPreferValue() {
    currentIndex = _preferIndex;
  }

  /// Sets current index with the target value
  void setCurrentIndexWithTargetValue(double value) {
    int index = _findClosestIndex(value);
    currentIndex = index.clamp(minIndex, maxIndex);
  }

  /// The current selected list of parameter.
  List<(String, double)> get list => switch (step) {
        FractionalStop.fullStop => _fullStopList,
        FractionalStop.oneHalfStop => _oneHalfStopList,
        FractionalStop.oneThirdStop => _oneThirdStopList,
      };

  /// Finds the closest value
  int _findClosestIndex(double value) {
    double target = _computeTarget(value, _step);
    final index = list.indexWhere((e) => e.$2 >= target);
    return index < 0 ? list.length - 1 : index;
  }

  /// Finds the label of the closest value to [value] in [list].
  static String findLabel(
          {required List<(String, double)> list, required double value}) =>
      list.firstWhere((e) => e.$2 >= value, orElse: () => list.last).$1;

  static double _computeTarget(double value, FractionalStop step) =>
      value - _threshold(step);

  static double _threshold(FractionalStop step) => switch (step) {
        FractionalStop.fullStop => 0.5,
        FractionalStop.oneHalfStop => 0.25,
        FractionalStop.oneThirdStop => 0.16,
      };

  double threshold() => _threshold(_step);
}
