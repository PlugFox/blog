//
//  Generated code. Do not modify.
//  source: api.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

enum Response_Data { string, bytes, article, articles, notSet }

/// Response represents a response from API.
class Response extends $pb.GeneratedMessage {
  factory Response({
    $core.String? status,
    $core.String? error,
    $core.String? string,
    $core.List<$core.int>? bytes,
    Article? article,
    Articles? articles,
    $core.Map<$core.String, $core.String>? meta,
  }) {
    final $result = create();
    if (status != null) {
      $result.status = status;
    }
    if (error != null) {
      $result.error = error;
    }
    if (string != null) {
      $result.string = string;
    }
    if (bytes != null) {
      $result.bytes = bytes;
    }
    if (article != null) {
      $result.article = article;
    }
    if (articles != null) {
      $result.articles = articles;
    }
    if (meta != null) {
      $result.meta.addAll(meta);
    }
    return $result;
  }
  Response._() : super();
  factory Response.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Response.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, Response_Data> _Response_DataByTag = {
    3: Response_Data.string,
    4: Response_Data.bytes,
    5: Response_Data.article,
    6: Response_Data.articles,
    0: Response_Data.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'blog.api'), createEmptyInstance: create)
    ..oo(0, [3, 4, 5, 6])
    ..aOS(1, _omitFieldNames ? '' : 'status')
    ..aOS(2, _omitFieldNames ? '' : 'error')
    ..aOS(3, _omitFieldNames ? '' : 'string')
    ..a<$core.List<$core.int>>(4, _omitFieldNames ? '' : 'bytes', $pb.PbFieldType.OY)
    ..aOM<Article>(5, _omitFieldNames ? '' : 'article', subBuilder: Article.create)
    ..aOM<Articles>(6, _omitFieldNames ? '' : 'articles', subBuilder: Articles.create)
    ..m<$core.String, $core.String>(1000, _omitFieldNames ? '' : 'meta',
        entryClassName: 'Response.MetaEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('blog.api'))
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Response clone() => Response()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Response copyWith(void Function(Response) updates) =>
      super.copyWith((message) => updates(message as Response)) as Response;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Response create() => Response._();
  Response createEmptyInstance() => create();
  static $pb.PbList<Response> createRepeated() => $pb.PbList<Response>();
  @$core.pragma('dart2js:noInline')
  static Response getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Response>(create);
  static Response? _defaultInstance;

  Response_Data whichData() => _Response_DataByTag[$_whichOneof(0)]!;
  void clearData() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get status => $_getSZ(0);
  @$pb.TagNumber(1)
  set status($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get error => $_getSZ(1);
  @$pb.TagNumber(2)
  set error($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasError() => $_has(1);
  @$pb.TagNumber(2)
  void clearError() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get string => $_getSZ(2);
  @$pb.TagNumber(3)
  set string($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasString() => $_has(2);
  @$pb.TagNumber(3)
  void clearString() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get bytes => $_getN(3);
  @$pb.TagNumber(4)
  set bytes($core.List<$core.int> v) {
    $_setBytes(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasBytes() => $_has(3);
  @$pb.TagNumber(4)
  void clearBytes() => clearField(4);

  @$pb.TagNumber(5)
  Article get article => $_getN(4);
  @$pb.TagNumber(5)
  set article(Article v) {
    setField(5, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasArticle() => $_has(4);
  @$pb.TagNumber(5)
  void clearArticle() => clearField(5);
  @$pb.TagNumber(5)
  Article ensureArticle() => $_ensure(4);

  @$pb.TagNumber(6)
  Articles get articles => $_getN(5);
  @$pb.TagNumber(6)
  set articles(Articles v) {
    setField(6, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasArticles() => $_has(5);
  @$pb.TagNumber(6)
  void clearArticles() => clearField(6);
  @$pb.TagNumber(6)
  Articles ensureArticles() => $_ensure(5);

  @$pb.TagNumber(1000)
  $core.Map<$core.String, $core.String> get meta => $_getMap(6);
}

/// Error represents an error returned by API.
class Error extends $pb.GeneratedMessage {
  factory Error({
    $core.int? status,
    $core.String? code,
    $core.String? message,
    $core.Map<$core.String, $core.String>? details,
  }) {
    final $result = create();
    if (status != null) {
      $result.status = status;
    }
    if (code != null) {
      $result.code = code;
    }
    if (message != null) {
      $result.message = message;
    }
    if (details != null) {
      $result.details.addAll(details);
    }
    return $result;
  }
  Error._() : super();
  factory Error.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Error.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Error',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'blog.api'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OU3)
    ..aOS(2, _omitFieldNames ? '' : 'code')
    ..aOS(3, _omitFieldNames ? '' : 'message')
    ..m<$core.String, $core.String>(4, _omitFieldNames ? '' : 'details',
        entryClassName: 'Error.DetailsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('blog.api'))
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Error clone() => Error()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Error copyWith(void Function(Error) updates) => super.copyWith((message) => updates(message as Error)) as Error;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Error create() => Error._();
  Error createEmptyInstance() => create();
  static $pb.PbList<Error> createRepeated() => $pb.PbList<Error>();
  @$core.pragma('dart2js:noInline')
  static Error getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Error>(create);
  static Error? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get status => $_getIZ(0);
  @$pb.TagNumber(1)
  set status($core.int v) {
    $_setUnsignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get code => $_getSZ(1);
  @$pb.TagNumber(2)
  set code($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearCode() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get message => $_getSZ(2);
  @$pb.TagNumber(3)
  set message($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasMessage() => $_has(2);
  @$pb.TagNumber(3)
  void clearMessage() => clearField(3);

  @$pb.TagNumber(4)
  $core.Map<$core.String, $core.String> get details => $_getMap(3);
}

/// Article represents a blog article.
class Article extends $pb.GeneratedMessage {
  factory Article({
    $core.String? id,
    $core.String? title,
    $core.String? link,
    $core.String? author,
    $core.Iterable<$core.String>? tags,
    $core.int? createdAt,
    $core.int? updatedAt,
    $core.String? excerpt,
    $core.String? content,
    $core.Map<$core.String, $core.String>? meta,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (title != null) {
      $result.title = title;
    }
    if (link != null) {
      $result.link = link;
    }
    if (author != null) {
      $result.author = author;
    }
    if (tags != null) {
      $result.tags.addAll(tags);
    }
    if (createdAt != null) {
      $result.createdAt = createdAt;
    }
    if (updatedAt != null) {
      $result.updatedAt = updatedAt;
    }
    if (excerpt != null) {
      $result.excerpt = excerpt;
    }
    if (content != null) {
      $result.content = content;
    }
    if (meta != null) {
      $result.meta.addAll(meta);
    }
    return $result;
  }
  Article._() : super();
  factory Article.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Article.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Article',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'blog.api'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'link')
    ..aOS(4, _omitFieldNames ? '' : 'author')
    ..pPS(5, _omitFieldNames ? '' : 'tags')
    ..a<$core.int>(6, _omitFieldNames ? '' : 'createdAt', $pb.PbFieldType.OU3, protoName: 'createdAt')
    ..a<$core.int>(7, _omitFieldNames ? '' : 'updatedAt', $pb.PbFieldType.OU3, protoName: 'updatedAt')
    ..aOS(8, _omitFieldNames ? '' : 'excerpt')
    ..aOS(9, _omitFieldNames ? '' : 'content')
    ..m<$core.String, $core.String>(1000, _omitFieldNames ? '' : 'meta',
        entryClassName: 'Article.MetaEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('blog.api'))
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Article clone() => Article()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Article copyWith(void Function(Article) updates) =>
      super.copyWith((message) => updates(message as Article)) as Article;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Article create() => Article._();
  Article createEmptyInstance() => create();
  static $pb.PbList<Article> createRepeated() => $pb.PbList<Article>();
  @$core.pragma('dart2js:noInline')
  static Article getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Article>(create);
  static Article? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get link => $_getSZ(2);
  @$pb.TagNumber(3)
  set link($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasLink() => $_has(2);
  @$pb.TagNumber(3)
  void clearLink() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get author => $_getSZ(3);
  @$pb.TagNumber(4)
  set author($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasAuthor() => $_has(3);
  @$pb.TagNumber(4)
  void clearAuthor() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.String> get tags => $_getList(4);

  @$pb.TagNumber(6)
  $core.int get createdAt => $_getIZ(5);
  @$pb.TagNumber(6)
  set createdAt($core.int v) {
    $_setUnsignedInt32(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasCreatedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearCreatedAt() => clearField(6);

  @$pb.TagNumber(7)
  $core.int get updatedAt => $_getIZ(6);
  @$pb.TagNumber(7)
  set updatedAt($core.int v) {
    $_setUnsignedInt32(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasUpdatedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearUpdatedAt() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get excerpt => $_getSZ(7);
  @$pb.TagNumber(8)
  set excerpt($core.String v) {
    $_setString(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasExcerpt() => $_has(7);
  @$pb.TagNumber(8)
  void clearExcerpt() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get content => $_getSZ(8);
  @$pb.TagNumber(9)
  set content($core.String v) {
    $_setString(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasContent() => $_has(8);
  @$pb.TagNumber(9)
  void clearContent() => clearField(9);

  @$pb.TagNumber(1000)
  $core.Map<$core.String, $core.String> get meta => $_getMap(9);
}

/// Articles represents a list of blog articles.
class Articles extends $pb.GeneratedMessage {
  factory Articles({
    $core.Iterable<Article>? articles,
    $core.int? count,
  }) {
    final $result = create();
    if (articles != null) {
      $result.articles.addAll(articles);
    }
    if (count != null) {
      $result.count = count;
    }
    return $result;
  }
  Articles._() : super();
  factory Articles.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Articles.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Articles',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'blog.api'), createEmptyInstance: create)
    ..pc<Article>(1, _omitFieldNames ? '' : 'articles', $pb.PbFieldType.PM, subBuilder: Article.create)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'count', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Articles clone() => Articles()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Articles copyWith(void Function(Articles) updates) =>
      super.copyWith((message) => updates(message as Articles)) as Articles;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Articles create() => Articles._();
  Articles createEmptyInstance() => create();
  static $pb.PbList<Articles> createRepeated() => $pb.PbList<Articles>();
  @$core.pragma('dart2js:noInline')
  static Articles getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Articles>(create);
  static Articles? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Article> get articles => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get count => $_getIZ(1);
  @$pb.TagNumber(2)
  set count($core.int v) {
    $_setUnsignedInt32(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearCount() => clearField(2);
}

/// Log message.
class LogMessage extends $pb.GeneratedMessage {
  factory LogMessage({
    $core.int? timestamp,
    $core.int? level,
    $core.String? prefix,
    $core.String? message,
    $core.String? stacktrace,
    $core.Map<$core.String, $core.String>? context,
    $core.bool? error,
  }) {
    final $result = create();
    if (timestamp != null) {
      $result.timestamp = timestamp;
    }
    if (level != null) {
      $result.level = level;
    }
    if (prefix != null) {
      $result.prefix = prefix;
    }
    if (message != null) {
      $result.message = message;
    }
    if (stacktrace != null) {
      $result.stacktrace = stacktrace;
    }
    if (context != null) {
      $result.context.addAll(context);
    }
    if (error != null) {
      $result.error = error;
    }
    return $result;
  }
  LogMessage._() : super();
  factory LogMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory LogMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LogMessage',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'blog.api'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'timestamp', $pb.PbFieldType.OU3)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'level', $pb.PbFieldType.OU3)
    ..aOS(3, _omitFieldNames ? '' : 'prefix')
    ..aOS(4, _omitFieldNames ? '' : 'message')
    ..aOS(5, _omitFieldNames ? '' : 'stacktrace')
    ..m<$core.String, $core.String>(6, _omitFieldNames ? '' : 'context',
        entryClassName: 'LogMessage.ContextEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('blog.api'))
    ..aOB(7, _omitFieldNames ? '' : 'error')
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  LogMessage clone() => LogMessage()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  LogMessage copyWith(void Function(LogMessage) updates) =>
      super.copyWith((message) => updates(message as LogMessage)) as LogMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LogMessage create() => LogMessage._();
  LogMessage createEmptyInstance() => create();
  static $pb.PbList<LogMessage> createRepeated() => $pb.PbList<LogMessage>();
  @$core.pragma('dart2js:noInline')
  static LogMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LogMessage>(create);
  static LogMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get timestamp => $_getIZ(0);
  @$pb.TagNumber(1)
  set timestamp($core.int v) {
    $_setUnsignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasTimestamp() => $_has(0);
  @$pb.TagNumber(1)
  void clearTimestamp() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get level => $_getIZ(1);
  @$pb.TagNumber(2)
  set level($core.int v) {
    $_setUnsignedInt32(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasLevel() => $_has(1);
  @$pb.TagNumber(2)
  void clearLevel() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get prefix => $_getSZ(2);
  @$pb.TagNumber(3)
  set prefix($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasPrefix() => $_has(2);
  @$pb.TagNumber(3)
  void clearPrefix() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get message => $_getSZ(3);
  @$pb.TagNumber(4)
  set message($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasMessage() => $_has(3);
  @$pb.TagNumber(4)
  void clearMessage() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get stacktrace => $_getSZ(4);
  @$pb.TagNumber(5)
  set stacktrace($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasStacktrace() => $_has(4);
  @$pb.TagNumber(5)
  void clearStacktrace() => clearField(5);

  @$pb.TagNumber(6)
  $core.Map<$core.String, $core.String> get context => $_getMap(5);

  @$pb.TagNumber(7)
  $core.bool get error => $_getBF(6);
  @$pb.TagNumber(7)
  set error($core.bool v) {
    $_setBool(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasError() => $_has(6);
  @$pb.TagNumber(7)
  void clearError() => clearField(7);
}

const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
