import 'package:flutter/material.dart';

import '../consants/images.dart';

class ContinueWithGoogle extends StatelessWidget {
  const ContinueWithGoogle({super.key});

  @override
  Widget build(BuildContext context) {
    void continueWithGoogle(BuildContext context) {
      // Provider.of<AuthServices>(context, listen: false)
      //     .continueWithGoogle(context);
    }

    return ElevatedButton(
      onPressed: () => continueWithGoogle(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFE5E9ED),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            Images.google_logo,
            height: 24,
          ),
          const SizedBox(width: 12),
          const Text(
            'Continue with Google',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
