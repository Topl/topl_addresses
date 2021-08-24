## 0.0.1

# Summary 

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

