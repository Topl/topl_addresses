import 'dart:io';

import 'package:grinder/grinder.dart';

/// Returns the environment variable named [name], or throws an exception if it
/// can't be found.
String environment(String name) {
  var value = Platform.environment[name];
  if (value == null) fail('Required environment variable $name not found.');
  return value;
}
