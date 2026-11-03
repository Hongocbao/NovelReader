import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novel_reader/models/chapter.dart';
import 'package:novel_reader/models/reader_settings.dart';
import 'package:novel_reader/utils/theme.dart';
import 'package:novel_reader/widgets/reader/xray_and_quote_sheets.dart';
import 'package:novel_reader/widgets/smart_novel_importer_sheet.dart';

/// Blob-only files exercise the same picker contract as a browser upload.
/// Accessing a local path/XFile or reading the entire file bypassing the stream
/// fails the test, so the importer cannot accidentally fall back to dart:io.
final class _PickedBlob extends PlatformFile {
  _PickedBlob(
    this.name,
    List<int> bytes, {
    this.reportedLength,
    this.beforeRead,
  }) : _bytes = Uint8List.fromList(bytes);

  @override
  final String name;
  final Uint8List _bytes;
  final int? reportedLength;
  final Future<void>? beforeRead;

  @override
  Uri get uri => Uri.parse('blob:test/$name');
  @override
  Never get xFile => throw UnsupportedError('No local file for browser upload');
  @override
  int? lengthSync() => reportedLength;
  @override
  Future<int?> length() async => reportedLength;
  @override
  Future<Uint8List> readAsBytes() =>
      throw UnsupportedError('Read the bounded byte stream');
  @override
  Stream<Uint8List> readAsByteStream() async* {
    if (beforeRead != null) await beforeRead;
    final middle = _bytes.length ~/ 2;
    yield Uint8List.sublistView(_bytes, 0, middle);
    yield Uint8List.sublistView(_bytes, middle);
  }
}

class _Picker extends FilePickerPlatform {
  _Picker(this.files);

  final List<PlatformFile> files;
  List<String>? extensions;

  @override
  Future<List<PlatformFile>> pickFiles({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    Function(FilePickerStatus)? onFileLoading,
    int compressionQuality = 0,
    AndroidOptions androidOptions = const AndroidOptions(),
    DarwinOptions darwinOptions = const DarwinOptions(),
    WindowsOptions windowsOptions = const WindowsOptions(),
    LinuxOptions linuxOptions = const LinuxOptions(),
    WebOptions webOptions = const WebOptions(),
  }) async {
    extensions = allowedExtensions;
    return files;
  }
}

List<int> _zip(List<String> paths) {
  final archive = Archive();
  for (final path in paths) {
    final data = utf8.encode('page: $path');
    archive.addFile(ArchiveFile(path, data.length, data));
  }
  return ZipEncoder().encode(archive);
}

Future<void> _openImporter(WidgetTester tester) async {
  tester.view.physicalSize = const Size(800, 1200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    const MaterialApp(home: Scaffold(body: SmartNovelImporterSheet())),
  );
}

void main() {
  late FilePickerPlatform previousPicker;
  setUp(() => previousPicker = FilePickerPlatform.instance);
  tearDown(() => FilePickerPlatform.instance = previousPicker);

  testWidgets('Importer fits a 360px phone in TXT and Manga modes', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(body: SmartNovelImporterSheet()),
      ),
    );
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Truyện Tranh (Manga)'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('Manga horizontal reader turns one embedded image at a time', (
    tester,
  ) async {
    const page =
        '[img]data:image/png;base64,'
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+aUioAAAAASUVORK5CYII=[/img]';
    final controller = PageController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ReaderHorizontalPager(
            chapter: const Chapter(
              id: -1,
              novelId: -1,
              chapterIndex: 1,
              title: 'Manga',
            ),
            paragraphs: const [page, page, page],
            settings: const ReaderSettings(),
            controller: controller,
            speakingParagraphIndex: -1,
            isListening: false,
            searchKeyword: '',
            onPageChanged: (_) {},
            onLongPressQuote: (_) {},
            onTapImage: (_) {},
            footer: const SizedBox.shrink(),
            comicMode: true,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Trang 1/3'), findsOneWidget);
    await tester.drag(find.byType(PageView), const Offset(-500, 0));
    await tester.pumpAndSettle();
    expect(controller.page, closeTo(1, 0.01));
    expect(find.text('Trang 2/3'), findsOneWidget);
    expect(find.byIcon(Icons.broken_image_outlined), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'TXT upload reads blob bytes, fills metadata and splits chapters',
    (tester) async {
      final picker = _Picker([
        _PickedBlob(
          'truyen.txt',
          utf8.encode('''Tên truyện: Hành trình
Tác giả: Nguyễn An
Chương 1: Bắt đầu
Nội dung chương đầu.
Chương 2: Trở lại
Nội dung chương sau.
'''),
        ),
      ]);
      FilePickerPlatform.instance = picker;
      await _openImporter(tester);
      final button = find.text('Chọn file .txt (có thể chọn nhiều chương)');
      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pumpAndSettle();

      expect(picker.extensions, ['txt']);
      final fields = tester
          .widgetList<TextField>(find.byType(TextField))
          .toList();
      expect(fields[0].controller!.text, 'Hành trình');
      expect(fields[1].controller!.text, 'Nguyễn An');
      expect(find.textContaining('thành công 2 chương'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Cannot switch import type while uploaded bytes are being read', (
    tester,
  ) async {
    final ready = Completer<void>();
    addTearDown(() {
      if (!ready.isCompleted) ready.complete();
    });
    FilePickerPlatform.instance = _Picker([
      _PickedBlob(
        'truyen.txt',
        utf8.encode('Chương 1\nNội dung.'),
        beforeRead: ready.future,
      ),
    ]);
    await _openImporter(tester);
    final button = find.text('Chọn file .txt (có thể chọn nhiều chương)');
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();
    expect(
      tester
          .widget<SegmentedButton<int>>(find.byType(SegmentedButton<int>))
          .onSelectionChanged,
      isNull,
    );
    ready.complete();
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<SegmentedButton<int>>(find.byType(SegmentedButton<int>))
          .onSelectionChanged,
      isNotNull,
    );
    expect(find.textContaining('thành công 1 chương'), findsOneWidget);
  });

  testWidgets('ZIP and CBZ uploads sort chapters and ignore hidden Mac files', (
    tester,
  ) async {
    final picker = _Picker([
      _PickedBlob('Chapter 10.cbz', _zip(['001.jpg'])),
      _PickedBlob(
        'Chapter 2.zip',
        _zip([
          'Novel/Chapter 2/010.jpg',
          'Novel/Chapter 2/002.jpg',
          'Novel/__MACOSX/Chapter 2/._002.jpg',
          'Novel/.thumbs/001.jpg',
        ]),
      ),
    ]);
    FilePickerPlatform.instance = picker;
    await _openImporter(tester);
    await tester.tap(find.text('Truyện Tranh (Manga)'));
    await tester.pumpAndSettle();
    final button = find.text(
      'Chọn ZIP/CBZ truyện tranh (chọn được nhiều file)',
    );
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(picker.extensions, ['zip', 'cbz']);
    final result = find.textContaining('Đã nhận 2 chương, 3 trang ảnh');
    await tester.ensureVisible(result);
    await tester.pumpAndSettle();
    expect(result, findsOneWidget);
    final titles = tester
        .widgetList<ListTile>(find.byType(ListTile))
        .where((tile) => tile.leading is Text)
        .map((tile) => (tile.title! as Text).data)
        .toList();
    expect(titles, ['Chapter 2', 'Chapter 10']);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Incomplete archive bytes show an import error without crashing',
    (tester) async {
      final picker = _Picker([
        _PickedBlob('broken.zip', [1, 2, 3], reportedLength: 100),
      ]);
      FilePickerPlatform.instance = picker;
      await _openImporter(tester);
      await tester.tap(find.text('Truyện Tranh (Manga)'));
      await tester.pumpAndSettle();
      final button = find.text(
        'Chọn ZIP/CBZ truyện tranh (chọn được nhiều file)',
      );
      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pumpAndSettle();

      final error = find.textContaining('Không đọc đủ dữ liệu của broken.zip');
      await tester.ensureVisible(error);
      await tester.pumpAndSettle();
      expect(error, findsOneWidget);
      expect(
        find.textContaining('Danh sách chương đã chuẩn bị nạp'),
        findsNothing,
      );
      expect(tester.takeException(), isNull);
    },
  );
}
