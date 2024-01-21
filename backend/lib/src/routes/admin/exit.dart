import 'dart:async';
import 'dart:io' as io;

import 'package:backend/src/common/database/database.dart';
import 'package:backend/src/common/server/responses.dart';
import 'package:shelf/shelf.dart' as shelf;

/// Exits the server.
///
/// E.g. `http://127.0.0.1:8080/admin/exit?code=0`
FutureOr<shelf.Response> $exit(shelf.Request request) async {
  final database = request.context['DATABASE'] as Database;
  final code = switch (request.requestedUri.queryParameters['code']?.trim()) {
    String value when value.isNotEmpty => int.tryParse(value),
    _ => null,
  };
  Timer(const Duration(seconds: 1), () async {
    await database.close();
    io.exit((code ?? 2).clamp(0, 255));
  });
  return Responses.ok(null);
}
