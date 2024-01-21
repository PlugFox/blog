import 'package:frontend/src/common/controller/droppable_controller_handler.dart';
import 'package:frontend/src/common/controller/state_controller.dart';
import 'package:frontend/src/feature/articles/data/articles_repository.dart';
import 'package:meta/meta.dart';
import 'package:shared/shared.dart';

/// {@template articles}
/// ArticlesState.
/// {@endtemplate}
sealed class ArticlesState extends _$ArticlesStateBase {
  /// Idling state
  /// {@macro articles}
  const factory ArticlesState.idle({
    required List<Article> data,
    String message,
  }) = ArticlesState$Idle;

  /// Processing
  /// {@macro articles}
  const factory ArticlesState.processing({
    required List<Article> data,
    String message,
  }) = ArticlesState$Processing;

  /// Successful
  /// {@macro articles}
  const factory ArticlesState.successful({
    required List<Article> data,
    String message,
  }) = ArticlesState$Successful;

  /// An error has occurred
  /// {@macro articles}
  const factory ArticlesState.error({
    required List<Article> data,
    String message,
  }) = ArticlesState$Error;

  /// {@macro articles}
  const ArticlesState({required super.data, required super.message});
}

/// Idling state
final class ArticlesState$Idle extends ArticlesState {
  const ArticlesState$Idle({required super.data, super.message = 'Idling'});
}

/// Processing
final class ArticlesState$Processing extends ArticlesState {
  const ArticlesState$Processing({required super.data, super.message = 'Processing'});
}

/// Successful
final class ArticlesState$Successful extends ArticlesState {
  const ArticlesState$Successful({required super.data, super.message = 'Successful'});
}

/// Error
final class ArticlesState$Error extends ArticlesState {
  const ArticlesState$Error({required super.data, super.message = 'An error has occurred.'});
}

/// Pattern matching for [ArticlesState].
typedef ArticlesStateMatch<R, S extends ArticlesState> = R Function(S state);

@immutable
abstract base class _$ArticlesStateBase {
  const _$ArticlesStateBase({required this.data, required this.message});

  /// Data entity payload.
  @nonVirtual
  final List<Article> data;

  /// Message or state description.
  @nonVirtual
  final String message;

  /// If an error has occurred?
  bool get hasError => maybeMap<bool>(orElse: () => false, error: (_) => true);

  /// Is in progress state?
  bool get isProcessing => maybeMap<bool>(orElse: () => false, processing: (_) => true);

  /// Is in idle state?
  bool get isIdling => !isProcessing;

  /// Pattern matching for [ArticlesState].
  R map<R>({
    required ArticlesStateMatch<R, ArticlesState$Idle> idle,
    required ArticlesStateMatch<R, ArticlesState$Processing> processing,
    required ArticlesStateMatch<R, ArticlesState$Successful> successful,
    required ArticlesStateMatch<R, ArticlesState$Error> error,
  }) =>
      switch (this) {
        ArticlesState$Idle s => idle(s),
        ArticlesState$Processing s => processing(s),
        ArticlesState$Successful s => successful(s),
        ArticlesState$Error s => error(s),
        _ => throw AssertionError(),
      };

  /// Pattern matching for [ArticlesState].
  R maybeMap<R>({
    required R Function() orElse,
    ArticlesStateMatch<R, ArticlesState$Idle>? idle,
    ArticlesStateMatch<R, ArticlesState$Processing>? processing,
    ArticlesStateMatch<R, ArticlesState$Successful>? successful,
    ArticlesStateMatch<R, ArticlesState$Error>? error,
  }) =>
      map<R>(
        idle: idle ?? (_) => orElse(),
        processing: processing ?? (_) => orElse(),
        successful: successful ?? (_) => orElse(),
        error: error ?? (_) => orElse(),
      );

  /// Pattern matching for [ArticlesState].
  R? mapOrNull<R>({
    ArticlesStateMatch<R, ArticlesState$Idle>? idle,
    ArticlesStateMatch<R, ArticlesState$Processing>? processing,
    ArticlesStateMatch<R, ArticlesState$Successful>? successful,
    ArticlesStateMatch<R, ArticlesState$Error>? error,
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
  String toString() => 'ArticlesState(data: $data, message: $message)';
}

final class ArticlesController extends StateController<ArticlesState> with DroppableControllerHandler {
  ArticlesController({required IArticlesRepository repository, ArticlesState? initialState})
      : _repository = repository,
        super(initialState: initialState ?? const ArticlesState.idle(data: <Article>[]));

  final IArticlesRepository _repository;

  void fetch() => handle(
        () async {
          setState(const ArticlesState.processing(data: <Article>[]));
          final articles = await _repository.fetch(
            from: state.data.lastOrNull?.createdAt,
            limit: 100,
          );
          setState(ArticlesState.successful(data: [...state.data, ...articles]));
        },
        (error, stackTrace) => setState(ArticlesState.error(data: state.data, message: error.toString())),
        () => setState(ArticlesState.idle(data: state.data)),
      );
}
