import 'package:serverpod/serverpod.dart';
import 'package:gitradar_server/server.dart';

void main(List<String> args) async {
  // Initialize Serverpod and connect it with your generated code.
  final pod = Serverpod(
    args,
    Protocol(),
    Endpoints(),
  );

  // Start the server.
  await pod.start();
}
