import 'dart:async';

import 'package:backend/src/common/server/responses.dart';
import 'package:shelf/shelf.dart' as shelf;

FutureOr<shelf.Response> $notFound(shelf.Request request) => Responses.error(
      NotFoundException(data: <String, Object?>{
        'path': request.url.path,
        'query': request.url.queryParameters,
        'method': request.method,
        'headers': request.headers,
      }),
    );
