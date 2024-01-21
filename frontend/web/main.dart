import 'dart:html' as html;

import 'package:http/browser_client.dart';

void main() {
  html.querySelector('#output')?.text = 'Your Dart app is running.';
  final client = BrowserClient(); // ignore: unused_local_variable
}
