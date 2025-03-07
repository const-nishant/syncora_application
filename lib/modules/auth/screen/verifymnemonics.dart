import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:syncora_application/common/commontextfield.dart';
import 'package:syncora_application/common/large_button.dart';
import 'package:syncora_application/modules/auth/data/services/authservices.dart';

class Verifymnemonics extends StatefulWidget {
  final String mnemonic;
  const Verifymnemonics({super.key, required this.mnemonic});

  @override
  State<Verifymnemonics> createState() => _VerifymnemonicsState();
}

class _VerifymnemonicsState extends State<Verifymnemonics> {
  TextEditingController menoicscontroller = TextEditingController();

  void verifyMnemonics() async {
    if (menoicscontroller.text == widget.mnemonic) {
      // Navigate to the next screen
      await Provider.of<AuthServices>(context, listen: false)
          .changeSignupStatus(true);
      Phoenix.rebirth(context);
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mnemonics does not match'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    menoicscontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Verify Mnemonics")),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Please verify your Mnemonics',
              style: TextStyle(
                fontSize: 22,
                fontFamily: 'FontMain',
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Commontextfield(
              controller: menoicscontroller,
              keyboardType: TextInputType.text,
              hintText: 'Enter your Mnemonics',
              obscureText: false,
              readOnly: false,
              focusNode: FocusNode(),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your Mnemonics';
                }
                if (value != widget.mnemonic) {
                  return 'Mnemonics does not match';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            LargeButton(onPressed: verifyMnemonics, text: 'Verify'),
          ],
        ),
      ),
    );
  }
}
