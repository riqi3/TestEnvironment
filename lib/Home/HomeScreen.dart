import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
    final TextEditingController _firstName = TextEditingController();
    final TextEditingController _lastName = TextEditingController();

final SmsQuery _query = SmsQuery();
  List<SmsMessage> _messages = [];

  @override
  void initState() {
    super.initState();
  }

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
          Expanded(
            child: Container(
            padding: const EdgeInsets.all(10.0),
            child: _messages.isNotEmpty
                ? _MessagesListView(
                    messages: _messages,
                  )
                : Center(
                    child: Text(
                      'No messages to show.\n Tap refresh button...',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ),
          ),
        ],
      ),
              floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var permission = await Permission.sms.status;
            if (permission.isGranted) {
              final messages = await _query.querySms(
                kinds: [
                  SmsQueryKind.inbox,
                  SmsQueryKind.sent,
                ],
                // address: '+254712345789',
                count: _messages.length,
              );
              debugPrint('sms inbox messages: ${messages.length}');

              setState(() => _messages = messages);
            } else {
              await Permission.sms.request();
            }
          },
          child: const Icon(Icons.refresh),
        ),
    );
  }
}


class _MessagesListView extends StatelessWidget {
  const _MessagesListView({
    Key? key,
    required this.messages,
  }) : super(key: key);

  final List<SmsMessage> messages;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: messages.length,
      itemBuilder: (BuildContext context, int i) {
        var message = messages[i];

        return ListTile(
          title: Text('${message.sender} [${message.date}]'),
          subtitle: Text('${message.body}'),
        );
      },
    );
  }
}