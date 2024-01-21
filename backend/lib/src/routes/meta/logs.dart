import 'dart:async';

import 'package:backend/src/common/database/database.dart';
import 'package:backend/src/common/server/responses.dart';
import 'package:shared/shared.dart' as shared;
import 'package:shelf/shelf.dart' as shelf;

/// Returns the last 10000 logs from the database.
///
/// If the query parameter `verbose` is set, only logs with a level equal or smaller than the given value are returned.
/// The value must be an integer between 0 and 6.
///
/// If 'pretty' is set, the response is formatted as a human readable string.
///
/// E.g. `http://127.0.0.1:8080/meta/logs?verbose=3&pretty`
FutureOr<shelf.Response> $logs(shelf.Request request) async {
  final database = request.context['DATABASE'] as Database;
  final verbose = switch (request.requestedUri.queryParameters['verbose']?.trim()) {
    String v when v.isNotEmpty => int.tryParse(v)?.clamp(0, 6),
    _ => null,
  };
  var select = database.select(database.logTbl);
  if (verbose != null && verbose < 6) select.where((tbl) => tbl.level.isSmallerOrEqualValue(verbose));
  final logsDB = await (select
        ..limit(10000)
        ..orderBy([
          (tbl) => OrderingTerm(expression: tbl.timestamp, mode: OrderingMode.desc),
        ]))
      .get();
  final logsIterable =
      logsDB.map<Uint8List>((l) => l.data).map<shared.LogMessage>(shared.LogMessage.fromBuffer).toList(growable: false);
  switch (request.requestedUri.queryParameters['pretty']?.trim().toLowerCase()) {
    case null || 'false':
      return Responses.ok(
        <String, Object?>{
          'logs': <Object?>[
            for (final log in logsIterable)
              <String, Object?>{
                'timestamp': log.timestamp,
                'level': log.level,
                'prefix': log.prefix,
                'message': log.message,
                if (log.hasStacktrace()) 'stacktrace': log.stacktrace,
                if (log.context.isNotEmpty) 'context': log.context,
              },
          ],
        },
      );
    default:
      final buffer = StringBuffer();
      const separator = ' | ';
      for (final log in logsIterable) {
        buffer
          ..write(DateTime.fromMillisecondsSinceEpoch(log.timestamp * 1000))
          ..write(separator)
          ..write(log.prefix) //..write('[${log.prefix}]')
          ..write(separator)
          ..write(log.message)
          ..writeln();
      }
      return Responses.ok(buffer.toString());
  }
}
