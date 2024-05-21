import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messagefinal/widgets/imageinput.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var islogin = true;
  File? _selectedimg;
  var _enteredEmail = " ";
  var _enteredpassword = " ";
  var _enteredusername = " ";
  var imgflag = false;
  final _formkey = GlobalKey<FormState>();
  void _submit() async {
    final isvalid = _formkey.currentState!.validate();
    if (!isvalid || !islogin && _selectedimg == null) {
      return;
    }

    _formkey.currentState!.save();
    setState(() {
      imgflag = true;
    });
    try {
      if (islogin) {
        final UserCredential = await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredpassword);
      } else {
        final UserCredential = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredpassword);
        final Storageref = FirebaseStorage.instance
            .ref()
            .child('user_imges')
            .child('${UserCredential.user!.uid}.jpg');
        await Storageref.putFile(_selectedimg!);
        final imgurl = await Storageref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(UserCredential.user!.uid)
            .set({
          'username': _enteredusername,
          'email': _enteredEmail,
          'image_url': imgurl
        });
      }
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.code ?? 'Authentication failed ')));
    }

    setState(() {
      imgflag = false;
    });
  }

  void addimg(File img) {
    _selectedimg = img;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(1),
                width: 200,
                height: 200,
                child: Image.asset('assest/logo.png'),
              ),
              Text(
                "Global chat ",
                style: TextStyle(
                    fontSize: 23,
                    color: Theme.of(context).colorScheme.primaryContainer),
              ),
              Text(
                "Interact with everybody ",
                style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.background),
              ),
              Card(
                margin: const EdgeInsets.all(25),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                        key: _formkey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!islogin) imageinput(addimg),
                            TextFormField(
                              decoration: const InputDecoration(
                                  label: Text(
                                'Email Address',
                                style: TextStyle(fontSize: 14),
                              )),
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty ||
                                    !value.contains('@')) {
                                  return "Please enter a valid Email address";
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                _enteredEmail = newValue!;
                              },
                            ),
                            if (!islogin)
                              TextFormField(
                                decoration: const InputDecoration(
                                    labelText: "Username"),
                                enableSuggestions: false,
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.trim().length < 4) {
                                    return "Username must be of at least 4 characters";
                                  }
                                  return null;
                                },
                                onSaved: (newValue) {
                                  _enteredusername = newValue!;
                                },
                              ),
                            TextFormField(
                              decoration: const InputDecoration(
                                  label: Text(
                                'Password',
                                style: TextStyle(fontSize: 14),
                              )),
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.trim().length < 6) {
                                  return "Password must be at least 6th character long";
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                _enteredpassword = newValue!;
                              },
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            if (imgflag) const CircularProgressIndicator(),
                            if (!imgflag)
                              ElevatedButton(
                                  onPressed: _submit,
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .primaryContainer),
                                  child: Text(islogin ? 'login' : 'Sing up')),
                            if (!imgflag)
                              TextButton(
                                  onPressed: () {
                                    islogin = !islogin;
                                    setState(() {});
                                  },
                                  child: Text(islogin!
                                      ? 'Create an Account'
                                      : 'I already have an account '))
                          ],
                        )),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
