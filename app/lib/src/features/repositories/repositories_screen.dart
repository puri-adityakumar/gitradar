import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gitradar_client/gitradar_client.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../shared/widgets/empty_widget.dart';
import '../../shared/widgets/error_widget.dart';
import '../../shared/widgets/skeleton_loader.dart';
import 'repositories_provider.dart';

/// Repositories list screen.
class RepositoriesScreen extends ConsumerWidget {
  const RepositoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reposAsync = ref.watch(repositoriesProvider);
    final syncState = ref.watch(syncProvider);

    return Scaffold(
      appBar: AppBar(
        title: reposAsync.whenData((repos) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Repositories'),
              Text(
                '${repos.length}/${AppLimits.maxRepositories} repositories',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          );
        }).value ?? const Text('Repositories'),
        actions: [
          // Sync button
          IconButton(
            icon: syncState.isSyncing
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  )
                : const Icon(Icons.sync),
            onPressed: syncState.isSyncing
                ? null
                : () => _onSync(context, ref),
            tooltip: syncState.isSyncing ? 'Syncing...' : 'Sync now',
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('${RoutePaths.repositories}/add'),
            tooltip: 'Add repository',
          ),
        ],
      ),
      body: reposAsync.when(
        loading: () => SkeletonList(
          itemCount: 3,
          itemBuilder: (_, __) => const SkeletonRepositoryCard(),
        ),
        error: (error, stack) => ErrorDisplay(
          message: 'Failed to load repositories:\n$error',
          onRetry: () => ref.invalidate(repositoriesProvider),
        ),
        data: (repos) {
          if (repos.isEmpty) {
            return EmptyWidget(
              icon: Icons.folder_outlined,
              title: 'No repositories yet',
              subtitle: 'Add a GitHub repository to start tracking pull requests and issues.',
              actionLabel: 'Add Repository',
              onAction: () => context.push('${RoutePaths.repositories}/add'),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(syncProvider.notifier).sync();
            },
            child: Column(
              children: [
                // Last synced indicator
                if (syncState.lastSyncedAt != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: Text(
                      'Last synced ${timeago.format(syncState.lastSyncedAt!)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: repos.length,
                    itemBuilder: (context, index) {
                      final repo = repos[index];
                      return Dismissible(
                        key: Key('repo-${repo.id}'),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: AppTheme.errorColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        confirmDismiss: (direction) async {
                          return await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Remove Repository'),
                              content: Text(
                                'Are you sure you want to remove ${repo.owner}/${repo.repo}? All tracked PRs, issues, and notifications will be deleted.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppTheme.errorColor,
                                  ),
                                  child: const Text('Remove'),
                                ),
                              ],
                            ),
                          );
                        },
                        onDismissed: (direction) async {
                          try {
                            await ref.read(deleteRepositoryProvider)(repo.id!);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Removed ${repo.owner}/${repo.repo}'),
                                ),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to remove: $e'),
                                  backgroundColor: AppTheme.errorColor,
                                ),
                              );
                            }
                          }
                        },
                        child: _RepositoryCard(repo: repo),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _onSync(BuildContext context, WidgetRef ref) async {
    await ref.read(syncProvider.notifier).sync();

    final syncState = ref.read(syncProvider);
    if (context.mounted) {
      if (syncState.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sync failed: ${syncState.error}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sync completed!')),
        );
      }
    }
  }
}

class _RepositoryCard extends ConsumerWidget {
  final Repository repo;

  const _RepositoryCard({required this.repo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
          child: Icon(
            repo.isPrivate ? Icons.lock : Icons.public,
            color: AppTheme.primaryColor,
          ),
        ),
        title: Text(
          '${repo.owner}/${repo.repo}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            children: [
              _buildChip(
                icon: repo.inAppNotifications ? Icons.notifications_active : Icons.notifications_off,
                label: 'In-app',
                isActive: repo.inAppNotifications,
              ),
              const SizedBox(width: 8),
              _buildChip(
                icon: repo.pushNotifications ? Icons.phone_android : Icons.phone_android_outlined,
                label: 'Push',
                isActive: repo.pushNotifications,
              ),
            ],
          ),
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handleMenuAction(context, ref, value),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'settings',
              child: ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: ListTile(
                leading: Icon(Icons.delete, color: AppTheme.errorColor),
                title: Text('Remove', style: TextStyle(color: AppTheme.errorColor)),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip({
    required IconData icon,
    required String label,
    required bool isActive,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? AppTheme.accentColor.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: isActive ? AppTheme.accentColor : Colors.grey,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? AppTheme.accentColor : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleMenuAction(BuildContext context, WidgetRef ref, String action) async {
    switch (action) {
      case 'settings':
        // TODO: Show notification settings dialog
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notification settings coming soon')),
        );
        break;
      case 'delete':
        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Remove Repository'),
            content: Text('Are you sure you want to remove ${repo.owner}/${repo.repo}? All tracked PRs, issues, and notifications will be deleted.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: AppTheme.errorColor),
                child: const Text('Remove'),
              ),
            ],
          ),
        );

        if (confirm == true && context.mounted) {
          try {
            await ref.read(deleteRepositoryProvider)(repo.id!);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Removed ${repo.owner}/${repo.repo}')),
              );
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to remove: $e'),
                  backgroundColor: AppTheme.errorColor,
                ),
              );
            }
          }
        }
        break;
    }
  }
}
