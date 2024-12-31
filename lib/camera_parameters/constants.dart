/*
 * constants.dart
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

/// Full stop, ½ stop and ⅓ mode
enum FractionalStop { fullStop, oneHalfStop, oneThirdStop }

const List<(FractionalStop, String)> fractionalStopName =
    <(FractionalStop, String)>[
  (FractionalStop.fullStop, '1'),
  (FractionalStop.oneHalfStop, '½'),
  (FractionalStop.oneThirdStop, '⅓'),
];

enum ExposureMode { program, time, aperture, manual }

const List<(ExposureMode, String)> exposureModeName = <(ExposureMode, String)>[
  (ExposureMode.program, 'P'),
  (ExposureMode.time, 'Tv'),
  (ExposureMode.aperture, 'Av'),
  (ExposureMode.manual, 'M'),
];

const initFNumberStep = FractionalStop.oneThirdStop;
const initFNumberIndex = 21; // f/8.0
const initApertureValueRange = Range(14.0, -1.0);

const initShutterSpeedStep = FractionalStop.oneThirdStop;
const initShutterSpeedIndex = 39; // 1/250s
const initTimeValueRange = Range(15.0, -5.0);

const initIsoSpeedStep = FractionalStop.oneThirdStop;
const initIsoSpeedIndex = 9; // ISO100
const initSensitivityValueRange = Range(12.0, -3.0);
