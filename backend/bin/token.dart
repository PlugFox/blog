import 'package:backend/src/common/util/token_util.dart';

/// Generates a secret token
void main([List<String>? arguments]) => TokenUtil.generateSecret(64);
