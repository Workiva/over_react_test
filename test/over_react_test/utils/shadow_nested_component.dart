// @dart = 2.14
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

import 'dart:html';

import 'package:over_react/over_react.dart';
import 'package:over_react/react_dom.dart' as react_dom;

part 'shadow_nested_component.over_react.g.dart';

mixin ShadowNestedProps on UiProps {
  String? shadowRootHostTestId;
  String? shadowRootFirstChildTestId;
}

UiFactory<ShadowNestedProps> ShadowNested = uiForwardRef(
  (props, ref) {
    final divRef = useRef<DivElement>();

    useEffect(() {
	      var shadowRootFirstChild = DivElement()..dataset['test-id'] = props.shadowRootFirstChildTestId ?? 'shadowRootFirstChild';
	      divRef.current!.attachShadow({'mode':'open'}).append(shadowRootFirstChild);
	      react_dom.render(Fragment()(props.children), shadowRootFirstChild);
	      return () => react_dom.unmountComponentAtNode(shadowRootFirstChild);
	    }, []);

    return (Dom.div()..addTestId(props.shadowRootHostTestId ?? 'shadowRootHost')..ref = chainRefs(ref, divRef))();
  },
  _$ShadowNestedConfig, // ignore: undefined_identifier
);
