import 'package:encrypt/encrypt.dart';

/// Shared encryption service for PAT storage.
/// Uses AES-256 encryption with a fixed key.
class EncryptionService {
  // Fixed AES encryption key (32 bytes for AES-256)
  static final _encryptionKey = Key.fromUtf8('GitRadar2026SecretKey32BytesABCD');
  // Fixed IV (16 bytes)
  static final _iv = IV.fromUtf8('GitRadarIV16Byte');
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
