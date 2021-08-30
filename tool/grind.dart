import 'package:cli_pkg/cli_pkg.dart' as pkg;
import 'package:grinder/grinder.dart';

void main(List<String> args) {
  pkg.name.value = 'bip-topl';
  pkg.humanName.value = 'topl';
  pkg.githubUser.value = 'Topl';
  pkg.homebrewRepo.value = 'leoafarias/homebrew-fvm';

  pkg.addAllTasks();
  grind(args);
}
