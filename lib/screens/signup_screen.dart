import 'dart:developer';

import 'package:e_voting/providers/firebase_auth_provider.dart';
import 'package:e_voting/widgets/passwordfield.dart';
import 'package:e_voting/widgets/toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:e_voting/screens/create_profile_screen.dart';

import 'package:e_voting/screens/login_screen.dart';

import 'package:e_voting/services/user_data.dart';
import 'package:e_voting/utils/constants.dart';
import 'package:e_voting/widgets/signup_login_button.dart';
import 'package:provider/provider.dart';

import '../widgets/input_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late double height = MediaQuery.of(context).size.height;
  TextEditingController namecontroller = TextEditingController();
  TextEditingController cniccontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController doecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  final signupformkey = GlobalKey<FormState>();
  final toast = FToast();
  @override
  void initState() {
    super.initState();
    toast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: signupformkey,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: height * 0.1,
                  ),
                  const Text(
                    "Sign up",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff027314),
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  InputField(
                    label: 'Name',
                    labelText: 'Enter Your Name',
                    controller: namecontroller,
                    errormessage: "Please enter valid name",
                  ),
                  InputField(
                    label: 'CNIC',
                    labelText: '37406-3675252-1',
                    controller: cniccontroller,
                    errormessage: "Please Enter valid Cnic",
                    fieldmessage: "Cnic",
                  ),
                  InputField(
                    label: 'Date of Expiry',
                    labelText: '02/22',
                    controller: doecontroller,
                    errormessage: "Enter valid date",
                    fieldmessage: "DOE",
                  ),
                  InputField(
                    label: 'Email',
                    labelText: 'example@gmail.com',
                    controller: emailcontroller,
                    errormessage: "Enter valid email",
                    fieldmessage: "email",
                  ),
                  PasswordField(
                    label: 'Password',
                    labelText: '*********',
                    controller: passwordcontroller,
                    obscure: true,
                    errormessage: "Enter valid password 8-50",
                  ),
                  SignupLoginButton(
                    isLoading: context.watch<FirebaseAuthProvider>().isLoading,
                    btnText: 'Continue',
                    function: () async {
                      await registeruser();
                    },
                    formkey: signupformkey,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(
                            fontSize: 14,
                            color: Constants.greyColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            " Login",
                            style: TextStyle(
                              color: Constants.primarycolor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> registeruser() async {
    try {
      await context
          .read<FirebaseAuthProvider>()
          .signuowithEmailandPassword(
              emailcontroller.text, passwordcontroller.text)
          .then(
        (value) {
          final user = UserData(
            fullName: namecontroller.text,
            cnic: cniccontroller.text,
            doe: doecontroller.text,
            email: emailcontroller.text,
            password: passwordcontroller.text,
            number: " ",
            mName: " ",
            perAddress: " ",
            currAddress: " ",
          );
          UserData.savePassToFirestore(user);

          toast.showToast(
              child: buildtoast("Sign Up successful", "success"),
              gravity: ToastGravity.BOTTOM);
          if (!mounted) return;
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const CreateProfile(),
              ),
              (route) => false);
        },
      ).onError(
        (error, stackTrace) {
          toast.showToast(
              child: buildtoast("Sign Up unsuccessful", "error"),
              gravity: ToastGravity.BOTTOM);
        },
      );
    } catch (e) {
      log(e.toString());
    }
  }
}
