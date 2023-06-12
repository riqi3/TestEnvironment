import 'package:flutter/material.dart';
import 'package:untitled_project/Authentication/LoginScreen.dart';
import 'package:untitled_project/Authentication/RegisterScreen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  
  @override
  Widget build(BuildContext context) => 
  isLogin ? LoginScreen(onClickedSignUp: toggle) : RegisterScreen(onClickedSignUp: toggle);
  void toggle()=>setState(() {
    isLogin = !isLogin;
  });
}