import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../common/commontextfield.dart';
import '../../../common/continue_with_google.dart';
import '../../../common/customdivider.dart';
import '../../../common/large_button.dart';
import '../auth_exports.dart';

class Loginscreen extends StatefulWidget {
  final void Function()? onTap;
  const Loginscreen({super.key, this.onTap});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  bool obscureText = true;
  bool _rememberMe = false;
  final GlobalKey<FormState> loginformKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login() {
    if (loginformKey.currentState!.validate()) {
      Provider.of<AuthServices>(context, listen: false).login(
        emailController.text.trim(),
        passwordController.text.trim(),
        context,
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Form(
        autovalidateMode: AutovalidateMode.always,
        key: loginformKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.24,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10,
                children: [
                  Text(
                    "Welcome Back !",
                    style: TextStyle(
                      fontSize: 32,
                      fontFamily: 'FontMain',
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(
                    "Please login your account",
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Commontextfield(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    hintText: "Enter Your Email",
                    prefixIcon: Icon(LucideIcons.mail),
                    obscureText: obscureText,
                    readOnly: false,
                    focusNode: FocusNode(),
                  ),
                  Commontextfield(
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      hintText: "Enter Your Password",
                      obscureText: obscureText,
                      readOnly: false,
                      focusNode: FocusNode(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        } else if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                      prefixIcon: Icon(LucideIcons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureText ? LucideIcons.eyeOff : LucideIcons.eye,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        onPressed: () {
                          setState(() {
                            obscureText = !obscureText;
                          });
                        },
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            checkColor: Colors.black,
                            activeColor: Colors.transparent,
                            side: BorderSide(
                              width: 1,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              side: BorderSide(
                                width: 1,
                                color: _rememberMe
                                    ? Colors.transparent
                                    : Colors.black,
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                if (value != null) {
                                  _rememberMe = value;
                                }
                              });
                            },
                          ),
                          Text(
                            "Remember me",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          // context.go("/forgot_password");
                        },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  LargeButton(onPressed: login, text: "Log In"),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomDivider(text: "Or Continue with"),
                  const SizedBox(
                    height: 10,
                  ),
                  ContinueWithGoogle(),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Dont have an account?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          "Sign Up Now",
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
                  SizedBox(
                    height: 18,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
