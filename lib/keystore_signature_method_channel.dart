import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'keystore_signature_platform_interface.dart';

/// An implementation of [MethodChannelKeystoreSignature] that uses method channels.
class MethodChannelKeystoreSignature extends KeystoreSignaturePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel("keystore_signature");

  @override
  Future<List<Uint8List>> getSignatures() async {
    assert(Platform.isAndroid);
    final List<Object?> result =
        await methodChannel.invokeMethod("getSignatures");

    return result.map((item) {
      if (item is List) {
        return Uint8List.fromList(item.cast<int>());
      } else {
        throw Exception(
          "Expected a List<int> from native, but got '${item.runtimeType}'."
          "Therefore, Please check the native implementation.",
        );
      }
    }).toList();
  }
}
