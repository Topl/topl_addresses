import 'package:bip_topl/src/crypto/formatting.dart';
import 'package:fast_base58/fast_base58.dart';
import 'package:pinenacl/x25519.dart';

class Base58Encoder implements Encoder {
  const Base58Encoder._singleton();
  static const Base58Encoder instance = Base58Encoder._singleton();

  @override
  String encode(List<int> data) {
    final result = Base58Encode(Uint8List.fromList(data));
    return result;
  }

  @override
  Uint8List decode(String data) {
    final result = str2ByteArray(data);
    return result;
  }
}
