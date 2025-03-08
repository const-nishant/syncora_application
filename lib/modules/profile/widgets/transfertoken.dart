import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncora_application/common/commontextfield.dart';
import 'package:syncora_application/common/large_button.dart';

import '../../auth/data/services/walletaddressservices.dart';

class Transfertoken extends StatefulWidget {
  const Transfertoken({super.key});

  @override
  State<Transfertoken> createState() => _TransfertokenState();
}

class _TransfertokenState extends State<Transfertoken> {
  @override
  Widget build(BuildContext context) {
    TextEditingController amountController = TextEditingController();
    TextEditingController addressController = TextEditingController();
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "Transfer token",
                style: TextStyle(
                  fontSize: 32,
                  fontFamily: 'FontMain',
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Commontextfield(
                controller: amountController,
                keyboardType: TextInputType.number,
                hintText: "Amount (tokens)",
                obscureText: false,
                readOnly: false,
                focusNode: FocusNode(),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                }),
            SizedBox(
              height: 10,
            ),
            Commontextfield(
                controller: addressController,
                keyboardType: TextInputType.text,
                hintText: "Wallet Address",
                obscureText: false,
                readOnly: false,
                focusNode: FocusNode(),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a valid address';
                  }
                  return null;
                }),
            SizedBox(
              height: 10,
            ),
            LargeButton(
                onPressed: () async {
                  // Add your transfer logic here
                  if (amountController.text.isNotEmpty &&
                      addressController.text.isNotEmpty) {
                    // Perform the transfer logic here
                    await Provider.of<WalletProvider>(context, listen: false)
                        .sendTokens(addressController.text,
                            amountController.text, context);
                  }
                },
                text: "Transfer"),
          ],
        ),
      ),
    );
  }
}
