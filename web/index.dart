
import 'dart:html';

import 'package:over_react/over_react.dart';
import 'package:over_react/react_dom.dart';


import 'package:over_react/react_dom.dart';

main() {

  enableTestMode();
  render(ShadowNested()(), document.querySelector('#output'));
}
// Copyright 2021 Workiva Inc.
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



UiFactory<UiProps> ShadowNested = uiFunction(
  (props) {
    final divRef = useRef<DivElement>();

    useEffect(() {
      if (divRef.current.shadowRoot == null) {
        var inner = DivElement();
        divRef.current.attachShadow({'mode':'open'}).append(inner);
        render((Dom.div()
          ..addTestId('inner')
        )(), inner);
      }
    });

    return (Dom.div()..addTestId('shadow')..ref = divRef)();
  },
  UiFactoryConfig(displayName: 'ShadowNested'), // ignore: undefined_identifier
);

UiFactory<UiProps> DeeplyShadowNested = uiFunction(
  (props) {
    final firstShadowDivRef = useRef<DivElement>();

    useEffect(() {
      if (firstShadowDivRef.current.shadowRoot == null) {
        var level1Div = DivElement();
        var level2Div = DivElement();
        var level2DivSibling = DivElement()..dataset['test-id'] = 'deeplyNested';
        var level3Div = DivElement();
        var level0Shadow = firstShadowDivRef.current.attachShadow({'mode':'open'});
        level0Shadow.append(level1Div);

        level1Div.append(level2Div);
        level1Div.append(level2DivSibling);

        var level2Shadow = level2Div.attachShadow({'mode':'open'});
        level2Shadow.append(level3Div);

        render((Dom.div()
          ..addTestId('deeplyNested')
        )(), level3Div);
      }
    });

    return (Dom.div()
      ..addTestId('firstShadow')
      ..ref = firstShadowDivRef
    )();
  },
  UiFactoryConfig(displayName: 'DeeplyShadowNested'), // ignore: undefined_identifier
);
