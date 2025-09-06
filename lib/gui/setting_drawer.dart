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
import '../camera_parameters/f_number.dart';
import '../camera_parameters/iso_speed.dart';
import '../camera_parameters/shutter_speed.dart';
import '../provider/provider.dart';
import '../configs.dart';
import '../utilities/range.dart';

class SettingDrawer extends ConsumerStatefulWidget {
  final VoidCallback onShowLicenses;

  const SettingDrawer({super.key, required this.onShowLicenses});

  @override
  ConsumerState<SettingDrawer> createState() => _SettingDrawerState();
}

class _SettingDrawerState extends ConsumerState<SettingDrawer> {
  final _prefs = SharedPreferencesAsync();

  Widget _buildStepSelector({
    required List<bool> isSelected,
    required void Function(int) onPressed,
  }) {
    return ListTile(
      title: const Text('Step'),
      trailing: ToggleButtons(
        isSelected: isSelected,
        onPressed: onPressed,
        constraints: const BoxConstraints(
          minHeight: 32.0,
          minWidth: 56.0,
        ),
        children: fractionalStopName
            .map(((FractionalStop, String) stopTuple) => Text(stopTuple.$2))
            .toList(),
      ),
    );
  }

  Widget _buildRangeSlider({
    required String labelPrefix,
    required String Function(double) valueLabelFormatter,
    required double currentValue,
    required Range valueRange,
    required void Function(double) onChanged,
  }) {
    return SliderListTile(
      text: '$labelPrefix [${valueLabelFormatter((currentValue))}]',
      value: currentValue,
      valueRange: valueRange,
      onChanged: onChanged,
    );
  }

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
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          child: Text(
            'Settings',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        const ListTile(title: Text('F Number')),
        _buildStepSelector(
          isSelected: fNumberStepTypeButtonSelection,
          onPressed: (int index) {
            if (index >= 0 && index < FractionalStop.values.length) {
              cameraSettingsNotifier.update(
                  fNumberStep: FractionalStop.values[index]);
              _prefs.setInt(PrefKeys.fNumberStep, index);
            }
          },
        ),
        _buildRangeSlider(
          labelPrefix: 'Max',
          valueLabelFormatter: (value) => FNumber.findLabel(value: value),
          currentValue: cameraSettingsState.apertureValueRange.max,
          valueRange: initApertureValueRange,
          onChanged: (double value) {
            final range = cameraSettingsState.apertureValueRange;
            if (value > range.min) {
              cameraSettingsNotifier.update(
                  apertureValueRange: range.copyWith(max: value));
              _prefs.setDouble(PrefKeys.apertureMax, value);
            }
          },
        ),
        _buildRangeSlider(
          labelPrefix: 'Min',
          valueLabelFormatter: (value) => FNumber.findLabel(value: value),
          currentValue: cameraSettingsState.apertureValueRange.min,
          valueRange: initApertureValueRange,
          onChanged: (double value) {
            final range = cameraSettingsState.apertureValueRange;
            if (value < range.max) {
              cameraSettingsNotifier.update(
                  apertureValueRange: range.copyWith(min: value));
              _prefs.setDouble(PrefKeys.apertureMin, value);
            }
          },
        ),
        const Divider(),
        const ListTile(title: Text('Shutter Speed')),
        _buildStepSelector(
          isSelected: shutterSpeedStepTypeButtonSelection,
          onPressed: (int index) {
            if (index >= 0 && index < FractionalStop.values.length) {
              cameraSettingsNotifier.update(
                  shutterSpeedStep: FractionalStop.values[index]);
              _prefs.setInt(PrefKeys.shutterSpeedStep, index);
            }
          },
        ),
        _buildRangeSlider(
          labelPrefix: 'Max',
          valueLabelFormatter: (value) => ShutterSpeed.findLabel(value: value),
          currentValue: cameraSettingsState.timeValueRange.max,
          valueRange: initTimeValueRange,
          onChanged: (double value) {
            final range = cameraSettingsState.timeValueRange;
            if (value > range.min) {
              cameraSettingsNotifier.update(
                  timeValueRange: range.copyWith(max: value));
              _prefs.setDouble(PrefKeys.timeMax, value);
            }
          },
        ),
        _buildRangeSlider(
          labelPrefix: 'Min',
          valueLabelFormatter: (value) => ShutterSpeed.findLabel(value: value),
          currentValue: cameraSettingsState.timeValueRange.min,
          valueRange: initTimeValueRange,
          onChanged: (double value) {
            final range = cameraSettingsState.timeValueRange;
            if (value < range.max) {
              cameraSettingsNotifier.update(
                  timeValueRange: range.copyWith(min: value));
              _prefs.setDouble(PrefKeys.timeMin, value);
            }
          },
        ),
        const Divider(),
        const ListTile(title: Text('ISO Speed')),
        _buildStepSelector(
          isSelected: isoSpeedStepTypeButtonSelection,
          onPressed: (int index) {
            if (index >= 0 && index < FractionalStop.values.length) {
              cameraSettingsNotifier.update(
                  isoSpeedStep: FractionalStop.values[index]);
              _prefs.setInt(PrefKeys.isoSpeedStep, index);
            }
          },
        ),
        _buildRangeSlider(
          labelPrefix: 'Max',
          valueLabelFormatter: (value) => IsoSpeed.findLabel(value: value),
          currentValue: cameraSettingsState.sensitivityValueRange.max,
          valueRange: initSensitivityValueRange,
          onChanged: (double value) {
            final range = cameraSettingsState.sensitivityValueRange;
            if (value > range.min) {
              cameraSettingsNotifier.update(
                  sensitivityValueRange: range.copyWith(max: value));
              _prefs.setDouble(PrefKeys.sensitivityMax, value);
            }
          },
        ),
        _buildRangeSlider(
          labelPrefix: 'Min',
          valueLabelFormatter: (value) => IsoSpeed.findLabel(value: value),
          currentValue: cameraSettingsState.sensitivityValueRange.min,
          valueRange: initSensitivityValueRange,
          onChanged: (double value) {
            final range = cameraSettingsState.sensitivityValueRange;
            if (value < range.max) {
              cameraSettingsNotifier.update(
                  sensitivityValueRange: range.copyWith(min: value));
              _prefs.setDouble(PrefKeys.sensitivityMin, value);
            }
          },
        ),
        const Divider(),
        ListTile(
          title: TextButton(
            onPressed: widget.onShowLicenses,
            child: const Align(
                alignment: Alignment.centerLeft,
                child: Text('Licenses', textAlign: TextAlign.left)),
          ),
        ),
      ],
    ));
  }
}
