import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:syncora_application/common/commontextfield.dart';
import 'package:syncora_application/common/customdivider.dart';
import 'package:syncora_application/common/large_button.dart';

import '../../../common/continue_with_google.dart';
import '../auth_exports.dart';

class Signupscreen extends StatefulWidget {
  final void Function()? onTap;
  const Signupscreen({super.key, this.onTap});

  @override
  State<Signupscreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<Signupscreen> {
  bool obscureText = true;
  bool obscureTextConfirm = true;

  final GlobalKey<FormState> signupformkey = GlobalKey<FormState>();
  final TextEditingController usernameTextEditingController =
      TextEditingController();
  final TextEditingController emailTextEditingController =
      TextEditingController();
  final TextEditingController passwordTextEditingController =
      TextEditingController();
  final TextEditingController confirmPasswordTextEditingController =
      TextEditingController();

  Future signup() async {
    if (signupformkey.currentState!.validate()) {
      Provider.of<AuthServices>(context, listen: false).signup(
        usernameTextEditingController.text.trim(),
        emailTextEditingController.text.trim(),
        passwordTextEditingController.text.trim(),
        context,
      );
    }
  }

  @override
  void dispose() {
    usernameTextEditingController.dispose();
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();
    confirmPasswordTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        autovalidateMode: AutovalidateMode.always,
        key: signupformkey,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.16,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10,
                children: [
                  const Text(
                    "Create a new Account",
                    style: TextStyle(
                      fontSize: 32,
                      fontFamily: 'FontMain',
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6A3200),
                    ),
                  ),
                  const SizedBox(
                    height: 6.0,
                  ),
                  Commontextfield(
                    controller: usernameTextEditingController,
                    keyboardType: TextInputType.name,
                    prefixIcon: const Icon(LucideIcons.user),
                    hintText: "Create your username ",
                    obscureText: false,
                    readOnly: false,
                    focusNode: FocusNode(),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Username cannot be empty";
                      }
                      return null;
                    },
                  ),
                  Commontextfield(
                    controller: emailTextEditingController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(LucideIcons.mail),
                    hintText: "Enter your email",
                    obscureText: false,
                    readOnly: false,
                    focusNode: FocusNode(),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Email cannot be empty";
                      }
                      return null;
                    },
                  ),
                  Commontextfield(
                    controller: passwordTextEditingController,
                    keyboardType: TextInputType.visiblePassword,
                    hintText: "Enter your password",
                    obscureText: obscureText,
                    readOnly: false,
                    focusNode: FocusNode(),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Password cannot be empty";
                      }
                      return null;
                    },
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () {
                        setState(() {
                          obscureText = !obscureText;
                        });
                      },
                    ),
                  ),
                  Commontextfield(
                    controller: confirmPasswordTextEditingController,
                    keyboardType: TextInputType.visiblePassword,
                    hintText: "Confirm your password",
                    obscureText: obscureTextConfirm,
                    readOnly: false,
                    focusNode: FocusNode(),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Password cannot be empty";
                      }
                      if (value != passwordTextEditingController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      color: Theme.of(context).colorScheme.primary,
                      icon: Icon(
                        obscureTextConfirm
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () {
                        setState(() {
                          obscureTextConfirm = !obscureTextConfirm;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  LargeButton(onPressed: signup, text: "Sign Up"), //signup
                  const SizedBox(
                    height: 6.0,
                  ),
                  const CustomDivider(text: "Or Sign Up With"),
                  const SizedBox(
                    height: 6.0,
                  ),
                  const ContinueWithGoogle(),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          "Log In Now",
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor:
                                Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
