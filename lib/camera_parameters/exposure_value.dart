/*
 * exposure_value.dart
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
import 'f_number.dart';
import 'iso_speed.dart';
import 'shutter_speed.dart';

final class ExposureValue {
  // final _lightingCondition = LightingCondition();
  final _fNumber = FNumber();
  final _shutterSpeed = ShutterSpeed();
  final _isoSpeed = IsoSpeed();
  ExposureMode exposureMode = ExposureMode.manual;
  bool isAutoIsoMode = false;

  /// The step of F-Number selected currently.
  FractionalStop get fNumberStep => _fNumber.step;

  set fNumberStep(FractionalStop fraction) {
    _fNumber.step = fraction;
  }

  /// Shutter speed & Time value
  FractionalStop get shutterSpeedStep => _shutterSpeed.step;

  set shutterSpeedStep(FractionalStop fraction) {
    _shutterSpeed.step = fraction;
  }

  /// ISO speed & Sensitivity value
  FractionalStop get isoSpeedStep => _isoSpeed.step;

  set isoSpeedStep(FractionalStop fraction) {
    _isoSpeed.step = fraction;
  }

  /// The range of aperture value selected currently.
  Range get apertureValueRange => _fNumber.valueRange;

  set apertureValueRange(Range range) {
    _fNumber.valueRange = range;
  }

  /// The range of time value selected currently.
  Range get timeValueRange => _shutterSpeed.valueRange;

  set timeValueRange(Range range) {
    _shutterSpeed.valueRange = range;
  }

  /// The range of sensitivity value selected currently.
  Range get sensitivityValueRange => _isoSpeed.valueRange;

  set sensitivityValueRange(Range range) {
    _isoSpeed.valueRange = range;
  }

  /// The aperture value selected currently.
  double get apertureValue => _fNumber.currentValue;

  /// The time value selected currently.
  double get timeValue => _shutterSpeed.currentValue;

  /// The sensitivity value selected currently.
  double get sensitivityValue => _isoSpeed.currentValue;

  /// The corresponding list of F number and aperture value.
  List<(String, double)> get fNumberValueList => _fNumber.list;

  /// The corresponding list of shutter speed and time value.
  List<(String, double)> get shutterSpeedValueList => _shutterSpeed.list;

  /// The corresponding list of ISO speed and sensitivity value.
  List<(String, double)> get isoSpeedValueList => _isoSpeed.list;

  /// The current selected index of F-number.
  int get currentFNumberIndex => _fNumber.currentIndex;

  set currentFNumberIndex(int index) {
    _fNumber.currentIndex = index;
  }

  /// The current selected index of shutter speed.
  int get currentShutterSpeedIndex => _shutterSpeed.currentIndex;

  set currentShutterSpeedIndex(int index) {
    _shutterSpeed.currentIndex = index;
  }

  /// The current selected index of ISO speed.
  int get currentIsoSpeedIndex => _isoSpeed.currentIndex;

  set currentIsoSpeedIndex(int index) {
    _isoSpeed.currentIndex = index;
  }

  /// The lower end of the current selected range of F-number.
  int get minFNumberIndex => _fNumber.minIndex;

  /// The lower end of the current selected range of shutter speed.
  int get minShutterSpeedIndex => _shutterSpeed.minIndex;

  /// The lower end of the current selected range of ISO speed.
  int get minIsoSpeedIndex => _isoSpeed.minIndex;

  /// The upper end of the current selected range of F-number.
  int get maxFNumberIndex => _fNumber.maxIndex;

  /// The upper end of the current selected range of shutter speed.
  int get maxShutterSpeedIndex => _shutterSpeed.maxIndex;

  /// The upper end of the current selected range of ISO speed.
  int get maxIsoSpeedIndex => _isoSpeed.maxIndex;

  /// The name of the current F-number.
  String get currentFNumber => _fNumber.currentLabel;

  /// The name of the current shutter speed.
  String get currentShutterSpeed => _shutterSpeed.currentLabel;

  /// The name of the current ISO speed.
  String get currentIsoSpeed => _isoSpeed.currentLabel;

  /// Finds F-number with an aperture value.
  static String findFNumber({required double value}) =>
      FNumber.findLabel(value: value);

  /// Finds shutter speed with a time value.
  static String findShutterSpeed({required double value}) =>
      ShutterSpeed.findLabel(value: value);

  /// Finds ISO speed with a sensitivity value.
  static String findIsoSpeed({required double value}) =>
      IsoSpeed.findLabel(value: value);

  /// The exposure value (EV100)
  double get exposureValue => apertureValue + timeValue - sensitivityValue;

  /// Adjusts all parameters as auto exposure (AE).
  void adjustAll(double lightValue) {
    switch (exposureMode) {
      case ExposureMode.program:
        // Target is 1/60s
        _shutterSpeed.setCurrentIndexWithTargetValue(6.0);
        if (isAutoIsoMode) {
          // Target is ISO100
          _isoSpeed.setCurrentIndexWithTargetValue(0.0);
          adjustFNumber(lightValue);
          adjustIsoSpeed(lightValue);
          adjustShutterSpeed(lightValue);
        } else {
          adjustFNumber(lightValue);
          adjustShutterSpeed(lightValue);
        }
      case ExposureMode.aperture:
        if (isAutoIsoMode) {
          // Target is ISO100
          _isoSpeed.setCurrentIndexWithTargetValue(0.0);
          adjustShutterSpeed(lightValue);
          adjustIsoSpeed(lightValue);
        } else {
          adjustShutterSpeed(lightValue);
        }
      case ExposureMode.time:
        if (isAutoIsoMode) {
          // Target is ISO100
          _isoSpeed.setCurrentIndexWithTargetValue(0.0);
          adjustFNumber(lightValue);
          adjustIsoSpeed(lightValue);
        } else {
          adjustFNumber(lightValue);
        }
      case ExposureMode.manual:
        if (isAutoIsoMode) {
          adjustIsoSpeed(lightValue);
        }
      default:
    }
  }

  /// Adjusts the F-number as auto exposure (AE).
  void adjustFNumber(double lightValue) {
    double targetAV = lightValue - timeValue + sensitivityValue;
    _fNumber.setCurrentIndexWithTargetValue(targetAV);
  }

  /// Adjusts the shutter speed as auto exposure (AE).
  void adjustShutterSpeed(double lightValue) {
    double targetTV = lightValue - apertureValue + sensitivityValue;
    _shutterSpeed.setCurrentIndexWithTargetValue(targetTV);
  }

  /// Adjusts the ISO speed as auto exposure (AE).
  void adjustIsoSpeed(double lightValue) {
    double targetTV = apertureValue + timeValue - lightValue;
    _isoSpeed.setCurrentIndexWithTargetValue(targetTV);
  }
}
