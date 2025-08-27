import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/storage/local_storage.dart';
import 'core/providers/providers.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local storage
  await LocalStorage.init();

  runApp(
    ProviderScope(
      child: Consumer(
        builder: (context, ref, child) {
          // Initialize auth state after the widget tree is built
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(authProvider.notifier).initializeAuth();
          });

          return const KCCApp();
        },
      ),
    ),
  );
}
