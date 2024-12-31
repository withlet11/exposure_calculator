/*
 * light_condition.dart
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

import 'dart:math';

enum Scene {
  measured,
  dayLight,
  rainbow,
  sunsets,
  moon,
  moonLight,
  aurora,
  milkyWay,
  outdoorArtificial,
  indoorArtificial,
}

enum LightSensorStatus {
  unknown,
  working,
  notWorking,
}

class LightingCondition {
  static final Map<Scene, String> _sceneList = {
    Scene.measured: '📏Measured by light sensor',
    Scene.dayLight: '🌞Daylight',
    Scene.rainbow: '🌈Rainbows',
    Scene.sunsets: '🌅Sunsets and skylines',
    Scene.moon: '🌛The Moon,c altitude > 40°',
    Scene.moonLight: '🌃Moonlight, Moon altitude > 40°',
    Scene.aurora: '🐻‍❄️Aurora borealis and australis',
    Scene.milkyWay: '🌌Milky Way galactic center',
    Scene.outdoorArtificial: '🏟Outdoor, artificial light',
    Scene.indoorArtificial: '💡Indoor, artificial light',
  };

  static final Map<Scene, Map<String, double>> _conditionList = {
    Scene.measured: {'': 0.0},
    Scene.dayLight: {
      // Daylight
      '🏖Light sand or snow in full or slightly hazy sunlight (distinct shadows)':
          16.0,
      '🌞Typical scene in full or slightly hazy sunlight (distinct shadows)':
          15.0,
      '🌤️Typical scene in hazy sunlight (soft shadows)': 14.0,
      '🌥️Typical scene, cloudy bright (no shadows)': 13.0,
      '☁Typical scene, heavy overcast': 12.0,
      '🌳Areas in open shade, clear sunlight': 12.0,
    },
    // Outdoor, natural light
    Scene.rainbow: {
      // Rainbows
      '🌈Clear sky background': 15.0,
      '☁Cloudy sky background': 14.0,
    },
    Scene.sunsets: {
      // Sunsets and skylines
      '🌇Just before sunset (H)': 14.0,
      '🌇Just before sunset (L)': 12.0,
      '🌅At sunset': 12.0,
      '🌆Just after sunset (H)': 11.0,
      '🌆Just after sunset (L)': 9.0,
    },
    Scene.moon: {
      // The Moon,c altitude > 40°
      '🌕Full': 15,
      '🌔Gibbous': 14,
      '🌓Quarter': 13,
      '🌒Crescent': 12,
      '🌑Blood (H)': 3,
      '🌑Blood (L)': 0,
    },
    Scene.moonLight: {
      // Moonlight, Moon altitude > 40°
      '🌕Full (H)': -2,
      '🌕Full (L)': -3,
      '🌔Gibbous': -4,
      '🌓Quarter': -6,
    },
    Scene.aurora: {
      // Aurora borealis and australis
      '🐻‍❄️Bright (H)': -3,
      '🐻‍❄️Bright (L)': -4,
      '🐻‍❄️Medium (H)': -5,
      '🐻‍❄️Medium (L)': -6,
    },
    Scene.milkyWay: {
      // Milky Way galactic center
      '🌌Milky Way galactic center (H)': -9,
      '🌌Milky Way galactic center (L)': -11,
    },
    Scene.outdoorArtificial: {
      // Outdoor, artificial light
      '🏧Neon and other bright signs (H)': 10,
      '🏧Neon and other bright signs (L)': 9,
      '⚽Night sports': 9,
      '🔥Fires and burning buildings': 9,
      '🚦Bright street scenes': 8,
      '🏪Night street scenes and window displays (H)': 8,
      '🏪Night street scenes and window displays (L)': 7,
      '🚘Night vehicle traffic': 5,
      '🎠Fairs and amusement parks': 7,
      '🎄Christmas tree lights (H)': 5,
      '🎄Christmas tree lights (L)': 4,
      '🗼Floodlit buildings, monuments, and fountains (H)': 5,
      '🗼Floodlit buildings, monuments, and fountains (L)': 3,
      '🌉Distant views of lighted buildings': 2,
    },
    Scene.indoorArtificial: {
      // Indoor, artificial light
      '🖼️Galleries (H)': 11,
      '🖼️Galleries (L)': 8,
      '🎤Sports events, stage shows, and the like (H)': 9,
      '🎤ports events, stage shows, and the like (L)': 8,
      '🎪Circuses, floodlit': 8,
      '⛸Ice shows, floodlit': 9,
      '🖥️Offices and work areas (H)': 8,
      '🖥️Offices and work areas (L)': 7,
      '🛋️Home interiors (H)': 7,
      '🛋️Home interiors (L)': 5,
      '🎄Christmas tree lights (H)': 5,
      '🎄Christmas tree lights (L)': 4,
    },
  };

  static final Map<LightSensorStatus, List<String>> _sensorStatusMessageList = {
    LightSensorStatus.unknown: ["❓Unknown"],
    LightSensorStatus.working: ["✅Working"],
    LightSensorStatus.notWorking: ["⚠️Not Working!"],
  };

  Scene _currentScene = Scene.measured;
  late String currentCondition;
  double _measuredLV = 0.0;
  LightSensorStatus _sensorStatus = LightSensorStatus.working;

  LightingCondition() {
    currentCondition = conditionLabelList()[0];
  }

  /// The availability of light sensor.
  LightSensorStatus get sensorStatus => _sensorStatus;

  set sensorStatus(LightSensorStatus availability) {
    _sensorStatus = availability;
    if (_currentScene == Scene.measured) {
      currentCondition = _sensorStatusMessageList[_sensorStatus]![0];
    }
  }

  /// The label of current light condition group.
  String get currentScene => _sceneList[_currentScene]!;

  set currentScene(String? scene) {
    _currentScene = _sceneList.keys.firstWhere((e) => _sceneList[e] == scene,
        orElse: () => Scene.measured);
    currentCondition = conditionLabelList()[0];
  }

  /// The current light value (LV).
  double currentLV() => _currentScene == Scene.measured
      ? _measuredLV
      : _conditionList[_currentScene]![currentCondition] ?? 0.0;

  /// The label list of condition groups.
  List<String> sceneLabelList() => _sceneList.values.toList();

  /// The label list of conditions in the current group (scene).
  List<String> conditionLabelList() => _currentScene == Scene.measured
      ? _sensorStatusMessageList[_sensorStatus]!
      : _conditionList[_currentScene]!.keys.toList();

  /// The measured Light Value (LV)
  double get measuredLV => _measuredLV;

  /// The measured lux.
  set measuredLux(int lux) {
    _measuredLV = _luxToLV(lux);
  }

  /// Converts Lux to light value (LV)
  static double _luxToLV(int lux) =>
      log(lux.toDouble()) * log2e - log(2.5) * log2e;
}
