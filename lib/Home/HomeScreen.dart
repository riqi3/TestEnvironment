import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
    final TextEditingController _firstName = TextEditingController();
    final TextEditingController _lastName = TextEditingController();

  void clearText(){
    _firstName.clear();
    _lastName.clear();
  }

Future createUser({required String firstName, required String lastName}) async {
  final docUser = FirebaseFirestore.instance.collection('users').doc();

  final json = {
    'firstName' : firstName,
    'lastName': lastName
  };

  await docUser.set(json);
}

  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome ${user.email}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined, color: Colors.black),
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: Column(
        children: [
          TextFormField(
            controller: _firstName,
            // autovalidateMode: AutovalidateMode.onUserInteraction,
            // validator: (value) =>
            //     value != null && !EmailValidator.validate(value)
            //     ? 'enter valid email'
            //     : null,
            decoration: const InputDecoration(
              hintText: 'firstname',
            ),
          ),
          TextFormField(
            controller: _lastName,
            // obscureText: false,
            // autovalidateMode: AutovalidateMode.onUserInteraction,
            // validator: (value) =>
            //     value != null && value.length < 6
            //     ? 'enter valid password of minimum 6 characters'
            //     : null,
            decoration: const InputDecoration(
              hintText: 'lastname',
            ),
          ),
          TextButton(
            onPressed: () async {
              final fn = _firstName.text;
              final ln = _lastName.text;

              createUser(firstName: fn, lastName: ln);
              clearText();
            },
            child: const Text(
              "Add User",
              style: TextStyle(),
            ),
          ),
        ],
      ),
    );
  }
}
