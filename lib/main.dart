import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'database/app_database.dart';
import 'providers/admin_dashboard_provider.dart';
import 'providers/admin_novel_provider.dart';
import 'providers/admin_user_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/library_provider.dart';
import 'providers/moderation_provider.dart';
import 'providers/novel_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/quest_provider.dart';
import 'providers/reader_provider.dart';
import 'providers/settings_provider.dart';
import 'repositories/auth_repository.dart';
import 'repositories/novel_repository.dart';
import 'repositories/supabase_auth_repository.dart';
import 'repositories/supabase_novel_repository.dart';
import 'screens/auth/splash_gate.dart';
import 'screens/config_error_screen.dart';
import 'utils/constants.dart';
import 'utils/theme.dart';
import 'utils/app_route_observer.dart';

/// Điểm khởi chạy ứng dụng NovelReader: kết nối Cloud Supabase làm Database chính.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hỗ trợ SUPABASE_* và NEXT_PUBLIC_SUPABASE_* khi build bằng dart-define.
  if (SupabaseConfig.isMissing) {
    runApp(
      const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ConfigErrorScreen(),
      ),
    );
    return;
  }

  // 1. Khởi tạo Supabase Cloud
  try {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      anonKey: SupabaseConfig.anonKey, // ignore: deprecated_member_use
    );
  } catch (e) {
    debugPrint('Supabase init error: $e');
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ConfigErrorScreen(message: 'Không thể khởi tạo Supabase.\n\n$e'),
      ),
    );
    return;
  }

  // Hỗ trợ SQLite fallback khi offline
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWebNoWebWorker;
  } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  final prefs = await SharedPreferences.getInstance();
  final db = AppDatabase.instance;
  final readerProvider = ReaderProvider(db)..init();

  runApp(
    NovelReaderApp(prefs: prefs, database: db, readerProvider: readerProvider),
  );
}

/// Widget gốc của ứng dụng NovelReader v2.
class NovelReaderApp extends StatelessWidget {
  final SharedPreferences prefs;
  final AppDatabase database;
  final ReaderProvider readerProvider;

  const NovelReaderApp({
    super.key,
    required this.prefs,
    required this.database,
    required this.readerProvider,
  });

  @override
  Widget build(BuildContext context) {
    // Sử dụng Repositories kết nối Supabase Cloud
    final AuthRepository authRepo = SupabaseAuthRepository();
    final NovelRepository novelRepo = SupabaseNovelRepository();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider(prefs)),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authRepo, prefs)..restoreSession(),
        ),
        ChangeNotifierProvider(create: (_) => NovelProvider(database, prefs)),
        ChangeNotifierProxyProvider<SettingsProvider, ReaderProvider>(
          create: (_) => readerProvider,
          update: (_, settings, reader) {
            final r = reader ?? readerProvider;
            r.forceOffline = settings.forceOffline;
            return r;
          },
        ),
        ChangeNotifierProxyProvider2<
          AuthProvider,
          ReaderProvider,
          LibraryProvider
        >(
          create: (_) => LibraryProvider(database),
          update: (_, auth, reader, library) => library!
            ..bindUser(auth.isGuest ? '' : auth.currentUser.id)
            ..updateConnectivity(reader.isOnline),
        ),
        ChangeNotifierProxyProvider<AuthProvider, QuestProvider>(
          create: (_) => QuestProvider(database),
          update: (_, auth, quests) =>
              quests!..bindUser(auth.isGuest ? '' : auth.currentUser.id),
        ),
        ChangeNotifierProvider(create: (_) => NotificationProvider(database)),
        ChangeNotifierProvider(create: (_) => AdminDashboardProvider(database)),
        ChangeNotifierProvider(
          create: (_) => AdminNovelProvider(database, novelRepo),
        ),
        ChangeNotifierProvider(
          create: (_) => AdminUserProvider(database, authRepo),
        ),
        ChangeNotifierProvider(
          create: (_) => ModerationProvider(database)..loadAll(),
        ),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) => MaterialApp(
          title: AppInfo.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: settings.themeMode,
          home: const SplashGate(),
          navigatorObservers: [appRouteObserver],
        ),
      ),
    );
  }
}
