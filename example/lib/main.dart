import 'package:flutter/material.dart';
import 'dart:async';

import 'package:keystore_signature/keystore_signature.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String> _hashKeys = [];

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    final List<String> hashKeys;

    hashKeys = await KeystoreSignature.digestAsHex(HashAlgorithm.sha1);

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _hashKeys = hashKeys;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: Center(
          // This hash key can be used for registering with Firebase.
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Text('Hash Key: ${_hashKeys.firstOrNull}\n'),
          ),
        ),
      ),
    );
  }
}
