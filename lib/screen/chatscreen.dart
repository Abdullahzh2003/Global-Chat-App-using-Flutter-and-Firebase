import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:messagefinal/widgets/chatmsg.dart';
import 'package:messagefinal/widgets/newmsg.dart';

class chatscreen extends StatefulWidget {
  const chatscreen({super.key});

  @override
  State<chatscreen> createState() => _chatscreenState();
}

class _chatscreenState extends State<chatscreen> {
  // void setupNotification() async {
  //   final fcm = FirebaseMessaging.instance;
  //   await fcm.requestPermission();
  //   final token = await fcm.getToken();
  //   fcm.subscribeToTopic('chat');
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   setupNotification();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Global Chat "),
          actions: [
            IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.exit_to_app),
              color: Theme.of(context).colorScheme.primary,
            )
          ],
        ),
        body: const Column(
          children: [Expanded(child: chatmsg()), newmsg()],
        ));
  }
}
