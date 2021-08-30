A [Dart][dart] library that supports the [Topl][topl] blockchain.

<table>
  <tr>
    <td>
      <img width="118px" alt="Topl logo" src="https://avatars.githubusercontent.com/u/26033322?s=200&v=4" />
    </td>
    <td valign="middle">
      <a href="https://img.shields.io/badge/code-of%20conduct-green.svg"><img alt="Code of Conduct" src="https://github.com/Topl/bip-topl/blob/main/.github/CODE_OF_CONDUCT.md"></a>
      <a href="https://img.shields.io/badge/License-MPL%202.0-brightgreen.svg"><img  alt="License" src="https://opensource.org/licenses/MPL-2.0"></a>
    </td>
    <td valign="middle">
      <a href=[dart-test]><img alt="Github build status" src="https://github.com/Topl/bip-topl/actions/workflows/dart-test.yml/badge.svg"></a>
      <a href=https://codecov.io/gh/Topl/bip-topl/branch/main/graph/badge.svg><img alt="bip-topl code coverage" src="https://codecov.io/gh/Topl/bip-topl"></a>
    </td>
    <td>
      <a href="https://twitter.com/topl_protocol"><img alt="@topl_protocol on Twitter" src="https://img.shields.io/twitter/url?style=social&url=https%3A%2F%2Ftwitter.com%2Ftopl_protocol"></a>
      <br>
      <a href=[stackexchange-url]><img alt="stackoverflow" src=[stackexchange-image]></a>
      <br>
      <a href="https://img.shields.io/discord/591914197219016707.svg?label=&logo=discord&logoColor=ffffff&color=7389D8&labelColor=6A7EC2"><img alt="Discord" src="[discord-url]"></a>
    </td>
  </tr>
</table>

[dart]: https://www.dartlang.org
[topl]: topl.co

# Topl Bip Library

Library for building Topl blockchain wallet mobile apps in Flutter. Please read the [documentation](https://topl.github.io/bip-topl/) for more information.

## About

This project is a Topl blockchain on-ramp for Flutter/Dart mobile app developers.  Currently a work in progress.

It will power the live Ribn wallet currently in active development.

### Current Features
* CIP-1852 HD Wallet Compatibility
   - Topl Specific BIP32 Deterministic Key Generator
* BIP39 Compatible for Mnemonic Phrases
* BIP32-ED25519 Extended Keys (used for signing transactions)
* Key Generator tool utilizing PBKDF2 (for additional security around mnemonics)

### Features In Active Development
* create, broadcast and track transactions and fees
* sign and validate messages
* manage private and public keys
* list, create, update or remove wallets

### Planned Features
* utilities for staking accounts
* custom asset transactions
* smart contracts

### BIP32 Usage
```dart
import 'package:bip_topl/bip_topl.dart';
import 'package:pinenacl/x25519.dart';

void main() {
  const coder = HexCoder.instance;
  const derivator = Bip32Ed25519KeyDerivation.instance;
  const keyPair = {
    'xprv':
        'c0b712f4c0e2df68d0054112efb081a7fdf8a3ca920994bf555c40e4c249354993f774ae91005da8c69b2c4c59fa80d741ecea6722262a6b4576d259cf60ef30c05763f0b510942627d0c8b414358841a19748ec43e1135d2f0c4d81583188e1',
    'xpub':
        '906d68169c8bbfc3f0cd901461c4c824e9ab7cdbaf38b7b6bd66e54da0411109c05763f0b510942627d0c8b414358841a19748ec43e1135d2f0c4d81583188e1'
  };
  const address_ix = 0;
  // generate master public and private key from encoded keyPair
  final masterPrivateKey =
      Bip32SigningKey.decode(keyPair['xprv']!, coder: coder);
  final masterPublicKey = Bip32VerifyKey.decode(keyPair['xpub']!, coder: coder);
  print(Base58Encoder.instance.encode(masterPrivateKey
      .rawKey)); //4rUU8Ee5K6h663ByMBLRjXgs9GYsFsTiUFujbfSvDpKjFuEfErc9QFfs4F1fej5jJ6gwavr2zU66c6ASagaqyZcb
  print(Base58Encoder.instance.encode(
      masterPublicKey.rawKey)); //AinUA7J1kBiyvDZ8nPL8BoCE9PBxPjKzUfoyhpXAGTXn
  //BIP-44 path: m / purpose' / coin_type' / account_ix' / change_chain / address_ix
  //You can iterate through a CIP-1852 path by deriving based on each index at a time. For this example, we will only use one idx.
  final derivedPrv = derivator.ckdPriv(masterPrivateKey, address_ix);
  final derivedPub = derivator.ckdPub(masterPublicKey, address_ix);
  print(Base58Encoder.instance.encode(derivedPrv
      .rawKey)); //2JAppvWBAgmd7B6s1XDcNPrxtSfT5MCcnhuVxeNKLYHyyqa3U9FE6BD85QPVtn6iWAisSq2WKyvbZFzmEA1rYbMP
  print(Base58Encoder.instance.encode(
      derivedPub.rawKey)); //AGj1p3atP5m2UVxXrBBtmniWQyV4HZGkVesii922zwj6
}
```

### BIP39 Usage
```dart
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
```

### Contributing 
Please follow the [Contribution Guidelines](./github/CONTRIBUTING.md)

### Community
- [Discord][discord-url]
- [StackExchange][stackexchange-url]

### Similar libraries in other languages
- Javascript: [BramblJS](https://github.com/Topl/BramblJS)
- Python: [BramblPy](https://github.com/Topl/BramblPy)
- Scala: [BramblSc](https://github.com/Topl/Bifrost/tree/main/brambl/src)

[discord-url]: https://discord.gg/CHaG8utU
[stackexchange-image]: https://img.shields.io/badge/bip--topl-stackexchange-brightgreen
[stackexchange-url]: https://bitcoin.stackexchange.com/questions/tagged/bip-topl

### References
[SLIP-0023](https://github.com/satoshilabs/slips/blob/master/slip-0023.md)
[BIP-0032](https://github.com/bitcoin/bips/blob/master/bip-0032.mediawiki)
[BIP-0044](https://github.com/bitcoin/bips/blob/master/bip-0044.mediawiki)
[CIP-1852](https://cips.cardano.org/cips/cip1852/)