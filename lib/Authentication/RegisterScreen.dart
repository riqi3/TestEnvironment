import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
 

import 'package:get/get.dart';

import '../main.dart';
import '../utils.dart';

class RegisterScreen extends StatefulWidget {
  final Function() onClickedSignUp;
  const RegisterScreen({Key? key, required this.onClickedSignUp}): super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
 final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

 

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  // final navigatorKey = GlobalKey<NavigatorState>();

  Future signUp() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
 
      print(e);
      Utils.showSnackBar(e.message);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
    // navigatorKey.currentState?.popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User RegisterScreen'),
      ),
      body: LayoutBuilder(builder: (context, cons) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: cons.maxHeight,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                               
                      TextFormField(
                        
                        controller: _emailController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) =>
                            value != null && !EmailValidator.validate(value)
                            ? 'enter valid email'
                            : null,
                        decoration: const InputDecoration(
                          hintText: 'email',
                        ),
                      ),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: false,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) =>
                            value != null && value.length < 6
                            ? 'enter valid password of minimum 6 characters'
                            : null,
                        decoration: const InputDecoration(
                          hintText: 'password',
                        ),
                      ),
                     
                      TextButton(
                        onPressed: () async {
                          // if (_nameController.text.isNotEmpty &&
                          //         _emailController.text.isNotEmpty &&
                          //         _passwordController1.text.isNotEmpty ||
                          //     _passwordController2.text.isNotEmpty) {
                          //   var registerResponse =
                          //       await authService.userRegister(
                          //     _nameController.text,
                          //     _emailController.text,
                          //     _passwordController1.text,
                          //     _passwordController2.text,
                          //   );
                
                          //   if (registerResponse.runtimeType == String) {
                          //     _showDialog(context, registerResponse);
                          //   } else {
                          //     if (registerResponse.statusCode == 204) {
                          //       // User user = registerResponse;
                          //       // context.read<UserCubit>().emit(user);
                          //       clearText();
                          //       Get.to(()=>const LoginScreen());
                          //     } else {}
                          //   }
                
                          //   // if (registerResponse.runtimeType == String) {
                          //   //   _showDialog(context, registerResponse);
                          //   //   // if(_passwordController1 == _passwordController2){
                          //   //   // }
                
                          //   // } else if (registerResponse.runtimeType == User) {
                          //   //   User user = registerResponse;
                          //   //   context.read<UserCubit>().emit(user);
                          //   //   clearText();
                          //   //   Get.to(LoginScreen());
                          //   // }
                          // }
                          signUp();
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
          
                    RichText(
                      text: TextSpan(
                        text: 'already have bitches? ',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = widget.onClickedSignUp,
                            text: 'sign up',
                            style: TextStyle(
                              color: Colors.amber,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Future<dynamic> _showDialog(BuildContext context, registerResponse) {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          alignment: Alignment.center,
          child: Container(
            height: 100,
            width: 200,
            decoration: const BoxDecoration(),
            child: Text(
              registerResponse.toString(),
            ),
          ),
        );
      },
    );
  }
}
