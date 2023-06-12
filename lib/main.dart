import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
 
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:untitled_project/Authentication/AuthScreen.dart';
import 'package:untitled_project/utils.dart';
 

 
import 'Home/HomeScreen.dart';
import 'TestProvider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => TestProvider(),
          child:   TestEnv(),
        ),
      ],
      child: TestEnv(),
    ),
  );
} 
final navigatorKey = GlobalKey<NavigatorState>();
 
class TestEnv extends StatelessWidget {
  TestEnv({super.key});

 // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: Utils.messengerKey,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'UNTITLED APP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        else if (snapshot.hasError){
          return Center(
            child: Text('Something went wrong!'),
          );
        }
        else if (snapshot.hasData){
          return HomeScreen();
        }
        else{
          return AuthScreen();
        }
      },
    ),
  );
}