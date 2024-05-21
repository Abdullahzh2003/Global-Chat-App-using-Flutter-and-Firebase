import 'package:flutter/material.dart';

class loading extends StatelessWidget {
  const loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Messenger App "),
      ),
      body: const Center(
        child: Text("Loading ..."),
      ),
    );
  }
}
