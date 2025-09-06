/*
 * setting_drawer.dart
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

import 'package:exposure_calculator/gui/slider_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../camera_parameters/constants.dart';
import '../camera_parameters/exposure_value.dart';
import '../provider/provider.dart';
import '../configs.dart';

const _keyFNumberStep = 'fNumberStep';
const _keyApertureMax = 'apertureMax';
const _keyApertureMin = 'apertureMin';
const _keyShutterSpeedStep = 'shutterSpeedStep';
const _keyTimeMax = 'timeMax';
const _keyTimeMin = 'timeMin';
const _keyIsoSpeedStep = 'isoSpeedStep';
const _keySensitivityMax = 'sensitivityMax';
const _keySensitivityMin = 'sensitivityMin';

class SettingDrawer extends ConsumerStatefulWidget {
  const SettingDrawer({super.key});

  @override
  ConsumerState<SettingDrawer> createState() => _SettingDrawerState();
}

class _SettingDrawerState extends ConsumerState<SettingDrawer> {
  final _prefs = SharedPreferencesAsync();

  @override
  Widget build(BuildContext context) {
    final cameraSettingsState = ref.watch(cameraSettingsProvider);
    final cameraSettingsNotifier = ref.watch(cameraSettingsProvider.notifier);
    // Sets button for aperture setting
    List<bool> fNumberStepTypeButtonSelection = FractionalStop.values
        .map((FractionalStop e) => e == cameraSettingsState.fNumberStep)
        .toList();

    // Sets button for shutter speed setting
    List<bool> shutterSpeedStepTypeButtonSelection = FractionalStop.values
        .map((FractionalStop e) => e == cameraSettingsState.shutterSpeedStep)
        .toList();

    // Sets button for shutter ISO setting
    List<bool> isoSpeedStepTypeButtonSelection = FractionalStop.values
        .map((FractionalStop e) => e == cameraSettingsState.isoSpeedStep)
        .toList();

    return Drawer(
        child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          child: Text(
            'Settings',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        const ListTile(title: Text('F Number')),
        ListTile(
          title: const Text('Step'),
          trailing: ToggleButtons(
            isSelected: fNumberStepTypeButtonSelection,
            onPressed: (int index) {
              cameraSettingsNotifier.update(
                  fNumberStep: switch (index) {
                0 => FractionalStop.fullStop,
                1 => FractionalStop.oneHalfStop,
                _ => FractionalStop.oneThirdStop,
              });
              _prefs.setInt(_keyFNumberStep, index);
            },
            constraints: const BoxConstraints(
              minHeight: 32.0,
              minWidth: 56.0,
            ),
            children: fractionalStopName
                .map(((FractionalStop, String) shirt) => Text(shirt.$2))
                .toList(),
          ),
        ),
        SliderListTile(
          text:
              'Max [${ExposureValue.findFNumber(value: cameraSettingsState.apertureValueRange.max)}]',
          value: cameraSettingsState.apertureValueRange.max,
          valueRange: initApertureValueRange,
          onChanged: (double value) {
            final range = cameraSettingsState.apertureValueRange;
            if (value > range.min) {
              cameraSettingsNotifier.update(
                  apertureValueRange: range.copyWith(max: value));
              _prefs.setDouble(_keyApertureMax, value);
            }
          },
        ),
        SliderListTile(
          text:
              'Min [${ExposureValue.findFNumber(value: cameraSettingsState.apertureValueRange.min)}]',
          value: cameraSettingsState.apertureValueRange.min,
          valueRange: initApertureValueRange,
          onChanged: (double value) {
            final range = cameraSettingsState.apertureValueRange;
            if (value < range.max) {
              cameraSettingsNotifier.update(
                  apertureValueRange: range.copyWith(min: value));
              _prefs.setDouble(_keyApertureMin, value);
            }
          },
        ),
        const Divider(),
        const ListTile(title: Text('Shutter Speed')),
        ListTile(
          title: const Text('Step'),
          trailing: ToggleButtons(
            isSelected: shutterSpeedStepTypeButtonSelection,
            onPressed: (int index) {
              cameraSettingsNotifier.update(
                  shutterSpeedStep: switch (index) {
                0 => FractionalStop.fullStop,
                1 => FractionalStop.oneHalfStop,
                _ => FractionalStop.oneThirdStop,
              });
              _prefs.setInt(_keyShutterSpeedStep, index);
            },
            // Constraints are used to determine the size of each child widget.
            constraints: const BoxConstraints(
              minHeight: 32.0,
              minWidth: 56.0,
            ),
            children: fractionalStopName
                .map(((FractionalStop, String) shirt) => Text(shirt.$2))
                .toList(),
          ),
        ),
        SliderListTile(
          text:
              'Max [${ExposureValue.findShutterSpeed(value: cameraSettingsState.timeValueRange.max)}]',
          value: cameraSettingsState.timeValueRange.max,
          valueRange: initTimeValueRange,
          onChanged: (double value) {
            final range = cameraSettingsState.timeValueRange;
            if (value > range.min) {
              cameraSettingsNotifier.update(
                  timeValueRange: range.copyWith(max: value));
              _prefs.setDouble(_keyTimeMax, value);
            }
          },
        ),
        SliderListTile(
          text:
              'Min [${ExposureValue.findShutterSpeed(value: cameraSettingsState.timeValueRange.min)}]',
          value: cameraSettingsState.timeValueRange.min,
          valueRange: initTimeValueRange,
          onChanged: (double value) {
            final range = cameraSettingsState.timeValueRange;
            if (value < range.max) {
              cameraSettingsNotifier.update(
                  timeValueRange: range.copyWith(min: value));
              _prefs.setDouble(_keyTimeMin, value);
            }
          },
        ),
        const Divider(),
        const ListTile(title: Text('ISO Speed')),
        ListTile(
          title: const Text('Step'),
          trailing: ToggleButtons(
            isSelected: isoSpeedStepTypeButtonSelection,
            onPressed: (int index) {
              cameraSettingsNotifier.update(
                  isoSpeedStep: switch (index) {
                0 => FractionalStop.fullStop,
                1 => FractionalStop.oneHalfStop,
                _ => FractionalStop.oneThirdStop,
              });
              _prefs.setInt(_keyIsoSpeedStep, index);
            },
            // Constraints are used to determine the size of each child widget.
            constraints: const BoxConstraints(
              minHeight: 32.0,
              minWidth: 56.0,
            ),
            children: fractionalStopName
                .map(((FractionalStop, String) shirt) => Text(shirt.$2))
                .toList(),
          ),
        ),
        SliderListTile(
          text:
              'Max [${ExposureValue.findIsoSpeed(value: cameraSettingsState.sensitivityValueRange.max)}]',
          value: cameraSettingsState.sensitivityValueRange.max,
          valueRange: initSensitivityValueRange,
          onChanged: (double value) {
            final range = cameraSettingsState.sensitivityValueRange;
            if (value > range.min) {
              cameraSettingsNotifier.update(
                  sensitivityValueRange: range.copyWith(max: value));
              _prefs.setDouble(_keySensitivityMax, value);
            }
          },
        ),
        SliderListTile(
          text:
              'Min [${ExposureValue.findIsoSpeed(value: cameraSettingsState.sensitivityValueRange.min)}]',
          value: cameraSettingsState.sensitivityValueRange.min,
          valueRange: initSensitivityValueRange,
          onChanged: (double value) {
            final range = cameraSettingsState.sensitivityValueRange;
            if (value < range.max) {
              cameraSettingsNotifier.update(
                  sensitivityValueRange: range.copyWith(min: value));
              _prefs.setDouble(_keySensitivityMin, value);
            }
          },
        ),
        const Divider(),
        ListTile(
          title: TextButton(
            child: const Align(
                alignment: Alignment.centerLeft,
                child: Text('Licenses', textAlign: TextAlign.left)),
            onPressed: () => showLicensePage(
                context: context,
                applicationIcon: Image.asset('assets/images/logo144x144.webp',
                    height: 64.0, width: 64.0),
                applicationName: appName,
                applicationVersion: applicationVersion,
                applicationLegalese: applicationLegalese),
          ),
        ),
      ],
    ));
  }
}
