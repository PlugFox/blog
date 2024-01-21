import 'package:shelf/shelf.dart';

/// Injects a [secret] to the request context if
/// 'Authorization: Bearer <token>' is present in the request headers.
Middleware authorization(String? token) {
  final emptyToken = token == null || token.length < 6;
  return (innerHandler) => (request) {
        final authorization = switch (request.headers['Authorization'] ??
            request.headers['authorization'] ??
            request.url.queryParameters['token']) {
          String text when text.startsWith('Bearer ') => text.substring(7),
          String text => text,
          _ => null,
        };
        if (authorization != null || request.url.pathSegments.firstOrNull == 'admin') {
          if (emptyToken || authorization != token) return Response.unauthorized('Invalid token');
          return innerHandler(request.change(context: <String, Object>{...request.context, 'authorization': true}));
        } else {
          return innerHandler(request.change(context: <String, Object>{...request.context, 'authorization': false}));
        }
      };
}
