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
/// E.g. `http://127.0.0.1:8080/admin/logs?verbose=3&format=pretty`
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
  final logsList =
      logsDB.map<Uint8List>((l) => l.data).map<shared.LogMessage>(shared.LogMessage.fromBuffer).toList(growable: false);
  switch (request.requestedUri.queryParameters['format']?.trim().toLowerCase()) {
    case 'json':
      return Responses.ok(
        <String, Object?>{
          'logs': <Object?>[
            for (final log in logsList) log.toProto3Json(),
          ],
          'count': logsList.length,
        },
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
        },
      );
    case 'pretty' || 'csv' || 'tsv' || 'human':
      final buffer = StringBuffer();
      const separator = ',';
      for (final log in logsList) {
        buffer
          ..write(DateTime.fromMillisecondsSinceEpoch(log.timestamp * 1000))
          ..write(separator)
          ..write(log.prefix) //..write('[${log.prefix}]')
          ..write(separator)
          ..write(log.message)
          ..writeln();
      }
      return Responses.ok(
        buffer.toString(),
        headers: <String, String>{
          'Content-Type': 'text/plain; charset=utf-8',
        },
      );
    case 'proto' || 'protobuf':
    default:
      return Responses.ok(
        shared.LogMessages(
          logs: logsList,
          count: logsList.length,
        ).writeToBuffer(),
      );
  }
}
