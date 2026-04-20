// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:dohamaid/core/data/datasources/storage_local_data_source.dart';
import 'package:dohamaid/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for tests

  // Initialize StorageLocalDataSource for test
  await StorageLocalDataSource.init();
  final storage = StorageLocalDataSource.instance;

  testWidgets('App renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(storage: storage));

    // add your tests here
    expect(find.text('ElRayan Shopping'), findsOneWidget);
  });
}
