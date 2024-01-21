import 'dart:html' as html;

import 'package:meta/meta.dart';

abstract base class Component {
  Component() {
    initState();
  }

  @protected
  @mustCallSuper
  void initState() {}

  @protected
  @mustCallSuper
  void dispose() {}

  html.Element build();
}
