import 'package:l/l.dart';
import 'package:shelf/shelf.dart' as shelf;

/// Middleware which prints the time of the request, the elapsed time for the
/// inner handlers, the response's status code and the request URI.
///
/// If [logger] is passed, it's called for each request. The `msg` parameter is
/// a formatted string that includes the request time, duration, request method,
/// and requested path. When an exception is thrown, it also includes the
/// exception's string and stack trace; otherwise, it includes the status code.
/// The `isError` parameter indicates whether the message is caused by an error.
shelf.Middleware logPipeline() => shelf.logRequests(logger: (msg, isError) => isError ? l.w(msg) : l.d(msg));
