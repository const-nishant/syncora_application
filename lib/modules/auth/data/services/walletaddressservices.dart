import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import 'package:flutter/foundation.dart';
import 'package:hex/hex.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart';
import 'package:bip39/bip39.dart' as bip39;

abstract class WalletAddressService {
  String generateMnemonic();
  Future<String> getPrivateKey(String mnemonic);
  Future<EthereumAddress> getPublicKey(String privateKey);
}

class WalletProvider extends ChangeNotifier implements WalletAddressService {
  String? privateKey;
  String? _mnemonic;
  String? get mnemonic => _mnemonic;
  String? _walletAddress;
  String? get walletAddress => _walletAddress;
  String balance = '';
  String? _pvKey;
  String? get pvKey => _pvKey;

  Future<void> loadPrivateKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    privateKey = prefs.getString('privateKey');
  }

  Future<void> setPrivateKey(String privateKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('privateKey', privateKey);
    notifyListeners();
  }

  Future<void> createWallet() async {
    String mnemonic = generateMnemonic();
    _mnemonic = mnemonic;
    String privateKey = await getPrivateKey(mnemonic);
    String publicKey = (await getPublicKey(privateKey)).hex;
    loadPrivateKey();
    _walletAddress = publicKey;
    await setPrivateKey(privateKey);
    notifyListeners();
  }

  Future<void> loadWalletData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? privateKey = prefs.getString('privateKey');
    if (privateKey != null) {
      await loadPrivateKey();
      EthereumAddress address = await getPublicKey(privateKey);
      _walletAddress = address.hex;
      _pvKey = privateKey;
      notifyListeners();
    }
  }

  @override
  String generateMnemonic() {
    //generate mnemonic
    return bip39.generateMnemonic();
  }

  @override
  Future<String> getPrivateKey(String mnemonic) async {
    final seed = bip39.mnemonicToSeed(mnemonic);
    final master = await ED25519_HD_KEY.getMasterKeyFromSeed(seed);
    final privatekey = HEX.encode(master.key);
    return privatekey;
  }

  @override
  Future<EthereumAddress> getPublicKey(String privateKey) async {
    //get public key aka address
    final privatekey = EthPrivateKey.fromHex(privateKey);
    final address = await privatekey.address;
    return address;
  }
}
