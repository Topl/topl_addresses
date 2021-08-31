import 'dart:io';

import 'package:bip_topl/utils.dart';
import 'package:grinder/grinder.dart';
import 'package:cli_pkg/cli_pkg.dart' as pkg;

import 'utils.dart';

@Task('verify that the package is in a good state to release')
void sanityCheckBeforeRelease() {
  var ref = environment('GITHUB_REF');
  if (ref != 'refs/tags/${pkg.version}') {
    fail('GITHUB_REF $ref is different than pubspec version ${pkg.version}.');
  }

  if (listEquals(pkg.version.preRelease, ['dev'])) {
    fail('${pkg.version} is a dev release.');
  }

  var versionHeader =
      RegExp('^## ${RegExp.escape(pkg.version.toString())}\$', multiLine: true);
  if (!File('CHANGELOG.md').readAsStringSync().contains(versionHeader)) {
    fail("There's no CHANGELOG entry for ${pkg.version}.");
  }
}
