import 'dart:convert';
import 'dart:typed_data';

import 'keystore_signature_platform_interface.dart';
import 'package:crypto/crypto.dart';

/// Signature for the supported hash algorithms used to generate app hash keys.
enum HashAlgorithm {
  sha1,
  sha256,
  sha512,
  md5,
}

/// A class for obtaining app hash keys from the platform (Android)
/// and converting them into different hash formats (e.g. SHA, MD5)
/// and encodings (Hex, Base64).
class KeystoreSignature {
  /// Returns the hash keys as raw bytes ([Uint8List]) for the specified [algorithm].
  ///
  /// This retrieves the signatures from the platform via [KeystoreHashPlatform]
  /// and applies the chosen hash algorithm to each signature.
  static Future<List<Uint8List>> digest(HashAlgorithm algorithm) async {
    final bytesList = await KeystoreSignaturePlatform.instance.getSignatures();
    final formatted = bytesList.map((bytes) {
      final Digest digest;

      switch (algorithm) {
        case HashAlgorithm.sha1:
          digest = sha1.convert(bytes);
          break;
        case HashAlgorithm.sha256:
          digest = sha256.convert(bytes);
          break;
        case HashAlgorithm.sha512:
          digest = sha512.convert(bytes);
          break;
        case HashAlgorithm.md5:
          digest = md5.convert(bytes);
          break;
      }

      return digest.bytes;
    });

    return formatted.map((bytes) => Uint8List.fromList(bytes)).toList();
  }

  /// Returns the hash keys encoded as hexadecimal strings for the specified [algorithm].
  ///
  /// These hex-formatted hash keys are primarily used for registering the Android application
  /// SHA-1 or SHA-256 keys with Firebase or other services that require hex-encoded signatures.
  static Future<List<String>> digestAsHex(HashAlgorithm algorithm) async {
    final hashKeys = await digest(algorithm);
    final hexItems = hashKeys.map((key) {
      return key.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
    });

    return hexItems.toList();
  }

  /// Returns the hash keys encoded as Base64 strings for the specified [algorithm].
  ///
  /// These Base64-encoded hash keys are mainly used for registering
  /// the Android application hash key with services like Kakao Developers.
  static Future<List<String>> digestAsBase64(HashAlgorithm algorithm) async {
    final hashKeys = await digest(algorithm);
    return hashKeys.map(base64Encode).toList();
  }
}
