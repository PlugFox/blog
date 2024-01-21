import 'dart:async';

import 'package:backend/src/common/server/responses.dart';
import 'package:shelf/shelf.dart' as shelf;

FutureOr<shelf.Response> $healthCheck(shelf.Request request) => Responses.ok(null);
