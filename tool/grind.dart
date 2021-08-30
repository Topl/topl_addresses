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
