// Copyright 2018 Workiva Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:async';
import 'dart:html';

import 'package:meta/meta.dart';
import 'package:over_react/over_react.dart' as ovr;
import 'package:react/react.dart' as react;
import 'package:react/react_dom.dart' as react_dom;

/// Provides utilities to instrument and measure component rendering performance of the provided [reactElement].
class SpeedJacket<T extends react.Component> {
  final ovr.ReactElement reactElement;
  final Element mountNode;

  SpeedJacket(this.reactElement, this.mountNode);

  Future<SpeedJacketReport> testInitialMount(SpeedJacketConfig config) {
    return new Future(() {
      // TODO: Should this be done in the JS layer for more accurate results?
      final stopwatch = new Stopwatch();
      int elapsedTimeInMicroseconds = 0;

      for (var i = 0; i < config.count; i++) {
        stopwatch.start();
        react_dom.render(reactElement, mountNode);
        stopwatch.stop();

        react_dom.unmountComponentAtNode(mountNode);

        elapsedTimeInMicroseconds += stopwatch.elapsedMicroseconds;
        stopwatch.reset();
      }

      // Tear down
      react_dom.unmountComponentAtNode(mountNode);

      return elapsedTimeInMicroseconds;
    }).then((int elapsedTimeInMicroseconds) {
      return new SpeedJacketReport._(
          config: config,
          totalDuration: new Duration(microseconds: elapsedTimeInMicroseconds),
          operationName: 'mount');
    });
  }

  Future<SpeedJacketReport> testRerender(SpeedJacketConfig config) {
    return new Future(() {
      // TODO: Should this be done in the JS layer for more accurate results?
      final stopwatch = new Stopwatch();
      int elapsedTimeInMicroseconds = 0;

      // Set up
      react_dom.render(reactElement, mountNode);

      for (var i = 0; i < config.count; i++) {
        stopwatch.start();
        react_dom.render(reactElement, mountNode);
        stopwatch.stop();

        elapsedTimeInMicroseconds += stopwatch.elapsedMicroseconds;
        stopwatch.reset();
      }

      // Clean up
      react_dom.unmountComponentAtNode(mountNode);

      return elapsedTimeInMicroseconds;
    }).then((int elapsedTimeInMicroseconds) {
      return new SpeedJacketReport._(
          config: config,
          totalDuration: new Duration(microseconds: elapsedTimeInMicroseconds),
          operationName: 'rerender');
    });
  }

  Future<SpeedJacketReport> testOperation<T>(String operationName, performOperation(T componentRef), SpeedJacketConfig config) {
    return new Future(() {
      final stopwatch = new Stopwatch();
      int elapsedTimeInMicroseconds = 0;

      // Set up
      react_dom.render(reactElement, mountNode);

      for (var i = 0; i < config.count; i++) {
        stopwatch.start();
        performOperation(ovr.getDartComponent(reactElement) as T);
        stopwatch.stop();
        elapsedTimeInMicroseconds += stopwatch.elapsedMicroseconds;
        stopwatch.reset();
      }

      // Tear down
      react_dom.unmountComponentAtNode(mountNode);

      return elapsedTimeInMicroseconds;
    }).then((int elapsedTimeInMicroseconds) {
      return new SpeedJacketReport._(
          config: config,
          totalDuration: new Duration(microseconds: elapsedTimeInMicroseconds.toInt()),
          operationName: operationName);
    });
  }

  Future<SpeedJacketReport> testUnmount(SpeedJacketConfig config) {
    return new Future(() {
      final stopwatch = new Stopwatch();
      int elapsedTimeInMicroseconds = 0;

      for (var i = 0; i < config.count; i++) {
        react_dom.render(reactElement, mountNode);

        stopwatch.start();
        react_dom.unmountComponentAtNode(mountNode);
        stopwatch.stop();
        elapsedTimeInMicroseconds += stopwatch.elapsedMicroseconds;
        stopwatch.reset();
      }

      return elapsedTimeInMicroseconds;
    }).then((int elapsedTimeInMicroseconds) {
      return new SpeedJacketReport._(
          config: config,
          totalDuration: new Duration(microseconds: elapsedTimeInMicroseconds),
          operationName: 'unmount');
    });
  }

  void unmount() {
    react_dom.unmountComponentAtNode(mountNode);
  }
}

class SpeedJacketReport {
  final SpeedJacketConfig config;

  SpeedJacketReport._({
    @required this.config,
    @required Duration totalDuration,
    @required String operationName,
  }) {
    _totalDuration = totalDuration;
    _operationName = operationName;
  }

  Duration _totalDuration;
  Duration get averageDuration => new Duration(microseconds: _totalDuration.inMicroseconds ~/ config.count);

  String _operationName;

  /// Returns an ID in a standardized format using the provided [testId] and the [_operationName].
  ///
  /// TODO: Does these need to be timestamped?
  String getTelemetryId(String testId) => '${testId}__$_operationName';
}

class SpeedJacketConfig {
  /// The number of times you want to execute a mount / rerender / etc.
  ///
  /// > Default: 100
  final int count;

  SpeedJacketConfig({this.count = 100});
}
