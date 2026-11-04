import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novel_reader/database/app_database.dart';
import 'package:novel_reader/models/bookmark.dart';
import 'package:novel_reader/models/library_item.dart';
import 'package:novel_reader/models/reading_history.dart';
import 'package:novel_reader/providers/auth_provider.dart';
import 'package:novel_reader/providers/library_provider.dart';
import 'package:novel_reader/screens/user/wrapped_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'security_and_roles_test.dart' show FakeAuthRepository;

class _Database extends AppDatabase {
  final sessions = <String, List<ReadingSessionStat>>{};
  @override
  Future<List<ReadingSessionStat>> getReadingSessions({String? userId}) async =>
      sessions[userId ?? ''] ?? [];
  @override
  Future<List<LibraryItem>> getLibrary({String? userId}) async => [];
  @override
  Future<List<ReadingHistory>> getHistory({String? userId}) async => [];
  @override
  Future<List<QuoteItem>> getQuotes({String? userId}) async => [];
}

void main() {
  testWidgets(
    'Wrapped shows zero for a new reader and reacts to current-year, account-scoped totals',
    (tester) async {
      tester.view.physicalSize = const Size(420, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      SharedPreferences.setMockInitialValues({});
      final auth = AuthProvider(
        FakeAuthRepository(),
        await SharedPreferences.getInstance(),
      );
      final db = _Database();
      final library = LibraryProvider(db)..bindUser('');
      await library.load();
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthProvider>.value(value: auth),
            ChangeNotifierProvider<LibraryProvider>.value(value: library),
          ],
          child: const MaterialApp(home: ReadingWrappedScreen()),
        ),
      );
      await tester.pump();
      expect(find.text('0 từ đã đọc'), findsOneWidget);
      expect(find.textContaining('0 phút đọc được ghi nhận'), findsOneWidget);
      expect(find.textContaining('18450'), findsNothing);
      final year = DateTime.now().year;
      db.sessions[''] = [
        ReadingSessionStat(
          dateKey: '$year-01-01',
          wordsRead: 123,
          minutesRead: 7,
        ),
        ReadingSessionStat(
          dateKey: '${year - 1}-12-31',
          wordsRead: 999,
          minutesRead: 555,
        ),
      ];
      await library.load();
      await tester.pump();
      expect(find.text('123 từ đã đọc'), findsOneWidget);
      expect(find.textContaining('7 phút đọc được ghi nhận'), findsOneWidget);
      expect(find.text('Reading Wrapped $year'), findsOneWidget);
      library.bindUser('B');
      await library.load();
      await tester.pump();
      expect(find.text('0 từ đã đọc'), findsOneWidget);
      expect(find.text('123 từ đã đọc'), findsNothing);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      library.dispose();
      auth.dispose();
    },
  );
}
