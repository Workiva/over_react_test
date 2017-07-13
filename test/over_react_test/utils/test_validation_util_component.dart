// Copyright 2017 Workiva Inc.
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

import 'package:over_react/over_react.dart';

@Factory()
UiFactory<TestValidationWarningsProps> TestValidationWarnings;

@Props()
class TestValidationWarningsProps extends UiProps {
  bool emitFirstWarning;
  bool emitSecondWarning;
}

@Component()
class TestValidationWarningsComponent extends UiComponent<TestValidationWarningsProps> {
  @override
  Map getDefaultProps() => (newProps()
    ..emitFirstWarning = true
    ..emitSecondWarning = false
  );

  @override
  componentDidMount() {
    if (props.emitFirstWarning) {
      assert(ValidationUtil.warn('message1', this));
    }

    if (props.emitSecondWarning) {
      assert(ValidationUtil.warn('message2', this));
    }
  }

  @override
  componentWillReceiveProps(Map nextProps) {
    super.componentWillReceiveProps(nextProps);

    if (typedPropsFactory(nextProps).emitSecondWarning && !props.emitSecondWarning) {
      assert(ValidationUtil.warn('message2', this));
    }
  }

  @override
  render() => false;
}
