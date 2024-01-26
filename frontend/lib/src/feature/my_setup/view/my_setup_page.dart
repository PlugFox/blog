import 'dart:async';

import 'package:frontend/src/common/view/page.dart';

final class MySetupPage implements Page {
  MySetupPage();

  @override
  String get title => 'My Setup';

  @override
  void create() {}

  @override
  Future<String?> build() => Page.fetch('my-setup');

  @override
  void dispose() {}
}
