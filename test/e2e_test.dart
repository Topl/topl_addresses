import 'dart:typed_data';

import 'package:bip_topl/bip_topl.dart';
import 'package:pinenacl/encoding.dart';
import 'package:pinenacl/key_derivation.dart';
import 'package:test/test.dart';

void main() {
  final entropyPlusCs24Words = 256;
  final testMnemonic1 =
      'rude stadium move tumble spice vocal undo butter cargo win valid session question walk indoor nothing wagon column artefact monster fold gallery receive just';
  final testEntropy1 =
      'bcfa7e43752d19eabb38fa22bf6bc3622af9ed1cc4b6f645b833c7a5a8be2ce3';
  final testHexSeed1 =
      'ee344a00f29cc2fb0a84e43afd91f06beabe5f39e9e84eec729f64c56068d5795ea367d197e5d851a529f33e1d582c63887d0bb59fba8956d78fcf9f697f16a1';
  group('bip-topl e2e test', () {
    test('entropy to root private and public keys', () {
      final expectedXskBip32Bytes =
          '152,156,7,208,14,141,61,24,124,24,85,242,84,104,224,19,251,27,202,217,52,48,252,90,41,138,37,152,2,17,143,69,30,132,107,115,166,39,197,74,177,61,73,245,153,91,133,99,179,42,216,96,192,25,162,139,11,149,50,9,205,17,188,24,67,84,138,25,214,42,52,209,113,75,26,194,25,3,82,78,255,250,186,0,196,244,252,178,3,100,150,97,182,30,44,166'
              .split(',')
              .map((n) => int.parse(n))
              .toList();
      final expectedXvkBip32Bytes =
          '144,157,252,200,194,195,56,252,90,234,197,170,203,188,44,108,87,67,179,130,54,219,203,57,57,5,159,226,111,24,18,158,67,84,138,25,214,42,52,209,113,75,26,194,25,3,82,78,255,250,186,0,196,244,252,178,3,100,150,97,182,30,44,166'
              .split(',')
              .map((n) => int.parse(n))
              .toList();
      final testEntropy =
          '4e828f9a67ddcff0e6391ad4f26ddb7579f59ba14b6dd4baf63dcfdb9d2420da';
      final seed = Uint8List.fromList(HexCoder.instance.decode(testEntropy));
      final rawMaster = PBKDF2.hmac_sha512(Uint8List(0), seed, 4096, XPRV_SIZE);
      expect(rawMaster[0], 156, reason: 'byte 0 before normalization');
      expect(rawMaster[31], 101, reason: 'byte 31 before normalization');
      final root_xsk = Bip32SigningKey.normalizeBytes(rawMaster);
      expect(root_xsk.keyBytes[0], 152, reason: 'byte 0 after normalization');
      expect(root_xsk.keyBytes[31], 69, reason: 'byte 31 after normalization');
      expect(root_xsk.keyBytes,
          expectedXskBip32Bytes.sublist(0, EXTENDED_SECRET_KEY_SIZE),
          reason: 'first 64 bytes are private key');
      expect(root_xsk.chainCode,
          expectedXskBip32Bytes.sublist(EXTENDED_SECRET_KEY_SIZE),
          reason: 'second 32 bytes are chain code');
      final root_xvk = root_xsk.verifyKey;
      expect(
          root_xvk.keyBytes, expectedXvkBip32Bytes.sublist(0, PUBLIC_KEY_SIZE),
          reason: 'first 32 bytes are public key');
      expect(root_xvk.chainCode, expectedXvkBip32Bytes.sublist(PUBLIC_KEY_SIZE),
          reason: 'second 32 bytes are chain code');
      expect(root_xsk.chainCode, root_xvk.chainCode);
    });

    group('mnemonic words', () {
      test('validate', () {
        expect(validateMnemonic(testMnemonic1, 'english'), isTrue,
            reason: 'validateMnemonic returns true');
      });

      test('to entropy', () {
        final entropy = mnemonicToEntropy(testMnemonic1, 'english');
        expect(entropy, equals(testEntropy1));
      });

      test('to seed hex', () {
        final seedHex = mnemonicToSeedHex(testMnemonic1, passphrase: 'TREZOR');
        expect(seedHex, equals(testHexSeed1));
      });
    });
  });
}
