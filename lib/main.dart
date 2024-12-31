/*
 * main.dart
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

import 'dart:async';

import 'package:exposure_calculator/provider/provider.dart';
import 'package:exposure_calculator/utilities/range.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:light/light.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'camera_parameters/constants.dart';
import 'camera_parameters/exposure_value.dart';
import 'gui/exposure_slider.dart';
import 'lighting_condition/lighting_condition.dart';
import 'gui/setting_drawer.dart';

const _keyFNumberStep = 'fNumberStep';
const _keyApertureMax = 'apertureMax';
const _keyApertureMin = 'apertureMin';
const _keyShutterSpeedStep = 'shutterSpeedStep';
const _keyTimeMax = 'timeMax';
const _keyTimeMin = 'timeMin';
const _keyIsoSpeedStep = 'isoSpeedStep';
const _keySensitivityMax = 'sensitivityMax';
const _keySensitivityMin = 'sensitivityMin';

void main() {
  runApp(const ProviderScope(child: ExposureCalculator()));
}

class ExposureCalculator extends ConsumerWidget {
  const ExposureCalculator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Exposure Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.yellow, brightness: Brightness.dark),
      ),
      home: const ExposureCalculatorHomePage(title: 'Exposure Calculator'),
    );
  }
}

class ExposureCalculatorHomePage extends ConsumerStatefulWidget {
  const ExposureCalculatorHomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<ExposureCalculatorHomePage> createState() =>
      _ExposureCalculatorHomePageState();
}

class _ExposureCalculatorHomePageState
    extends ConsumerState<ExposureCalculatorHomePage> {
  final _exposureValue = ExposureValue();
  final _lightingCondition = LightingCondition();

  LightSensorStatus lightSensorStatus = LightSensorStatus.unknown;
  Light? _light;
  StreamSubscription? _subscription;

  final _prefs = SharedPreferencesAsync();

  @override
  void initState() {
    super.initState();

    // Starts listening to light sensor.
    _light = Light();
    try {
      lightSensorStatus = LightSensorStatus.working;
      _subscription = _light?.lightSensorStream.listen((int lux) async {
        setState(() {
          _lightingCondition.measuredLux = lux;
        });
      });
    } on LightException catch (_) {
      _lightingCondition.measuredLux = 0;
      lightSensorStatus = LightSensorStatus.notWorking;
    }

    loadPreferences(_prefs);
  }

  @override
  void dispose() {
    // Stops listening to light sensor.
    _subscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fNumberStep = ref.watch(fNumberStepProvider);
    _exposureValue.fNumberStep = fNumberStep;
    final apertureValueRange = ref.watch(apertureValueRangeProvider);
    _exposureValue.apertureValueRange = apertureValueRange;

    final shutterSpeedStep = ref.watch(shutterSpeedStepProvider);
    _exposureValue.shutterSpeedStep = shutterSpeedStep;
    final timeValueRange = ref.watch(timeValueRangeProvider);
    _exposureValue.timeValueRange = timeValueRange;

    final isoSpeedStep = ref.watch(isoSpeedStepProvider);
    _exposureValue.isoSpeedStep = isoSpeedStep;
    final sensitivityValueRange = ref.watch(sensitivityValueRangeProvider);
    _exposureValue.sensitivityValueRange = sensitivityValueRange;

    // Sets sliders.
    final fNumberSliderAction = switch (_exposureValue.exposureMode) {
      ExposureMode.manual || ExposureMode.aperture => (double value) {
          setState(() {
            _exposureValue.currentFNumberIndex =
                (value + _exposureValue.minFNumberIndex).round();
          });
        },
      _ => null,
    };

    final shutterSpeedSliderAction = switch (_exposureValue.exposureMode) {
      ExposureMode.manual || ExposureMode.time => (double value) {
          setState(() {
            _exposureValue.currentShutterSpeedIndex =
                (value + _exposureValue.minShutterSpeedIndex).round();
          });
        },
      _ => null
    };

    final isoSpeedSliderAction = _exposureValue.isAutoIsoMode
        ? null
        : (double value) {
            setState(() {
              _exposureValue.currentIsoSpeedIndex =
                  (value + _exposureValue.minIsoSpeedIndex).round();
            });
          };

    // Sets a button for exposure mode setting
    List<bool> exposureModeButtonSelection = ExposureMode.values
        .map((ExposureMode e) => e == _exposureValue.exposureMode)
        .toList();

    _exposureValue.adjustAll(_lightingCondition.currentLV());

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      drawer: const SettingDrawer(),
      body: Container(
        padding: const EdgeInsets.fromLTRB(32, 8, 32, 0),
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Flexible(
                  flex: 8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('LV:'),
                      Text(
                        _roundNumber(_lightingCondition.currentLV()),
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 1),
                Flexible(
                  flex: 8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('EV (100):'),
                      Text(
                        _roundNumber(_exposureValue.exposureValue),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text('Light Condition',
                style: Theme.of(context).textTheme.titleSmall),
            DropdownButton<String>(
              value: _lightingCondition.currentScene,
              icon: const Icon(Icons.arrow_downward),
              itemHeight: 64,
              onChanged: (String? value) {
                setState(() {
                  _lightingCondition.currentScene = value;
                });
              },
              isExpanded: true,
              items: _lightingCondition
                  .sceneLabelList()
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    overflow: TextOverflow.visible,
                  ),
                );
              }).toList(),
            ),
            DropdownButton<String>(
              value: _lightingCondition.currentCondition,
              icon: const Icon(Icons.arrow_downward),
              itemHeight: 64,
              onChanged: (String? value) {
                setState(() {
                  _lightingCondition.currentCondition = value!;
                });
              },
              isExpanded: true,
              items: _lightingCondition
                  .conditionLabelList()
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    overflow: TextOverflow.visible,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Text('Camera settings',
                style: Theme.of(context).textTheme.titleSmall),
            ToggleButtons(
              isSelected: exposureModeButtonSelection,
              onPressed: (int index) {
                setState(() {
                  _exposureValue.exposureMode = switch (index) {
                    0 => ExposureMode.program,
                    1 => ExposureMode.time,
                    2 => ExposureMode.aperture,
                    _ => ExposureMode.manual,
                  };
                });
              },
              constraints: const BoxConstraints(
                minHeight: 32.0,
                minWidth: 56.0,
              ),
              // ToggleButtons uses a List<Widget> to build its children.
              children: exposureModeName
                  .map(((ExposureMode, String) shirt) => Text(shirt.$2))
                  .toList(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('ISO Auto'),
                Switch(
                  value: _exposureValue.isAutoIsoMode,
                  onChanged: (bool value) {
                    setState(() {
                      _exposureValue.isAutoIsoMode = value;
                    });
                  },
                ),
              ],
            ),
            ExposureSlider(
              title: 'F Number',
              value: _exposureValue.apertureValue,
              label: _exposureValue.currentFNumber,
              index: _exposureValue.currentFNumberIndex,
              minIndex: _exposureValue.minFNumberIndex,
              maxIndex: _exposureValue.maxFNumberIndex,
              onChanged: fNumberSliderAction,
            ),
            ExposureSlider(
              title: 'Shutter Speed',
              value: _exposureValue.timeValue,
              label: _exposureValue.currentShutterSpeed,
              index: _exposureValue.currentShutterSpeedIndex,
              minIndex: _exposureValue.minShutterSpeedIndex,
              maxIndex: _exposureValue.maxShutterSpeedIndex,
              onChanged: shutterSpeedSliderAction,
            ),
            ExposureSlider(
              title: 'ISO Speed',
              value: _exposureValue.sensitivityValue,
              label: _exposureValue.currentIsoSpeed,
              index: _exposureValue.currentIsoSpeedIndex,
              minIndex: _exposureValue.minIsoSpeedIndex,
              maxIndex: _exposureValue.maxIsoSpeedIndex,
              onChanged: isoSpeedSliderAction,
            ),
          ],
        ),
      ),
    );
  }

  void loadPreferences(SharedPreferencesAsync prefs) async {
    final int fNumberStep = await prefs.getInt(_keyFNumberStep) ?? initFNumberIndex;
    final apertureMax = await prefs.getDouble(_keyApertureMax) ?? initApertureValueRange.max;
    final apertureMin = await prefs.getDouble(_keyApertureMin) ?? initApertureValueRange.min;
    final shutterSpeedStep = await prefs.getInt(_keyShutterSpeedStep) ?? initShutterSpeedIndex;
    final timeMax = await prefs.getDouble(_keyTimeMax) ?? initTimeValueRange.max;
    final timeMin = await prefs.getDouble(_keyTimeMin) ?? initTimeValueRange.min;
    final isoSpeedStep = await prefs.getInt(_keyIsoSpeedStep) ?? initIsoSpeedIndex;
    final sensitivityMax = await prefs.getDouble(_keySensitivityMax) ?? initSensitivityValueRange.max;
    final sensitivityMin = await prefs.getDouble(_keySensitivityMin) ?? initSensitivityValueRange.min;

    setState(() {
      ref.read(fNumberStepProvider.notifier).state = switch (fNumberStep) {
        0 => FractionalStop.fullStop,
        1 => FractionalStop.oneHalfStop,
        _ => FractionalStop.oneThirdStop,
      };

      ref.read(apertureValueRangeProvider.notifier).state = Range(apertureMax, apertureMin);

      ref.read(shutterSpeedStepProvider.notifier).state = switch (shutterSpeedStep) {
        0 => FractionalStop.fullStop,
        1 => FractionalStop.oneHalfStop,
        _ => FractionalStop.oneThirdStop,
      };

      ref.read(timeValueRangeProvider.notifier).state = Range(timeMax, timeMin);

      ref.read(isoSpeedStepProvider.notifier).state = switch (isoSpeedStep) {
        0 => FractionalStop.fullStop,
        1 => FractionalStop.oneHalfStop,
        _ => FractionalStop.oneThirdStop,
      };

      ref.read(sensitivityValueRangeProvider.notifier).state = Range(sensitivityMax, sensitivityMin);
    });
  }

  static String _roundNumber(double value) =>
      value.toStringAsFixed(1).padLeft(5);
}
