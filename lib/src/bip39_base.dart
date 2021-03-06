import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:bip_topl/src/crypto/random_bridge.dart';
import 'package:bip_topl/src/keygen.dart';
import 'package:bip_topl/src/wordlists/language_registry.dart';
import 'package:crypto/crypto.dart' show sha256;
import 'package:pinenacl/encoding.dart';
import 'package:unorm_dart/unorm_dart.dart';

import 'utils/constants.dart';
import 'utils/errors.dart';

const _INVALID_MNEMONIC = 'Invalid mnemonic';
const _INVALID_ENTROPY = 'Invalid entropy';
const _INVALID_CHECKSUM = 'Invalid mnemonic checksum';
const SALT_PREFIX = 'mnemonic';

/// BIP39 mnemonics
///
/// Can be used to generate the root key of a given HDTree,
/// an address or simply convert bits to mnemonic for human friendly
/// value.
///
/// For more details about the protocol, see
/// [Bitcoin Improvement Proposal 39](https://github.com/bitcoin/bips/blob/master/bip-0039.mediawiki)
///
//!

int _binaryToByte(String binary) {
  return int.parse(binary, radix: 2);
}

String _bytesToBinary(Uint8List bytes) {
  return bytes.map((byte) => byte.toRadixString(2).padLeft(8, '0')).join('');
}

//Uint8List _createUint8ListFromString( String s ) {
//  var ret = new Uint8List(s.length);
//  for( var i=0 ; i<s.length ; i++ ) {
//    ret[i] = s.codeUnitAt(i);
//  }
//  return ret;
//}

String _deriveChecksumBits(Uint8List entropy) {
  final ENT = entropy.length * 8;
  final CS = ENT ~/ 32;
  final hash = sha256.convert(entropy);
  return _bytesToBinary(Uint8List.fromList(hash.bytes)).substring(0, CS);
}

///
/// This function generates a mnemonic with the given strength, language, and random number generator function (to generate random entropy).
/// Developers should note that if you use Random.secure(), it might not be supported on all platforms (since under the hood it uses a native implementation which does not exist for some platforms i.e cross-compilation to Node).
String generateMnemonic(Random random,
    {int strength = 128, String language = 'english'}) {
  assert(strength % 32 == 0);
  final entropy = Entropy.generate(
      from_entropy_size(strength), RandomBridge(random).nextUint8);
  return entropyToMnemonic(HexCoder.instance.encode(entropy.bytes),
      language: language);
}

String entropyToMnemonic(String entropyString, {String language = 'english'}) {
  final entropy;
  try {
    entropy = Uint8List.fromList(HexCoder.instance.decode(entropyString));
  } catch (err) {
    throw ArgumentError('Invalid entropy');
  }
  if (entropy.length < 16) {
    throw ArgumentError(_INVALID_ENTROPY);
  }
  if (entropy.length > 32) {
    throw ArgumentError(_INVALID_ENTROPY);
  }
  if (entropy.length % 4 != 0) {
    throw ArgumentError(_INVALID_ENTROPY);
  }
  final entropyBits = _bytesToBinary(entropy);
  final checksumBits = _deriveChecksumBits(entropy);
  final bits = entropyBits + checksumBits;
  final regex = RegExp(r'.{1,11}', caseSensitive: false, multiLine: false);
  final chunks = regex
      .allMatches(bits)
      .map((match) => match.group(0)!)
      .toList(growable: false);
  final dictionary =
      DefaultDictionary((Language_Registry[language] ?? const []), language);
  var words =
      chunks.map((binary) => dictionary.words[_binaryToByte(binary)]).join(' ');
  return nfkd(words);
}

Uint8List mnemonicToSeed(String mnemonic, {String passphrase = ''}) {
  final salt = Uint8List.fromList(utf8.encode(SALT_PREFIX + passphrase));
  return generateSeed(salt, passphrase: mnemonic);
}

String mnemonicToSeedHex(String mnemonic, {String passphrase = ''}) {
  return mnemonicToSeed(mnemonic, passphrase: passphrase).map((byte) {
    return byte.toRadixString(16).padLeft(2, '0');
  }).join('');
}

bool validateMnemonic(String mnemonic, String language) {
  try {
    mnemonicToEntropy(mnemonic, language);
  } catch (e) {
    return false;
  }
  return true;
}

String mnemonicToEntropy(mnemonic, String language) {
  var words = mnemonic.split(' ');
  if (words.length % 3 != 0) {
    throw ArgumentError(_INVALID_MNEMONIC);
  }
  final wordlist =
      DefaultDictionary((Language_Registry[language] ?? const []), language);
  // convert word indices to 11 bit binary strings
  final bits = words.map((word) {
    final index = wordlist.words.indexOf(word);
    if (index == -1) {
      throw ArgumentError(_INVALID_MNEMONIC);
    }
    return index.toRadixString(2).padLeft(11, '0');
  }).join('');
  // split the binary string into ENT/CS
  final dividerIndex = (bits.length / 33).floor() * 32;
  final entropyBits = bits.substring(0, dividerIndex);
  final checksumBits = bits.substring(dividerIndex);

  // calculate the checksum and compare
  final regex = RegExp(r'.{1,8}');
  final entropyBytes = Uint8List.fromList(regex
      .allMatches(entropyBits)
      .map((match) => _binaryToByte(match.group(0)!))
      .toList(growable: false));
  if (entropyBytes.length < 16) {
    throw StateError(_INVALID_ENTROPY);
  }
  if (entropyBytes.length > 32) {
    throw StateError(_INVALID_ENTROPY);
  }
  if (entropyBytes.length % 4 != 0) {
    throw StateError(_INVALID_ENTROPY);
  }
  final newChecksum = _deriveChecksumBits(entropyBytes);
  if (newChecksum != checksumBits) {
    throw StateError(_INVALID_CHECKSUM);
  }
  return entropyBytes.map((byte) {
    return byte.toRadixString(16).padLeft(2, '0');
  }).join('');
}

class DefaultDictionary {
  final List<String> words;
  final String name;
  DefaultDictionary(this.words, this.name);
  MnemonicIndex lookup_mnemonic(String word) {
    if (words.contains(word)) {
      return MnemonicIndex(words.indexOf(word));
    } else {
      throw MnemonicWordNotFoundInDictionary(word);
    }
  }

  String lookup_word(MnemonicIndex mnemonic) {
    return words[mnemonic.m];
  }
}

/// smart constructor, validate the given value fits the mnemonic index
/// boundaries (see [`MAX_MNEMONIC_VALUE`](./constant.MAX_MNEMONIC_VALUE.html)).
///
class MnemonicIndex {
  final int m;
  MnemonicIndex(this.m);

  /// returns an [`Error::MnemonicOutOfBound`](enum.Error.html#variant.MnemonicOutOfBound)
  /// if the given value does not fit the valid values.
  ///
  factory MnemonicIndex.create(int m) {
    if (m < MAX_MNEMONIC_VALUE) {
      return MnemonicIndex(m);
    } else {
      throw MnemonicOutOfBounds('Given value does not fit the valid values');
    }
  }

  /// lookup in the given dictionary to retrieve the mnemonic word.
  ///
  String to_word(DefaultDictionary d) {
    return d.lookup_word(this);
  }
}

typedef G = int Function();

class Entropy {
  final Uint8List bytes;

  Entropy(this.bytes);

  /// Retrieve an `Entropy` from the given byteArray.
  ///
  /// # Error
  ///
  /// This function may fail if the given byteArray's length is not
  /// one of the supported entropy length.
  ///
  factory Entropy.fromBytes(Uint8List bytes) {
    final t = from_entropy_size(bytes.length * 8);
    return Entropy.newEntropy(t, bytes);
  }

  /// generate entropy using the given random generator.
  ///
  factory Entropy.generate(Type t, G gen) {
    final entropy = Entropy.newEntropy(t, Uint8List(32));
    final bytes = entropy.bytes;
    for (var i = 0; i < bytes.length; i++) {
      bytes[i] = gen();
    }
    return entropy;
  }

  factory Entropy.newEntropy(Type t, Uint8List bytes) {
    Uint8List e;
    switch (t) {
      case (Type.Type9Words):
        e = Uint8List(12);
        break;
      case (Type.Type12Words):
        e = Uint8List(16);
        break;
      case (Type.Type15Words):
        e = Uint8List(20);
        break;
      case (Type.Type18Words):
        e = Uint8List(24);
        break;
      case (Type.Type21Words):
        e = Uint8List(28);
        break;
      case (Type.Type24Words):
        e = Uint8List(32);
        break;
      default:
        throw WrongKeyType(t.toString());
    }
    return Entropy(e);
  }
}

enum Type {
  Type9Words,
  Type12Words,
  Type15Words,
  Type18Words,
  Type21Words,
  Type24Words
}

Type from_entropy_size(int len) {
  switch (len) {
    case (96):
      return Type.Type9Words;
    case (128):
      return Type.Type12Words;
    case (160):
      return Type.Type15Words;
    case (192):
      return Type.Type18Words;
    case (224):
      return Type.Type21Words;
    case (256):
      return Type.Type24Words;
    default:
      throw WrongKeySize(len.toString());
  }
}

Type from_word_count(int len) {
  switch (len) {
    case (9):
      return Type.Type9Words;
    case (12):
      return Type.Type12Words;
    case (15):
      return Type.Type15Words;
    case (18):
      return Type.Type18Words;
    case (21):
      return Type.Type21Words;
    case (24):
      return Type.Type24Words;
    default:
      throw WrongNumberOfWords(len.toString());
  }
}

int to_key_size(Type t) {
  switch (t) {
    case (Type.Type9Words):
      return 96;
    case (Type.Type12Words):
      return 128;
    case (Type.Type15Words):
      return 160;
    case (Type.Type18Words):
      return 192;
    case (Type.Type21Words):
      return 224;
    case (Type.Type24Words):
      return 256;
    default:
      return 0;
  }
}
