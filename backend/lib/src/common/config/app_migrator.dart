// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:async';
import 'dart:math';

import 'package:backend/src/common/config/pubspec.yaml.g.dart';
import 'package:backend/src/common/database/database.dart';
import 'package:l/l.dart';

/// Migrate application when version is changed.
sealed class AppMigrator {
  /// Namespace for all version keys
  static const String storageNamespace = 'keys';

  /// Keys for storing the current version of the app
  static const String versionMajorKey = '$storageNamespace.version.major';

  /// Keys for storing the current version of the app
  static const String versionMinorKey = '$storageNamespace.version.minor';

  /// Keys for storing the current version of the app
  static const String versionPatchKey = '$storageNamespace.version.patch';

  static FutureOr<void> migrate(Database database) async {
    try {
      final prevMajor = database.getKey<int>(versionMajorKey);
      final prevMinor = database.getKey<int>(versionMinorKey);
      final prevPatch = database.getKey<int>(versionPatchKey);
      if (prevMajor == null || prevMinor == null || prevPatch == null) {
        l.i('Initializing app for the first time');
        /* ... */
      } else if (Pubspec.version.major != prevMajor ||
          Pubspec.version.minor != prevMinor ||
          Pubspec.version.patch != prevPatch) {
        l.i('Migrating from $prevMajor.$prevMinor.$prevPatch to ${Pubspec.version.major}.${Pubspec.version.minor}.${Pubspec.version.patch}');
        /* ... */
      } else {
        l.i('App is up-to-date');
        return;
      }
      database.setAll(<String, int>{
        versionMajorKey: Pubspec.version.major,
        versionMinorKey: Pubspec.version.minor,
        versionPatchKey: Pubspec.version.patch,
      });
    } on Object catch (error, stackTrace) {
      l.e('App migration failed: $e', stackTrace);
      rethrow;
    }
  }
}
