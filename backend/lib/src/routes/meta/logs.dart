import 'dart:async';

import 'package:backend/src/common/database/database.dart';
import 'package:backend/src/common/server/responses.dart';
import 'package:shelf/shelf.dart' as shelf;

FutureOr<shelf.Response> $logs(shelf.Request request) async {
  final database = request.context['DATABASE'] as Database;
  final logs = await (database.select(database.logTbl)
        ..limit(10000)
        ..orderBy([
          (tbl) => OrderingTerm(expression: tbl.timestamp, mode: OrderingMode.desc),
        ]))
      .get();
  return Responses.ok(
    <String, Object?>{
      'logs': <Object?>[
        for (final log in logs)
          <String, Object?>{
            'timestamp': log.timestamp,
            'level': log.level,
            'message': log.message,
            if (log.stacktrace != null) 'stackTrace': log.stacktrace,
          },
      ],
    },
  );
}
