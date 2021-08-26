// BIP39 Mnemonics

// Can be used to generate the root key of a given HDTree, an address, or simply convert bits to mnemonic for human friendly value

// For more details about the protocol, see
// [Bitcoin Improvement Proposal 39](https://github.com/bitcoin/bips/blob/master/bip-0039.mediawiki)

import 'dart:math';

import 'package:bip_topl/bip_topl.dart';

void main() {
  const mnemonic =
      'legal winner thank year wave sausage worth useful legal winner thank yellow';

  // mnemonic to entropy
  final entropy = mnemonicToEntropy(mnemonic, 'english');
  print(entropy); // 7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f

  // mnemonic to seedHex
  // accepts an optional passphrase to strengthen the security of the mnemonic
  final seedHex = mnemonicToSeedHex(mnemonic, passphrase: 'TREZOR');
  print(
      seedHex); //2e8905819b8723fe2c1d161860e5ee1830318dbf49a83bd451cfb8440c28bd6fa457fe1296106559a3c80937a1c1069be3a3a5bd381ee6260e8d9739fce1f607

  //entropy to mnemonic
  final code = entropyToMnemonic(entropy);
  print(
      code); //legal winner thank year wave sausage worth useful legal winner thank yellow

  // validate Mnemonic
  final validation = validateMnemonic(code, 'english');
  print(validation); // true

  // generateMnemonic with 15 words
  final words = generateMnemonic(Random.secure(), strength: 160);
  print(words); // should be random 15 word mnemonic
}
