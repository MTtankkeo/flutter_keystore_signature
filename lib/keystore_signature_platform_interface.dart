import 'dart:typed_data';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'keystore_signature_method_channel.dart';

/// Abstract class that defines the interface for platform-specific implementations
/// of FlutterKeystore. Each platform (e.g. Android) should provide its own subclass.
abstract class KeystoreSignaturePlatform extends PlatformInterface {
  /// Constructs a FlutterKeystorePlatform.
  KeystoreSignaturePlatform() : super(token: _token);

  static final Object _token = Object();

  static KeystoreSignaturePlatform _instance = MethodChannelKeystoreSignature();

  /// The default instance of [KeystoreSignaturePlatform] to use.
  ///
  /// Defaults to [MethodChannelKeystoreHash].
  static KeystoreSignaturePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [KeystoreSignaturePlatform]
  /// when they register themselves.
  static set instance(KeystoreSignaturePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Returns the list of hash keys from the platform-specific implementation.
  Future<List<Uint8List>> getSignatures() {
    throw UnimplementedError("getSignatures() has not been implemented.");
  }
}
