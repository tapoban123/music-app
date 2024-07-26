import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/theme/theme.dart';
import 'package:client/features/auth/view/pages/login_page.dart';
import 'package:client/features/auth/view_model/auth_view_model.dart';
import 'package:client/features/home/view/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  /// Called whenever we run some code before the runApp() function.
  WidgetsFlutterBinding
      .ensureInitialized();     

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  /// Setting up Hive Storage
  final dir = await getApplicationDocumentsDirectory();
  Hive.defaultDirectory = dir.path;

  /// Using `ProviderContainer` to use ref in main function
  final container = ProviderContainer();

  final notifier = container.read(authViewModelProvider.notifier);

  /// Initialise `SharedPreferences`
  await notifier.initSharedPreferences();

  /// Fetch current UserAuthData
  await notifier.getAuthData();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserNotifierProvider);

    return MaterialApp(
      title: 'Music App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkThemeMode,
      home: currentUser == null ? const LoginPage() : const HomePage(),
      // home: SignUpPage(),
    );
  }
}
