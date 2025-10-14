# Introduction

A **Flutter plugin for Android** that retrieves the app signature hash keys and converts them into various hash formats (SHA-1, SHA-256, SHA-512, MD5) in Hex or Base64 encoding.  

This plugin is mainly useful for registering app hash keys with services like Firebase (hex format) or Kakao Developers (Base64 format).

## Usage
This section covers the basic usage of this package and how to integrate it into your application.

### Getting Hashed App Keys

```dart
import 'package:keystore_signature/keystore_signature.dart';

void main() async {
  // Get SHA-1 hash key in Hex (for Firebase)
  final hexKeys = await KeystoreSignature.digestAsHex(HashAlgorithm.sha1);
  print('SHA-1 Hex Key: ${hexKeys.first}');

  // Get SHA-256 hash key in Base64 (for Kakao Developers)
  final base64Keys = await KeystoreSignature.digestAsBase64(HashAlgorithm.sha256);
  print('SHA-256 Base64 Key: ${base64Keys.first}');
}
```

### Getting Raw App Signatures

```dart
// Get the raw app signatures directly from the Android keystore.
// These are the original bytes before being hashed or encoded.
final hashKeys = await KeystoreSignaturePlatform.instance.getSignatures();
print('Raw Hash Key: ${hashKeys.first}');
```
