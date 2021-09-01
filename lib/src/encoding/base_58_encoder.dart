import 'package:bip_topl/src/utils/base58.dart';
import 'package:pinenacl/x25519.dart';

class Base58Encoder implements Encoder {
  const Base58Encoder._singleton();
  static const Base58Encoder instance = Base58Encoder._singleton();

  @override
  String encode(List<int> data) {
    final result = Base58.encode(data);
    return result;
  }

  @override
  Uint8List decode(String data) {
    final result = Base58.decode(data);
    return Uint8List.fromList(result);
  }
}
