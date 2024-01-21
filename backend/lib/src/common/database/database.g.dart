// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class LogTbl extends Table with TableInfo<LogTbl, LogTblData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  LogTbl(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>('id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  static const VerificationMeta _timestampMeta = VerificationMeta('timestamp');
  late final GeneratedColumn<int> timestamp = GeneratedColumn<int>('timestamp', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL DEFAULT (strftime(\'%s\', \'now\'))',
      defaultValue: const CustomExpression('strftime(\'%s\', \'now\')'));
  static const VerificationMeta _levelMeta = VerificationMeta('level');
  late final GeneratedColumn<int> level = GeneratedColumn<int>('level', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true, $customConstraints: 'NOT NULL');
  static const VerificationMeta _dataMeta = VerificationMeta('data');
  late final GeneratedColumn<Uint8List> data = GeneratedColumn<Uint8List>('data', aliasedName, false,
      type: DriftSqlType.blob, requiredDuringInsert: true, $customConstraints: 'NOT NULL');
  @override
  List<GeneratedColumn> get $columns => [id, timestamp, level, data];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'log_tbl';
  @override
  VerificationContext validateIntegrity(Insertable<LogTblData> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta, timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    }
    if (data.containsKey('level')) {
      context.handle(_levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('data')) {
      context.handle(_dataMeta, this.data.isAcceptableOrUnknown(data['data']!, _dataMeta));
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LogTblData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LogTblData(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      timestamp: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}timestamp'])!,
      level: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}level'])!,
      data: attachedDatabase.typeMapping.read(DriftSqlType.blob, data['${effectivePrefix}data'])!,
    );
  }

  @override
  LogTbl createAlias(String alias) {
    return LogTbl(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
  @override
  bool get dontWriteConstraints => true;
}

class LogTblData extends DataClass implements Insertable<LogTblData> {
  /// req Unique identifier of the log
  final int id;

  /// Time is the timestamp (in seconds) of the log message
  final int timestamp;

  /// Level is the severity level (a value between 0 and 6)
  final int level;

  /// req Message is the log message or error associated with this log event
  final Uint8List data;
  const LogTblData({required this.id, required this.timestamp, required this.level, required this.data});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['timestamp'] = Variable<int>(timestamp);
    map['level'] = Variable<int>(level);
    map['data'] = Variable<Uint8List>(data);
    return map;
  }

  LogTblCompanion toCompanion(bool nullToAbsent) {
    return LogTblCompanion(
      id: Value(id),
      timestamp: Value(timestamp),
      level: Value(level),
      data: Value(data),
    );
  }

  factory LogTblData.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LogTblData(
      id: serializer.fromJson<int>(json['id']),
      timestamp: serializer.fromJson<int>(json['timestamp']),
      level: serializer.fromJson<int>(json['level']),
      data: serializer.fromJson<Uint8List>(json['data']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'timestamp': serializer.toJson<int>(timestamp),
      'level': serializer.toJson<int>(level),
      'data': serializer.toJson<Uint8List>(data),
    };
  }

  LogTblData copyWith({int? id, int? timestamp, int? level, Uint8List? data}) => LogTblData(
        id: id ?? this.id,
        timestamp: timestamp ?? this.timestamp,
        level: level ?? this.level,
        data: data ?? this.data,
      );
  @override
  String toString() {
    return (StringBuffer('LogTblData(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('level: $level, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, timestamp, level, $driftBlobEquality.hash(data));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LogTblData &&
          other.id == this.id &&
          other.timestamp == this.timestamp &&
          other.level == this.level &&
          $driftBlobEquality.equals(other.data, this.data));
}

class LogTblCompanion extends UpdateCompanion<LogTblData> {
  final Value<int> id;
  final Value<int> timestamp;
  final Value<int> level;
  final Value<Uint8List> data;
  const LogTblCompanion({
    this.id = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.level = const Value.absent(),
    this.data = const Value.absent(),
  });
  LogTblCompanion.insert({
    this.id = const Value.absent(),
    this.timestamp = const Value.absent(),
    required int level,
    required Uint8List data,
  })  : level = Value(level),
        data = Value(data);
  static Insertable<LogTblData> custom({
    Expression<int>? id,
    Expression<int>? timestamp,
    Expression<int>? level,
    Expression<Uint8List>? data,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (timestamp != null) 'timestamp': timestamp,
      if (level != null) 'level': level,
      if (data != null) 'data': data,
    });
  }

  LogTblCompanion copyWith({Value<int>? id, Value<int>? timestamp, Value<int>? level, Value<Uint8List>? data}) {
    return LogTblCompanion(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      level: level ?? this.level,
      data: data ?? this.data,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<int>(timestamp.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (data.present) {
      map['data'] = Variable<Uint8List>(data.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LogTblCompanion(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('level: $level, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }
}

class CharacteristicTbl extends Table with TableInfo<CharacteristicTbl, CharacteristicTblData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  CharacteristicTbl(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _typeMeta = VerificationMeta('type');
  late final GeneratedColumn<String> type = GeneratedColumn<String>('type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL CHECK (length(type) > 0 AND length(type) <= 255)');
  static const VerificationMeta _idMeta = VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>('id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true, $customConstraints: 'NOT NULL');
  static const VerificationMeta _dataMeta = VerificationMeta('data');
  late final GeneratedColumn<String> data = GeneratedColumn<String>('data', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL CHECK (length(data) > 2 AND json_valid(data))');
  static const VerificationMeta _metaCreatedAtMeta = VerificationMeta('metaCreatedAt');
  late final GeneratedColumn<int> metaCreatedAt = GeneratedColumn<int>('meta_created_at', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL DEFAULT (strftime(\'%s\', \'now\'))',
      defaultValue: const CustomExpression('strftime(\'%s\', \'now\')'));
  static const VerificationMeta _metaUpdatedAtMeta = VerificationMeta('metaUpdatedAt');
  late final GeneratedColumn<int> metaUpdatedAt = GeneratedColumn<int>('meta_updated_at', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL DEFAULT (strftime(\'%s\', \'now\')) CHECK (meta_updated_at >= meta_created_at)',
      defaultValue: const CustomExpression('strftime(\'%s\', \'now\')'));
  @override
  List<GeneratedColumn> get $columns => [type, id, data, metaCreatedAt, metaUpdatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'characteristic_tbl';
  @override
  VerificationContext validateIntegrity(Insertable<CharacteristicTblData> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('type')) {
      context.handle(_typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('data')) {
      context.handle(_dataMeta, this.data.isAcceptableOrUnknown(data['data']!, _dataMeta));
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    if (data.containsKey('meta_created_at')) {
      context.handle(
          _metaCreatedAtMeta, metaCreatedAt.isAcceptableOrUnknown(data['meta_created_at']!, _metaCreatedAtMeta));
    }
    if (data.containsKey('meta_updated_at')) {
      context.handle(
          _metaUpdatedAtMeta, metaUpdatedAt.isAcceptableOrUnknown(data['meta_updated_at']!, _metaUpdatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {type, id};
  @override
  CharacteristicTblData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CharacteristicTblData(
      type: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      data: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}data'])!,
      metaCreatedAt: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}meta_created_at'])!,
      metaUpdatedAt: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}meta_updated_at'])!,
    );
  }

  @override
  CharacteristicTbl createAlias(String alias) {
    return CharacteristicTbl(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
  @override
  List<String> get customConstraints => const ['PRIMARY KEY(type, id)'];
  @override
  bool get dontWriteConstraints => true;
}

class CharacteristicTblData extends DataClass implements Insertable<CharacteristicTblData> {
  /// req Type
  final String type;

  /// req ID
  final int id;

  /// JSON data
  final String data;

  /// Created date (unixtime in seconds)
  final int metaCreatedAt;

  /// Updated date (unixtime in seconds)
  final int metaUpdatedAt;
  const CharacteristicTblData(
      {required this.type,
      required this.id,
      required this.data,
      required this.metaCreatedAt,
      required this.metaUpdatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['type'] = Variable<String>(type);
    map['id'] = Variable<int>(id);
    map['data'] = Variable<String>(data);
    map['meta_created_at'] = Variable<int>(metaCreatedAt);
    map['meta_updated_at'] = Variable<int>(metaUpdatedAt);
    return map;
  }

  CharacteristicTblCompanion toCompanion(bool nullToAbsent) {
    return CharacteristicTblCompanion(
      type: Value(type),
      id: Value(id),
      data: Value(data),
      metaCreatedAt: Value(metaCreatedAt),
      metaUpdatedAt: Value(metaUpdatedAt),
    );
  }

  factory CharacteristicTblData.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CharacteristicTblData(
      type: serializer.fromJson<String>(json['type']),
      id: serializer.fromJson<int>(json['id']),
      data: serializer.fromJson<String>(json['data']),
      metaCreatedAt: serializer.fromJson<int>(json['meta_created_at']),
      metaUpdatedAt: serializer.fromJson<int>(json['meta_updated_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'type': serializer.toJson<String>(type),
      'id': serializer.toJson<int>(id),
      'data': serializer.toJson<String>(data),
      'meta_created_at': serializer.toJson<int>(metaCreatedAt),
      'meta_updated_at': serializer.toJson<int>(metaUpdatedAt),
    };
  }

  CharacteristicTblData copyWith({String? type, int? id, String? data, int? metaCreatedAt, int? metaUpdatedAt}) =>
      CharacteristicTblData(
        type: type ?? this.type,
        id: id ?? this.id,
        data: data ?? this.data,
        metaCreatedAt: metaCreatedAt ?? this.metaCreatedAt,
        metaUpdatedAt: metaUpdatedAt ?? this.metaUpdatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('CharacteristicTblData(')
          ..write('type: $type, ')
          ..write('id: $id, ')
          ..write('data: $data, ')
          ..write('metaCreatedAt: $metaCreatedAt, ')
          ..write('metaUpdatedAt: $metaUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(type, id, data, metaCreatedAt, metaUpdatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CharacteristicTblData &&
          other.type == this.type &&
          other.id == this.id &&
          other.data == this.data &&
          other.metaCreatedAt == this.metaCreatedAt &&
          other.metaUpdatedAt == this.metaUpdatedAt);
}

class CharacteristicTblCompanion extends UpdateCompanion<CharacteristicTblData> {
  final Value<String> type;
  final Value<int> id;
  final Value<String> data;
  final Value<int> metaCreatedAt;
  final Value<int> metaUpdatedAt;
  final Value<int> rowid;
  const CharacteristicTblCompanion({
    this.type = const Value.absent(),
    this.id = const Value.absent(),
    this.data = const Value.absent(),
    this.metaCreatedAt = const Value.absent(),
    this.metaUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CharacteristicTblCompanion.insert({
    required String type,
    required int id,
    required String data,
    this.metaCreatedAt = const Value.absent(),
    this.metaUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : type = Value(type),
        id = Value(id),
        data = Value(data);
  static Insertable<CharacteristicTblData> custom({
    Expression<String>? type,
    Expression<int>? id,
    Expression<String>? data,
    Expression<int>? metaCreatedAt,
    Expression<int>? metaUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (type != null) 'type': type,
      if (id != null) 'id': id,
      if (data != null) 'data': data,
      if (metaCreatedAt != null) 'meta_created_at': metaCreatedAt,
      if (metaUpdatedAt != null) 'meta_updated_at': metaUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CharacteristicTblCompanion copyWith(
      {Value<String>? type,
      Value<int>? id,
      Value<String>? data,
      Value<int>? metaCreatedAt,
      Value<int>? metaUpdatedAt,
      Value<int>? rowid}) {
    return CharacteristicTblCompanion(
      type: type ?? this.type,
      id: id ?? this.id,
      data: data ?? this.data,
      metaCreatedAt: metaCreatedAt ?? this.metaCreatedAt,
      metaUpdatedAt: metaUpdatedAt ?? this.metaUpdatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (metaCreatedAt.present) {
      map['meta_created_at'] = Variable<int>(metaCreatedAt.value);
    }
    if (metaUpdatedAt.present) {
      map['meta_updated_at'] = Variable<int>(metaUpdatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CharacteristicTblCompanion(')
          ..write('type: $type, ')
          ..write('id: $id, ')
          ..write('data: $data, ')
          ..write('metaCreatedAt: $metaCreatedAt, ')
          ..write('metaUpdatedAt: $metaUpdatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class KvTbl extends Table with TableInfo<KvTbl, KvTblData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  KvTbl(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _kMeta = VerificationMeta('k');
  late final GeneratedColumn<String> k = GeneratedColumn<String>('k', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true, $customConstraints: 'NOT NULL PRIMARY KEY');
  static const VerificationMeta _vstringMeta = VerificationMeta('vstring');
  late final GeneratedColumn<String> vstring = GeneratedColumn<String>('vstring', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false, $customConstraints: '');
  static const VerificationMeta _vintMeta = VerificationMeta('vint');
  late final GeneratedColumn<int> vint = GeneratedColumn<int>('vint', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false, $customConstraints: '');
  static const VerificationMeta _vdoubleMeta = VerificationMeta('vdouble');
  late final GeneratedColumn<double> vdouble = GeneratedColumn<double>('vdouble', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false, $customConstraints: '');
  static const VerificationMeta _vboolMeta = VerificationMeta('vbool');
  late final GeneratedColumn<int> vbool = GeneratedColumn<int>('vbool', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false, $customConstraints: '');
  static const VerificationMeta _metaCreatedAtMeta = VerificationMeta('metaCreatedAt');
  late final GeneratedColumn<int> metaCreatedAt = GeneratedColumn<int>('meta_created_at', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL DEFAULT (strftime(\'%s\', \'now\'))',
      defaultValue: const CustomExpression('strftime(\'%s\', \'now\')'));
  static const VerificationMeta _metaUpdatedAtMeta = VerificationMeta('metaUpdatedAt');
  late final GeneratedColumn<int> metaUpdatedAt = GeneratedColumn<int>('meta_updated_at', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL DEFAULT (strftime(\'%s\', \'now\')) CHECK (meta_updated_at >= meta_created_at)',
      defaultValue: const CustomExpression('strftime(\'%s\', \'now\')'));
  @override
  List<GeneratedColumn> get $columns => [k, vstring, vint, vdouble, vbool, metaCreatedAt, metaUpdatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'kv_tbl';
  @override
  VerificationContext validateIntegrity(Insertable<KvTblData> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('k')) {
      context.handle(_kMeta, k.isAcceptableOrUnknown(data['k']!, _kMeta));
    } else if (isInserting) {
      context.missing(_kMeta);
    }
    if (data.containsKey('vstring')) {
      context.handle(_vstringMeta, vstring.isAcceptableOrUnknown(data['vstring']!, _vstringMeta));
    }
    if (data.containsKey('vint')) {
      context.handle(_vintMeta, vint.isAcceptableOrUnknown(data['vint']!, _vintMeta));
    }
    if (data.containsKey('vdouble')) {
      context.handle(_vdoubleMeta, vdouble.isAcceptableOrUnknown(data['vdouble']!, _vdoubleMeta));
    }
    if (data.containsKey('vbool')) {
      context.handle(_vboolMeta, vbool.isAcceptableOrUnknown(data['vbool']!, _vboolMeta));
    }
    if (data.containsKey('meta_created_at')) {
      context.handle(
          _metaCreatedAtMeta, metaCreatedAt.isAcceptableOrUnknown(data['meta_created_at']!, _metaCreatedAtMeta));
    }
    if (data.containsKey('meta_updated_at')) {
      context.handle(
          _metaUpdatedAtMeta, metaUpdatedAt.isAcceptableOrUnknown(data['meta_updated_at']!, _metaUpdatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {k};
  @override
  KvTblData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KvTblData(
      k: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}k'])!,
      vstring: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}vstring']),
      vint: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}vint']),
      vdouble: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}vdouble']),
      vbool: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}vbool']),
      metaCreatedAt: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}meta_created_at'])!,
      metaUpdatedAt: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}meta_updated_at'])!,
    );
  }

  @override
  KvTbl createAlias(String alias) {
    return KvTbl(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
  @override
  bool get dontWriteConstraints => true;
}

class KvTblData extends DataClass implements Insertable<KvTblData> {
  /// req Key
  final String k;

  /// string
  final String? vstring;

  /// Integer
  final int? vint;

  /// Float
  final double? vdouble;

  /// Boolean
  final int? vbool;

  /// req Created date (unixtime in seconds)
  ///vblob BLOB,
  /// Binary
  final int metaCreatedAt;

  /// req Updated date (unixtime in seconds)
  final int metaUpdatedAt;
  const KvTblData(
      {required this.k,
      this.vstring,
      this.vint,
      this.vdouble,
      this.vbool,
      required this.metaCreatedAt,
      required this.metaUpdatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['k'] = Variable<String>(k);
    if (!nullToAbsent || vstring != null) {
      map['vstring'] = Variable<String>(vstring);
    }
    if (!nullToAbsent || vint != null) {
      map['vint'] = Variable<int>(vint);
    }
    if (!nullToAbsent || vdouble != null) {
      map['vdouble'] = Variable<double>(vdouble);
    }
    if (!nullToAbsent || vbool != null) {
      map['vbool'] = Variable<int>(vbool);
    }
    map['meta_created_at'] = Variable<int>(metaCreatedAt);
    map['meta_updated_at'] = Variable<int>(metaUpdatedAt);
    return map;
  }

  KvTblCompanion toCompanion(bool nullToAbsent) {
    return KvTblCompanion(
      k: Value(k),
      vstring: vstring == null && nullToAbsent ? const Value.absent() : Value(vstring),
      vint: vint == null && nullToAbsent ? const Value.absent() : Value(vint),
      vdouble: vdouble == null && nullToAbsent ? const Value.absent() : Value(vdouble),
      vbool: vbool == null && nullToAbsent ? const Value.absent() : Value(vbool),
      metaCreatedAt: Value(metaCreatedAt),
      metaUpdatedAt: Value(metaUpdatedAt),
    );
  }

  factory KvTblData.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KvTblData(
      k: serializer.fromJson<String>(json['k']),
      vstring: serializer.fromJson<String?>(json['vstring']),
      vint: serializer.fromJson<int?>(json['vint']),
      vdouble: serializer.fromJson<double?>(json['vdouble']),
      vbool: serializer.fromJson<int?>(json['vbool']),
      metaCreatedAt: serializer.fromJson<int>(json['meta_created_at']),
      metaUpdatedAt: serializer.fromJson<int>(json['meta_updated_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'k': serializer.toJson<String>(k),
      'vstring': serializer.toJson<String?>(vstring),
      'vint': serializer.toJson<int?>(vint),
      'vdouble': serializer.toJson<double?>(vdouble),
      'vbool': serializer.toJson<int?>(vbool),
      'meta_created_at': serializer.toJson<int>(metaCreatedAt),
      'meta_updated_at': serializer.toJson<int>(metaUpdatedAt),
    };
  }

  KvTblData copyWith(
          {String? k,
          Value<String?> vstring = const Value.absent(),
          Value<int?> vint = const Value.absent(),
          Value<double?> vdouble = const Value.absent(),
          Value<int?> vbool = const Value.absent(),
          int? metaCreatedAt,
          int? metaUpdatedAt}) =>
      KvTblData(
        k: k ?? this.k,
        vstring: vstring.present ? vstring.value : this.vstring,
        vint: vint.present ? vint.value : this.vint,
        vdouble: vdouble.present ? vdouble.value : this.vdouble,
        vbool: vbool.present ? vbool.value : this.vbool,
        metaCreatedAt: metaCreatedAt ?? this.metaCreatedAt,
        metaUpdatedAt: metaUpdatedAt ?? this.metaUpdatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('KvTblData(')
          ..write('k: $k, ')
          ..write('vstring: $vstring, ')
          ..write('vint: $vint, ')
          ..write('vdouble: $vdouble, ')
          ..write('vbool: $vbool, ')
          ..write('metaCreatedAt: $metaCreatedAt, ')
          ..write('metaUpdatedAt: $metaUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(k, vstring, vint, vdouble, vbool, metaCreatedAt, metaUpdatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KvTblData &&
          other.k == this.k &&
          other.vstring == this.vstring &&
          other.vint == this.vint &&
          other.vdouble == this.vdouble &&
          other.vbool == this.vbool &&
          other.metaCreatedAt == this.metaCreatedAt &&
          other.metaUpdatedAt == this.metaUpdatedAt);
}

class KvTblCompanion extends UpdateCompanion<KvTblData> {
  final Value<String> k;
  final Value<String?> vstring;
  final Value<int?> vint;
  final Value<double?> vdouble;
  final Value<int?> vbool;
  final Value<int> metaCreatedAt;
  final Value<int> metaUpdatedAt;
  final Value<int> rowid;
  const KvTblCompanion({
    this.k = const Value.absent(),
    this.vstring = const Value.absent(),
    this.vint = const Value.absent(),
    this.vdouble = const Value.absent(),
    this.vbool = const Value.absent(),
    this.metaCreatedAt = const Value.absent(),
    this.metaUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KvTblCompanion.insert({
    required String k,
    this.vstring = const Value.absent(),
    this.vint = const Value.absent(),
    this.vdouble = const Value.absent(),
    this.vbool = const Value.absent(),
    this.metaCreatedAt = const Value.absent(),
    this.metaUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : k = Value(k);
  static Insertable<KvTblData> custom({
    Expression<String>? k,
    Expression<String>? vstring,
    Expression<int>? vint,
    Expression<double>? vdouble,
    Expression<int>? vbool,
    Expression<int>? metaCreatedAt,
    Expression<int>? metaUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (k != null) 'k': k,
      if (vstring != null) 'vstring': vstring,
      if (vint != null) 'vint': vint,
      if (vdouble != null) 'vdouble': vdouble,
      if (vbool != null) 'vbool': vbool,
      if (metaCreatedAt != null) 'meta_created_at': metaCreatedAt,
      if (metaUpdatedAt != null) 'meta_updated_at': metaUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KvTblCompanion copyWith(
      {Value<String>? k,
      Value<String?>? vstring,
      Value<int?>? vint,
      Value<double?>? vdouble,
      Value<int?>? vbool,
      Value<int>? metaCreatedAt,
      Value<int>? metaUpdatedAt,
      Value<int>? rowid}) {
    return KvTblCompanion(
      k: k ?? this.k,
      vstring: vstring ?? this.vstring,
      vint: vint ?? this.vint,
      vdouble: vdouble ?? this.vdouble,
      vbool: vbool ?? this.vbool,
      metaCreatedAt: metaCreatedAt ?? this.metaCreatedAt,
      metaUpdatedAt: metaUpdatedAt ?? this.metaUpdatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (k.present) {
      map['k'] = Variable<String>(k.value);
    }
    if (vstring.present) {
      map['vstring'] = Variable<String>(vstring.value);
    }
    if (vint.present) {
      map['vint'] = Variable<int>(vint.value);
    }
    if (vdouble.present) {
      map['vdouble'] = Variable<double>(vdouble.value);
    }
    if (vbool.present) {
      map['vbool'] = Variable<int>(vbool.value);
    }
    if (metaCreatedAt.present) {
      map['meta_created_at'] = Variable<int>(metaCreatedAt.value);
    }
    if (metaUpdatedAt.present) {
      map['meta_updated_at'] = Variable<int>(metaUpdatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KvTblCompanion(')
          ..write('k: $k, ')
          ..write('vstring: $vstring, ')
          ..write('vint: $vint, ')
          ..write('vdouble: $vdouble, ')
          ..write('vbool: $vbool, ')
          ..write('metaCreatedAt: $metaCreatedAt, ')
          ..write('metaUpdatedAt: $metaUpdatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(e);
  late final LogTbl logTbl = LogTbl(this);
  late final Index logTimestampIdx =
      Index('log_timestamp_idx', 'CREATE INDEX IF NOT EXISTS log_timestamp_idx ON log_tbl (timestamp)');
  late final Index logLevelIdx = Index('log_level_idx', 'CREATE INDEX IF NOT EXISTS log_level_idx ON log_tbl (level)');
  late final CharacteristicTbl characteristicTbl = CharacteristicTbl(this);
  late final Index characteristicMetaCreatedAtIdx = Index('characteristic_meta_created_at_idx',
      'CREATE INDEX IF NOT EXISTS characteristic_meta_created_at_idx ON characteristic_tbl (meta_created_at)');
  late final Index characteristicMetaUpdatedAtIdx = Index('characteristic_meta_updated_at_idx',
      'CREATE INDEX IF NOT EXISTS characteristic_meta_updated_at_idx ON characteristic_tbl (meta_updated_at)');
  late final Trigger characteristicMetaUpdatedAtTrig = Trigger(
      'CREATE TRIGGER IF NOT EXISTS characteristic_meta_updated_at_trig AFTER UPDATE ON characteristic_tbl BEGIN UPDATE characteristic_tbl SET meta_updated_at = strftime(\'%s\', \'now\') WHERE type = NEW.type AND id = NEW.id;END',
      'characteristic_meta_updated_at_trig');
  late final KvTbl kvTbl = KvTbl(this);
  late final Index kvMetaCreatedAtIdx =
      Index('kv_meta_created_at_idx', 'CREATE INDEX IF NOT EXISTS kv_meta_created_at_idx ON kv_tbl (meta_created_at)');
  late final Index kvMetaUpdatedAtIdx =
      Index('kv_meta_updated_at_idx', 'CREATE INDEX IF NOT EXISTS kv_meta_updated_at_idx ON kv_tbl (meta_updated_at)');
  late final Trigger kvMetaUpdatedAtTrig = Trigger(
      'CREATE TRIGGER IF NOT EXISTS kv_meta_updated_at_trig AFTER UPDATE ON kv_tbl BEGIN UPDATE kv_tbl SET meta_updated_at = strftime(\'%s\', \'now\') WHERE k = NEW.k;END',
      'kv_meta_updated_at_trig');
  @override
  Iterable<TableInfo<Table, Object?>> get allTables => allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        logTbl,
        logTimestampIdx,
        logLevelIdx,
        characteristicTbl,
        characteristicMetaCreatedAtIdx,
        characteristicMetaUpdatedAtIdx,
        characteristicMetaUpdatedAtTrig,
        kvTbl,
        kvMetaCreatedAtIdx,
        kvMetaUpdatedAtIdx,
        kvMetaUpdatedAtTrig
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('characteristic_tbl', limitUpdateKind: UpdateKind.update),
            result: [
              TableUpdate('characteristic_tbl', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('kv_tbl', limitUpdateKind: UpdateKind.update),
            result: [
              TableUpdate('kv_tbl', kind: UpdateKind.update),
            ],
          ),
        ],
      );
}
