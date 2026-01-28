import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme.dart';
import '../../shared/widgets/loading_widget.dart';
import 'repositories_provider.dart';

/// Screen for adding a new repository.
class AddRepositoryScreen extends ConsumerStatefulWidget {
  const AddRepositoryScreen({super.key});

  @override
  ConsumerState<AddRepositoryScreen> createState() => _AddRepositoryScreenState();
}

class _AddRepositoryScreenState extends ConsumerState<AddRepositoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _repoController = TextEditingController();

  @override
  void dispose() {
    _repoController.dispose();
    super.dispose();
  }

  Future<void> _addRepository() async {
    if (!_formKey.currentState!.validate()) return;

    final input = _repoController.text.trim();
    final parts = input.split('/');

    if (parts.length != 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter in format: owner/repo'),
          backgroundColor: AppTheme.warningColor,
        ),
      );
      return;
    }

    final owner = parts[0].trim();
    final repo = parts[1].trim();

    final success = await ref.read(addRepositoryProvider.notifier).addRepository(owner, repo);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added $owner/$repo')),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final addState = ref.watch(addRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Repository'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _repoController,
                decoration: const InputDecoration(
                  labelText: 'Repository',
                  hintText: 'owner/repo (e.g., flutter/flutter)',
                  prefixIcon: Icon(Icons.folder),
                ),
                autocorrect: false,
                textCapitalization: TextCapitalization.none,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a repository';
                  }
                  if (!value.contains('/')) {
                    return 'Format: owner/repo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              if (addState.error != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.errorColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: AppTheme.errorColor),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          addState.error!,
                          style: const TextStyle(color: AppTheme.errorColor),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              ElevatedButton(
                onPressed: addState.isLoading ? null : _addRepository,
                child: addState.isLoading
                    ? const LoadingIndicator(color: Colors.white)
                    : const Text('Add Repository'),
              ),

              const SizedBox(height: 24),

              // Help text
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.grey.shade600, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Tips',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildTip('You can add up to 10 repositories'),
                      _buildTip('Guest users can only track public repositories'),
                      _buildTip('Connect with a GitHub PAT for private repos'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: TextStyle(color: Colors.grey.shade600)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }
}
