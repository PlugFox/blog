import 'package:frontend/src/common/controller/droppable_controller_handler.dart';
import 'package:frontend/src/common/controller/state_controller.dart';
import 'package:frontend/src/feature/articles/data/articles_repository.dart';
import 'package:meta/meta.dart';
import 'package:shared/shared.dart';

/// {@template article}
/// ArticleState.
/// {@endtemplate}
sealed class ArticleState extends _$ArticleStateBase {
  /// Idling state
  /// {@macro article}
  const factory ArticleState.idle({
    required Article data,
    String message,
  }) = ArticleState$Idle;

  /// Processing
  /// {@macro article}
  const factory ArticleState.processing({
    required Article data,
    String message,
  }) = ArticleState$Processing;

  /// Successful
  /// {@macro article}
  const factory ArticleState.successful({
    required Article data,
    String message,
  }) = ArticleState$Successful;

  /// An error has occurred
  /// {@macro article}
  const factory ArticleState.error({
    required Article data,
    String message,
  }) = ArticleState$Error;

  /// {@macro article}
  const ArticleState({required super.data, required super.message});
}

/// Idling state
/// {@nodoc}
final class ArticleState$Idle extends ArticleState {
  /// {@nodoc}
  const ArticleState$Idle({required super.data, super.message = 'Idling'});
}

/// Processing
/// {@nodoc}
final class ArticleState$Processing extends ArticleState {
  /// {@nodoc}
  const ArticleState$Processing({required super.data, super.message = 'Processing'});
}

/// Successful
/// {@nodoc}
final class ArticleState$Successful extends ArticleState {
  /// {@nodoc}
  const ArticleState$Successful({required super.data, super.message = 'Successful'});
}

/// Error
/// {@nodoc}
final class ArticleState$Error extends ArticleState {
  /// {@nodoc}
  const ArticleState$Error({required super.data, super.message = 'An error has occurred.'});
}

/// Pattern matching for [ArticleState].
typedef ArticleStateMatch<R, S extends ArticleState> = R Function(S state);

/// {@nodoc}
@immutable
abstract base class _$ArticleStateBase {
  /// {@nodoc}
  const _$ArticleStateBase({required this.data, required this.message});

  /// Data entity payload.
  @nonVirtual
  final Article data;

  /// Message or state description.
  @nonVirtual
  final String message;

  /// If an error has occurred?
  bool get hasError => maybeMap<bool>(orElse: () => false, error: (_) => true);

  /// Is in progress state?
  bool get isProcessing => maybeMap<bool>(orElse: () => false, processing: (_) => true);

  /// Is in idle state?
  bool get isIdling => !isProcessing;

  /// Pattern matching for [ArticleState].
  R map<R>({
    required ArticleStateMatch<R, ArticleState$Idle> idle,
    required ArticleStateMatch<R, ArticleState$Processing> processing,
    required ArticleStateMatch<R, ArticleState$Successful> successful,
    required ArticleStateMatch<R, ArticleState$Error> error,
  }) =>
      switch (this) {
        ArticleState$Idle s => idle(s),
        ArticleState$Processing s => processing(s),
        ArticleState$Successful s => successful(s),
        ArticleState$Error s => error(s),
        _ => throw AssertionError(),
      };

  /// Pattern matching for [ArticleState].
  R maybeMap<R>({
    required R Function() orElse,
    ArticleStateMatch<R, ArticleState$Idle>? idle,
    ArticleStateMatch<R, ArticleState$Processing>? processing,
    ArticleStateMatch<R, ArticleState$Successful>? successful,
    ArticleStateMatch<R, ArticleState$Error>? error,
  }) =>
      map<R>(
        idle: idle ?? (_) => orElse(),
        processing: processing ?? (_) => orElse(),
        successful: successful ?? (_) => orElse(),
        error: error ?? (_) => orElse(),
      );

  /// Pattern matching for [ArticleState].
  R? mapOrNull<R>({
    ArticleStateMatch<R, ArticleState$Idle>? idle,
    ArticleStateMatch<R, ArticleState$Processing>? processing,
    ArticleStateMatch<R, ArticleState$Successful>? successful,
    ArticleStateMatch<R, ArticleState$Error>? error,
  }) =>
      map<R?>(
        idle: idle ?? (_) => null,
        processing: processing ?? (_) => null,
        successful: successful ?? (_) => null,
        error: error ?? (_) => null,
      );

  @override
  int get hashCode => data.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other);

  @override
  String toString() => 'ArticleState(data: $data, message: $message)';
}

final class ArticleController extends StateController<ArticleState> with DroppableControllerHandler {
  ArticleController({required IArticlesRepository repository, required ArticleState initialState})
      : _repository = repository,
        super(initialState: initialState);

  final IArticlesRepository _repository;

  void fetch() => handle(
        () async {
          setState(ArticleState.processing(data: state.data));
          final article = await _repository.getById(state.data.id);
          setState(ArticleState.successful(data: article));
        },
        (error, stackTrace) => setState(ArticleState.error(data: state.data, message: error.toString())),
        () => setState(ArticleState.idle(data: state.data)),
      );
}
