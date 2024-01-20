import 'package:shelf/shelf.dart';

/// Injects a [secret] to the request context if
/// 'Authorization: Bearer <secret>' is present in the request headers.
Middleware authorization() =>
    (innerHandler) => (request) => switch (request.headers['Authorization'] ?? request.headers['authorization']) {
          String token when token.startsWith('Bearer ') => innerHandler(
              request.change(
                context: <String, Object>{
                  ...request.context,
                  'secret': token.substring(7),
                },
              ),
            ),
          String token => innerHandler(
              request.change(
                context: <String, Object>{
                  ...request.context,
                  'secret': token,
                },
              ),
            ),
          null => innerHandler(request),
        };
