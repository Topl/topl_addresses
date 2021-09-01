import 'dart:convert';
import 'dart:typed_data';

import 'package:bip_topl/src/encoding/base_58_encoder.dart';
import 'package:pointycastle/src/utils.dart' as p_utils;

/// This method converts bytes to an unsigned integer so that it can be used more easily by our pointycastle dependency
BigInt bytesToUnsignedInt(Uint8List bytes) {
  return p_utils.decodeBigIntWithSign(1, bytes);
}

/// This is a utility function that is used by the keystore to decode strings that are used in the encrypted json
Uint8List str2ByteArray(String str, {String enc = ''}) {
  if (enc == 'latin1') {
    return latin1.encode(str);
  } else {
    return Uint8List.fromList(Base58Encoder.instance.decode(str));
  }
}
