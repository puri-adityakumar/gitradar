import 'package:encrypt/encrypt.dart';

void main() {
  final key = Key.fromUtf8('GitRadar2026SecretKey32BytesABCD');
  final iv = IV.fromUtf8('GitRadarIV16Byte');
  final encrypter = Encrypter(AES(key));
  final pat = 'YOUR_GITHUB_PAT_HERE';
  final encrypted = encrypter.encrypt(pat, iv: iv).base64;
  print('Encrypted PAT: $encrypted');
}
