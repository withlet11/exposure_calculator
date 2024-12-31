/*
 * range.dart
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

import 'dart:math' as math;

/// A container that holds 2 constants as the ends of a range.
///
/// Two values must be different, but they can be in any order.
/// [max] : the larger end of the range
/// [min] : the smaller end of the range
/// [size] : the length of the range
final class Range {
  final double value1;
  final double value2;

  const Range(this.value1, this.value2);

  double get max => math.max(value1, value2);

  double get min => math.min(value1, value2);

  double get size => max - min;

  /// Creates new instance with a value as a new maximum or minimum value.
  Range copyWith({double? max, double? min}) => Range(
        (max != null && max > this.min) ? max : this.max,
        (min != null && min < this.max) ? min : this.min,
      );
}
