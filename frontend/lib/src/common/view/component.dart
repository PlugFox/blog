import 'dart:html' as html;

import 'package:meta/meta.dart';

abstract base class Component {
  Component({String? key}) : element = html.DivElement() {
    if (key != null) element.id = key;
    initState();
    build(element);
  }

  final html.DivElement element;

  @protected
  @mustCallSuper
  void initState() {}

  @protected
  @mustCallSuper
  void dispose() {}

  @protected
  void rebuild() => build(element);

  @protected
  @mustBeOverridden
  void build(html.DivElement context);
}
