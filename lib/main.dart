import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'database/app_database.dart';
import 'providers/library_provider.dart';
import 'providers/novel_provider.dart';
import 'providers/reader_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/main_shell.dart';
import 'utils/constants.dart';
import 'utils/theme.dart';

/// Điểm khởi chạy ứng dụng: cấu hình SQLite theo nền tảng,
/// nạp SharedPreferences và khởi tạo MultiProvider.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hỗ trợ chạy demo trên Web hoặc Desktop ngoài Android/iOS.
  if (kIsWeb) {
    // Dùng NoWebWorker để chạy ổn định trên mọi trình duyệt (kể cả khi cache worker cũ).
    databaseFactory = databaseFactoryFfiWebNoWebWorker;
  } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  final prefs = await SharedPreferences.getInstance();
  final db = AppDatabase.instance;
  final readerProvider = ReaderProvider(db)..init();

  runApp(
    NovelReaderApp(
      prefs: prefs,
      database: db,
      readerProvider: readerProvider,
    ),
  );
}

/// Widget gốc của ứng dụng NovelReader.
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider(prefs)),
        ChangeNotifierProvider(create: (_) => NovelProvider(database, prefs)),
        ChangeNotifierProvider(create: (_) => LibraryProvider(database)),
        ChangeNotifierProxyProvider<SettingsProvider, ReaderProvider>(
          create: (_) => readerProvider,
          update: (_, settings, reader) {
            final r = reader ?? readerProvider;
            r.forceOffline = settings.forceOffline;
            return r;
          },
        ),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) => MaterialApp(
          title: AppInfo.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: settings.themeMode,
          home: const MainShell(),
        ),
      ),
    );
  }
}
