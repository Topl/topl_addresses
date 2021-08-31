import 'dart:io';
import 'package:cli_pkg/cli_pkg.dart' as pkg;
import 'package:grinder/grinder.dart';

export 'grind/sanity_check.dart';

void main(List<String> args) {
  pkg.humanName.value = 'Topl';
  pkg.botName.value = 'Topl Bot';
  pkg.botEmail.value = 'topl.bot.beep.boop@gmail.com';
  pkg.githubUser.fn = () => Platform.environment['GH_USER']!;
  pkg.githubPassword.fn = () => Platform.environment['GH_TOKEN']!;
  pkg.standaloneName.value = 'bip-topl';
  pkg.githubReleaseNotes.fn = () =>
      'To install bip-topl ${pkg.version}, download one of the packages below '
      'and [add it to your PATH][], or see [the Developer Hub website][] for full '
      'installation instructions.\n'
      '\n'
      '[add it to your PATH]: https://katiek2.github.io/path-doc/\n'
      '[the Sass website]: https://topl.readme.io/docs/install\n'
      '\n'
      '# Changes\n'
      '\n'
      '${pkg.githubReleaseNotes.defaultValue}';
  pkg.addAllTasks();
  grind(args);
}

@DefaultTask('Compile async code and reformat.')
@Depends(format)
void all() {}

@Task('Run the Dart formatter.')
void format() {
  Pub.run('dart_style',
      script: 'format', arguments: ['--overwrite', '--fix', '.']);
}

@Task('Runs the tasks that are required for running tests.')
@Depends(format, 'pkg-standalone-dev')
void beforeTest() {}
