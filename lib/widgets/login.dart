import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sellers_app/models/global.dart';
import 'package:sellers_app/screens/auth_screen.dart';
import 'package:sellers_app/screens/home_screen.dart';
import 'package:sellers_app/widgets/error_dialog.dart';
import 'package:sellers_app/widgets/loading_dialog.dart';

import 'custom_text_field.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  formValidation() {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      //login
      loginNow();
    } else {
      showDialog(
        context: context,
        builder: (c) {
          return const ErrorDialog(
            message: "please write email/password",
          );
        },
      );
    }
  }

  loginNow() async {
    showDialog(
      context: context,
      builder: (c) {
        return const LoadingDialog(
          message: "Checking credential",
        );
      },
    );
    User? currentUser;
    await firebaseAuth
        .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim())
        .then((auth) {
      currentUser = auth.user!; //!
    }).catchError(
      (error) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: error.message.toString(),
            );
          },
        );
      },
    );
    if (currentUser != null) {
      readDataAndSetDataLocally(currentUser!).then((value) {
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (c) => const HomeScreen(),
          ),
        );
      });
    }
  }

  Future<void> readDataAndSetDataLocally(User currentUser) async {
    await FirebaseFirestore.instance
        .collection("sellers")
        .doc(currentUser.uid)
        .get()
        .then(
      (snapshot) async {
        if (snapshot.exists) {
          await sharedPreferences!.setString(
            "uid",
            currentUser.uid,
          );
          await sharedPreferences!.setString(
            "name",
            snapshot.data()!["sellerName"],
          );
          await sharedPreferences!.setString(
            "email",
            snapshot.data()!["sellerEmail"],
          );
          await sharedPreferences!.setString(
            "photoUrl",
            snapshot.data()!["sellerAvatarUrl"],
          );
        }
        else{
          firebaseAuth.signOut();
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (c) => const AuthScreen(),
            ),
          );
          showDialog(
            context: context,
            builder: (c) {
              return const ErrorDialog(
                message: "there is no account with this email exist",
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Image.asset(
                "images/seller.png",
                height: 270,
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  controller: emailController,
                  data: Icons.email,
                  hintText: "Email",
                  enabled: true,
                  isObscure: false,
                ),
                CustomTextField(
                  controller: passwordController,
                  data: Icons.lock,
                  hintText: "Password",
                  enabled: true,
                  isObscure: true,
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              loginNow();
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.cyan,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            ),
            child: const Text(
              "Login",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
