import 'dart:async';
import 'dart:html' as html;

abstract interface class Page {
  static Future<String?> fetch(String page) => html.HttpRequest.getString('pages/$page.html').then(
        (value) => value.trim(),
        onError: (error) => null,
      );

  /// The name of the page
  String get title;

  /// Called when the page is opened
  FutureOr<void> create();

  /// Build the page and return the [String] or [html.Element] to be displayed.
  FutureOr<Object?> build();

  /// Called when the page is closed
  FutureOr<void> dispose();
}
