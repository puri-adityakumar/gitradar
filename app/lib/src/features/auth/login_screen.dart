import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../shared/widgets/loading_widget.dart';
import 'auth_provider.dart';

/// Login screen with anonymous and PAT options.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _patController = TextEditingController();
  bool _showPatInput = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _patController.dispose();
    super.dispose();
  }

  Future<void> _loginAnonymous() async {
    setState(() => _isLoading = true);

    try {
      await ref.read(authStateProvider.notifier).loginAnonymous();
      if (mounted) {
        context.go(RoutePaths.repositories);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loginWithPat() async {
    final pat = _patController.text.trim();
    if (pat.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your GitHub PAT'),
          backgroundColor: AppTheme.warningColor,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(authStateProvider.notifier).loginWithPat(pat);
      if (mounted) {
        context.go(RoutePaths.repositories);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),

              // Logo and title
              Icon(
                Icons.radar,
                size: 80,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(height: 16),
              Text(
                'GitRadar',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Monitor your GitHub repositories',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey.shade600,
                    ),
              ),

              const Spacer(),

              // Login options
              if (_isLoading)
                const LoadingIndicator()
              else if (_showPatInput) ...[
                TextField(
                  controller: _patController,
                  decoration: const InputDecoration(
                    labelText: 'GitHub Personal Access Token',
                    hintText: 'ghp_xxxxxxxxxxxx',
                    prefixIcon: Icon(Icons.key),
                  ),
                  obscureText: true,
                  autocorrect: false,
                  enableSuggestions: false,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loginWithPat,
                  child: const Text('Connect with PAT'),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => setState(() => _showPatInput = false),
                  child: const Text('Back'),
                ),
              ] else ...[
                ElevatedButton.icon(
                  onPressed: _loginAnonymous,
                  icon: const Icon(Icons.person_outline),
                  label: const Text('Continue as Guest'),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => setState(() => _showPatInput = true),
                  icon: const Icon(Icons.key),
                  label: const Text('Connect with GitHub PAT'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Info text
              Text(
                _showPatInput
                    ? 'A PAT allows access to private repositories and higher API limits.'
                    : 'Guest mode allows tracking public repositories with limited API calls (60/hour).',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade500,
                    ),
              ),

              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
