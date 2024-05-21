import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messagefinal/screen/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:messagefinal/firebase_options.dart';
import 'package:messagefinal/screen/chatscreen.dart';
import 'package:messagefinal/screen/loading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'FlutterChat',
        theme: ThemeData().copyWith(
          useMaterial3: true,
          inputDecorationTheme:
              const InputDecorationTheme(errorStyle: TextStyle(fontSize: 8)),
          colorScheme:
              ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 43, 165, 94)),
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const loading();
            }
            if (snapshot.hasData) {
              return const chatscreen();
            }
            return const AuthScreen();
          },
        ));
  }
}
