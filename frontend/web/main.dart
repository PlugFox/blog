// ignore_for_file: unnecessary_statements

import 'dart:async';
import 'dart:developer';
import 'dart:html' as html;

import 'package:frontend/frontend.dart' as f;
import 'package:l/l.dart';

void main() => l.capture(
      () => runZonedGuarded<void>(
        runApp,
        (error, stackTrace) => log(
          'Top level exception',
          error: error,
          stackTrace: stackTrace,
          level: 1000,
          name: 'main',
        ),
      ),
      LogOptions(
        handlePrint: true,
        outputInRelease: true,
        printColors: false,
        overrideOutput: _logPrinter(),
      ),
    );

String? Function(LogMessage) _logPrinter() => (event) => '[${event.level.prefix}] '
    '${event.timestamp.hour.toString().padLeft(2, '0')}:'
    '${event.timestamp.minute.toString().padLeft(2, '0')}:'
    '${event.timestamp.second.toString().padLeft(2, '0')} | '
    '${switch (event.message.toString()) {
      String msg when msg.length > 100 => '${msg.substring(0, 100 - 4)} ...',
      String msg => msg,
    }}';

/// Run app
void runApp() => Future<void>(() async {
      l.s('!!!!!!!!!!!!!!!!');
      // Wait for DOM to load
      if (html.document.readyState?.trim().toLowerCase() == 'loading') await html.window.onLoad.first;
      f.router; // Init and run router
      //l.v('api: "${Config.api}"');
      //const dev = String.fromEnvironment('dev', defaultValue: '-');
      //l.v('dev: "$dev"');
      //const env = String.fromEnvironment('env', defaultValue: '-');
      //l.v('env: "$env"');
      //html.window.alert('Hello, world!\n' 'API: ${Config.api}\n' 'dev: $dev\n' 'env: $env\n');
      //html.querySelector('router')
      //  ?..appendText('Hello, world! ')
      //  ..appendText('development: ${f.development} ')
      //  ..appendText('api: ${f.api} ');
    });
