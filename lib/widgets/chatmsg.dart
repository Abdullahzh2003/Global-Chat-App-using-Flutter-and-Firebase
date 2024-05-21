import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:messagefinal/widgets/chatbubble.dart';

class chatmsg extends StatelessWidget {
  const chatmsg({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticateduser = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('createAt', descending: true)
            .snapshots(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No Message yet'),
            );
          }
          return ListView.builder(
              reverse: true, // its show from bottom to top
              padding: const EdgeInsets.only(bottom: 40, left: 30, right: 30),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (ctx, index) {
                final chatmsg = snapshot.data!.docs[index].data();
                final nextmsg = index + 1 < snapshot.data!.docs.length
                    ? snapshot.data!.docs[index + 1].data()
                    : null;
                final currmsguserid = chatmsg['userId'];
                final nextmsgusernameid =
                    nextmsg != null ? nextmsg['userId'] : null;
                final nextsame = nextmsgusernameid == currmsguserid;
                if (nextsame) {
                  return MessageBubble.next(
                      message: chatmsg['text'],
                      isMe: authenticateduser!.uid == currmsguserid);
                } else {
                  return MessageBubble.first(
                      userImage: chatmsg['userimg'],
                      username: chatmsg['username'],
                      message: chatmsg['text'],
                      isMe: authenticateduser!.uid == currmsguserid);
                }
              });
        });
  }
}
