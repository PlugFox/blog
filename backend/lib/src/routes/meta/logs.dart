import 'dart:async';

import 'package:backend/src/common/database/database.dart';
import 'package:backend/src/common/server/responses.dart';
import 'package:shared/shared.dart' as shared;
import 'package:shelf/shelf.dart' as shelf;

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
}
