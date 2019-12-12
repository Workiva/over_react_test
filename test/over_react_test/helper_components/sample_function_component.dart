// Copyright 2019 Workiva Inc.
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

import 'package:js/js.dart';
import 'package:react/react.dart' as react;
import 'package:react/react_client/react_interop.dart';
import 'package:react/react_client/js_backed_map.dart';

final testFunctionComponent = ([Map props = const {}]) => React.createElement(allowInterop((jsProps, _) {
  return react.div({...JsBackedMap.fromJs(jsProps), 'isRenderResult': true});
}), JsBackedMap.from(props).jsObject);

// TODO: Replace the above code with the registerFunctionComponent version below once react 5.3.0 is released.
//final testFunctionComponent = react.registerFunctionComponent(_TestFunctionComponent,
//  displayName: 'testFunctionComponent');
//
//_TestFunctionComponent(Map props) {
//  return react.div({...props, 'isRenderResult': true});
//}
