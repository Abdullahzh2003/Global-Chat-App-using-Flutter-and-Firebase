import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class newmsg extends StatefulWidget {
  const newmsg({super.key});

  @override
  State<newmsg> createState() => _newmsgState();
}

class _newmsgState extends State<newmsg> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  void submitmsg() async {
    final enteredmsg = _messageController.text;
    if (enteredmsg.trim().isEmpty) {
      return;
    }
    FocusScope.of(context).unfocus();
    _messageController.clear();
    try {
      final user = FirebaseAuth.instance.currentUser!;

      final userdata = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      print(
          " 111111111111111111111111111111111111111111111111111111111111111 ${userdata.data()} rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
      await FirebaseFirestore.instance.collection('chat').add({
        'text': enteredmsg,
        'createAt': Timestamp.now(),
        'userId': user.uid,
        'username': userdata.data()!['username'],
        'userimg': userdata['image_url']
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            textCapitalization: TextCapitalization.sentences,
            autocorrect: true,
            controller: _messageController,
            enableSuggestions: true,
            decoration: InputDecoration(labelText: 'Send a message '),
          )),
          IconButton(
              color: Theme.of(context).colorScheme.primary,
              onPressed: submitmsg,
              icon: const Icon(Icons.send))
        ],
      ),
    );
  }
}
