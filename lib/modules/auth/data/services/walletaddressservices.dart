import 'package:bip39/bip39.dart' as bip39;
import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import 'package:flutter/material.dart';
import 'package:hex/hex.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart';

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

//clear private key
  Future<void> clearPrivateKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('privateKey');
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

//get balance
  Future<String> getBalance(String address, String chain) async {
    final url = Uri.http(
        '81255eae-6d52-4622-a7cb-2dea4bdf798c-00-34u4anflkzbsi.riker.replit.dev',
        '/get-token-balance', {
      'address': address,
      'chain': chain,
    });
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load balance');
    }
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

//generate public key using old mnemonic
  Future<void> getExistingPrivateKey(String mnemonic) async {
    final seed = bip39.mnemonicToSeed(mnemonic);
    final master = await ED25519_HD_KEY.getMasterKeyFromSeed(seed);
    final privatekey = HEX.encode(master.key);
    await setPrivateKey(privatekey);
  }

  //send tokens
  Future<void> sendTokens(
      String receiverAddress, String txnValue, BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String pvKey = prefs.getString('privateKey') ?? '';

      if (pvKey.isEmpty) throw Exception("Private key not found.");

      // Ensure receiver address is in proper hex format
      receiverAddress = receiverAddress.trim();
      if (!receiverAddress.startsWith("0x")) {
        receiverAddress = "0x$receiverAddress";
      }

      try {
        EthereumAddress.fromHex(receiverAddress);
      } catch (e) {
        throw Exception("Invalid Ethereum address.");
      }

      var apiURL =
          'https://sepolia.infura.io/v3/e6f87a7eca7a43cd89085c05e158a04c';
      var ethClient = Web3Client(apiURL, http.Client());

      EthPrivateKey credentials = EthPrivateKey.fromHex(pvKey);
      BigInt value = BigInt.parse(txnValue);
      EtherAmount gasPrice = await ethClient.getGasPrice();

      await ethClient.sendTransaction(
        credentials,
        Transaction(
          to: EthereumAddress.fromHex(receiverAddress),
          value: EtherAmount.inWei(value),
          gasPrice: gasPrice,
          maxGas: 21000,
        ),
        chainId: 11155111,
      );

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Transaction successful!",
            style: TextStyle(color: Colors.green),
          ),
        ),
      );
    } catch (e) {
      print("Transaction Error: $e"); // Debugging log

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Transaction failed: $e",
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    }
  }

  @override
  Future<EthereumAddress> getPublicKey(String privateKey) async {
    //get public key aka address
    final privatekey = EthPrivateKey.fromHex(privateKey);
    final address = await privatekey.address;
    return address;
  }
}
