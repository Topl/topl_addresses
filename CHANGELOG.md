## 0.0.2

* Upgrading Base58 Library

After inspection and testing especially the cross-compilation capabilities of the bip-topl library, we decided to add our own implementation of base58 encoding. This is because the library that we were using did not correctly compile into JS. 

Changelog: 
* 1.) Added a new Base58 implementation
* 2.) Optimized the scrypt default parameters for browser use cases
* 3.) Added additional testing for the end to end flow

## 0.0.1

* Initial Release

This release is largely focused on the cryptography capabilities related to building wallet applications using Flutter for the Topl ecosystem. The most notable of which is building out the CIP-1852 keytree structure. Additionally, there are implementations for BIP32-25519 signing, BIP32 child key derivation, SLIP-0023 compatible master key generation, BIP39 mnemonic support. The crypto improvements are targeting functionality that will be required by the Ribn wallet as well as to support the new signing capabilities in a future version of Bifrost. This library is built on top of the PineNacl library which provides many of the cryptographic implementations.

Change Log:
1.) Introduced a Key Generator compatible with the SLIP-0023 (https://github.com/satoshilabs/slips/blob/master/slip-0023.md) Icarus Master Node derivation strategy.
2.) Implementation of Extended Public and Private Keys to be used by BIP32-ED25519 signing protocol (https://drive.google.com/file/d/0ByMtMw2hul0EMFJuNnZORDR2NDA/view?resourcekey=0-5yJh8wV--HB7ve2NuqfQ6A)
3.) BIP39 compatible mnemonic code implementation (https://github.com/bitcoin/bips/blob/master/bip-0039.mediawiki)
4.) BIP39 support for the following languages:
- Chinese Traditional
- Chinese Simplified
- English
- French
- Spanish
- Italian
- Japanese
- Korean
5.) BIP44 HD Wallet extension (CIP-1852) with support for adding new chains used for different purposes (primarily the internal and external chains): https://cips.cardano.org/cips/cip1852/
6.) Extends the PineNacl default encoder to support Base58 encoding

