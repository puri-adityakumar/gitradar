import 'package:serverpod/serverpod.dart';
import 'package:gitradar_server/server.dart';
import 'package:gitradar_server/src/futures/repository_sync_call.dart';

void main(List<String> args) async {
  // Initialize Serverpod and connect it with your generated code.
  final pod = Serverpod(
    args,
    Protocol(),
    Endpoints(),
  );

  // Register the repository sync future call
  pod.registerFutureCall(
    RepositorySyncFutureCall(),
    'repositorySync',
  );

  // Start the server.
  await pod.start();

  // Initialize the sync job after server starts
  await _initializeSyncJob(pod);
}

/// Initialize the sync job if not already scheduled.
Future<void> _initializeSyncJob(Serverpod pod) async {
  final session = await pod.createSession();
  try {
    // Schedule the first sync to run in 1 minute
    // The job will reschedule itself after each run
    await pod.futureCallWithDelay(
      'repositorySync',
      null,
      Duration(minutes: 1),
    );
    session.log(
      'Repository sync job scheduled to start in 1 minute',
      level: LogLevel.info,
    );
  } catch (e) {
    session.log(
      'Failed to schedule sync job: $e',
      level: LogLevel.warning,
    );
  } finally {
    await session.close();
  }
}
