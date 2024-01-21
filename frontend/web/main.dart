import 'dart:async';
import 'dart:developer';
import 'dart:html' as html;

import 'package:frontend/src/feature/articles/view/articles_list.dart';

void main() => runZonedGuarded<Future<void>>(
      () async {
        void runApp() {
          html.document.body?.append(ArticlesComponent().element);
        }

        if (html.document.readyState?.trim().toLowerCase() == 'complete') {
          runApp();
        } else {
          html.window.onLoad.listen((_) => runApp());
        }
      },
      (error, stackTrace) => log(
        'Top level exception',
        error: error,
        stackTrace: stackTrace,
        level: 1000,
        name: 'main',
      ),
    );
