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
    final apertureValueRange = ref.watch(apertureValueRangeProvider);
    final shutterSpeedStep = ref.watch(shutterSpeedStepProvider);
    final timeValueRange = ref.watch(timeValueRangeProvider);
    final isoSpeedStep = ref.watch(isoSpeedStepProvider);
    final sensitivityValueRange = ref.watch(sensitivityValueRangeProvider);

    _exposureValue.fNumberStep = fNumberStep;
    _exposureValue.apertureValueRange = apertureValueRange;
    _exposureValue.shutterSpeedStep = shutterSpeedStep;
    _exposureValue.timeValueRange = timeValueRange;
    _exposureValue.isoSpeedStep = isoSpeedStep;
    _exposureValue.sensitivityValueRange = sensitivityValueRange;

    // Sets sliders.
    final fNumberSliderAction = switch (_exposureValue.exposureMode) {
      ExposureMode.manual || ExposureMode.aperture => (double value) {
          setState(() {
            _exposureValue.currentFNumberIndex = value.round();
          });
        },
      _ => null,
    };

    final shutterSpeedSliderAction = switch (_exposureValue.exposureMode) {
      ExposureMode.manual || ExposureMode.time => (double value) {
          setState(() {
            _exposureValue.currentShutterSpeedIndex = value.round();
          });
        },
      _ => null
    };

    final isoSpeedSliderAction = _exposureValue.isAutoIsoMode
        ? null
        : (double value) {
            setState(() {
              _exposureValue.currentIsoSpeedIndex = value.round();
            });
          };

    // Sets a button for exposure mode setting
    List<bool> exposureModeButtonSelection = ExposureMode.values
        .map((ExposureMode e) => e == _exposureValue.exposureMode)
        .toList();

    _exposureValue.adjustAll(_lightingCondition.currentLV());
    final currentLV = _lightingCondition.currentLV();
    final exposureValue = _exposureValue.exposureValue;
    final isExposureValueProper =
        _exposureValue.isProperForLightValue(currentLV);

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
                        _roundNumber(currentLV),
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
                        _roundNumber(exposureValue),
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                                color: isExposureValueProper
                                    ? Theme.of(context).colorScheme.onSurface
                                    : Colors.redAccent),
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
            IgnorePointer(
              ignoring: _lightingCondition.conditionLabelList().length <= 1,
              child: DropdownButton<String>(
                value: _lightingCondition.currentCondition,
                icon: _lightingCondition.conditionLabelList().length > 1
                    ? const Icon(Icons.arrow_downward)
                    : const SizedBox.shrink(),
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
            const SizedBox(height: 8),
            ExposureSlider(
              key: const ValueKey('fNumberSlider'),
              title: 'F Number',
              initialIndex: _exposureValue.currentFNumberIndex,
              initialMinIndex: _exposureValue.minFNumberIndex,
              initialMaxIndex: _exposureValue.maxFNumberIndex,
              initialStep: _exposureValue.fNumberStep.index + 1,
              onChanged: (_exposureValue.exposureMode == ExposureMode.manual ||
                      _exposureValue.exposureMode == ExposureMode.aperture)
                  ? fNumberSliderAction
                  : null,
              labelBuilder: (int index) => _exposureValue.currentFNumber,
              indexToValueMapper: _exposureValue.indexToFNumberMapper,
              indexToEvMapper: _exposureValue.indexToApertureValueMapper,
            ),
            const SizedBox(height: 8),
            ExposureSlider(
              key: const ValueKey('shutterSpeedSlider'),
              title: 'Shutter Speed',
              initialIndex: _exposureValue.currentShutterSpeedIndex,
              initialMinIndex: _exposureValue.minShutterSpeedIndex,
              initialMaxIndex: _exposureValue.maxShutterSpeedIndex,
              initialStep: _exposureValue.shutterSpeedStep.index + 1,
              onChanged: (_exposureValue.exposureMode == ExposureMode.manual ||
                      _exposureValue.exposureMode == ExposureMode.time)
                  ? shutterSpeedSliderAction
                  : null,
              labelBuilder: (int index) => _exposureValue.currentShutterSpeed,
              indexToValueMapper: _exposureValue.indexToShutterSpeedMapper,
              indexToEvMapper: _exposureValue.indexToTimeValueMapper,
            ),
            const SizedBox(height: 8),
            ExposureSlider(
              key: const ValueKey('isoSpeedSlider'),
              title: 'ISO Speed',
              initialIndex: _exposureValue.currentIsoSpeedIndex,
              initialMinIndex: _exposureValue.minIsoSpeedIndex,
              initialMaxIndex: _exposureValue.maxIsoSpeedIndex,
              initialStep: _exposureValue.isoSpeedStep.index + 1,
              onChanged:
                  !_exposureValue.isAutoIsoMode ? isoSpeedSliderAction : null,
              labelBuilder: (int index) => _exposureValue.currentIsoSpeed,
              indexToValueMapper: _exposureValue.indexToIsoSpeedMapper,
              indexToEvMapper: _exposureValue.indexToSensitivityValueMapper,
            ),
          ],
        ),
      ),
    );
  }

  void loadPreferences(SharedPreferencesAsync prefs) async {
    final int fNumberStep =
        await prefs.getInt(_keyFNumberStep) ?? initFNumberIndex;
    final apertureMax =
        await prefs.getDouble(_keyApertureMax) ?? initApertureValueRange.max;
    final apertureMin =
        await prefs.getDouble(_keyApertureMin) ?? initApertureValueRange.min;
    final shutterSpeedStep =
        await prefs.getInt(_keyShutterSpeedStep) ?? initShutterSpeedIndex;
    final timeMax =
        await prefs.getDouble(_keyTimeMax) ?? initTimeValueRange.max;
    final timeMin =
        await prefs.getDouble(_keyTimeMin) ?? initTimeValueRange.min;
    final isoSpeedStep =
        await prefs.getInt(_keyIsoSpeedStep) ?? initIsoSpeedIndex;
    final sensitivityMax = await prefs.getDouble(_keySensitivityMax) ??
        initSensitivityValueRange.max;
    final sensitivityMin = await prefs.getDouble(_keySensitivityMin) ??
        initSensitivityValueRange.min;

    setState(() {
      ref.read(fNumberStepProvider.notifier).state =
          _fractionalStopFromInt(fNumberStep);

      ref.read(apertureValueRangeProvider.notifier).state =
          Range(apertureMax, apertureMin);

      ref.read(shutterSpeedStepProvider.notifier).state =
          _fractionalStopFromInt(shutterSpeedStep);

      ref.read(timeValueRangeProvider.notifier).state = Range(timeMax, timeMin);

      ref.read(isoSpeedStepProvider.notifier).state =
          _fractionalStopFromInt(isoSpeedStep);

      ref.read(sensitivityValueRangeProvider.notifier).state =
          Range(sensitivityMax, sensitivityMin);
    });
  }

  static String _roundNumber(double value) =>
      value.toStringAsFixed(1).padLeft(5);

  FractionalStop _fractionalStopFromInt(int value) => switch (value) {
        0 => FractionalStop.fullStop,
        1 => FractionalStop.oneHalfStop,
        _ => FractionalStop.oneThirdStop,
      };
}
