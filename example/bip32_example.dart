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
