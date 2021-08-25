![dart-test](https://github.com/Topl/bip-topl/actions/workflows/dart-test.yml/badge.svg)
[![License: MPL 2.0](https://img.shields.io/badge/License-MPL%202.0-brightgreen.svg)](https://opensource.org/licenses/MPL-2.0)
[![codecov](https://codecov.io/gh/Topl/bip-topl/branch/main/graph/badge.svg)](https://codecov.io/gh/Topl/bip-topl)
![gh-pages docs](https://topl.github.io/bip-topl/)
[![Code of Conduct](https://img.shields.io/badge/code-of%20conduct-green.svg)](https://github.com/Topl/bip-topl/blob/main/.github/CODE_OF_CONDUCT.md)
[![Discord](https://img.shields.io/discord/591914197219016707.svg?label=&logo=discord&logoColor=ffffff&color=7389D8&labelColor=6A7EC2)][discord-url]
[![StackExchange][stackexchange-image]][stackexchange-url]



# Topl Bip Library

Library for building Topl blockchain wallet mobile apps in Flutter.

## About

This project is a Topl blockchain on-ramp for Flutter/Dart mobile app developers.  Currently a work in progress.

It will power the live Ribn wallet currently in active development.

### Current Features
* CIP-1852 HD Wallet Compatibility
   - Topl Specific BIP32 Deterministic Key Generator
* BIP39 Compatible for Mnemonic Phrases
* BIP39-ED25519 Extended Keys (used for signing transactions)
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
