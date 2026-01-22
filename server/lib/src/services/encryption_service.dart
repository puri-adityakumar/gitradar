import 'package:encrypt/encrypt.dart';

/// Shared encryption service for PAT storage.
/// Uses AES-256 encryption.
class EncryptionService {
  // AES encryption key - in production, load from environment variable
  static final _encryptionKey = Key.fromLength(32);
  static final _iv = IV.fromLength(16);
  static final _encrypter = Encrypter(AES(_encryptionKey));

  /// Encrypt a plaintext string.
  static String encrypt(String plaintext) {
    return _encrypter.encrypt(plaintext, iv: _iv).base64;
  }

  /// Decrypt an encrypted string.
  static String decrypt(String encrypted) {
    return _encrypter.decrypt64(encrypted, iv: _iv);
  }
}
