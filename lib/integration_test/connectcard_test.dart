import 'package:connectcard/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:connectcard/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('tap on the floating action button, verify counter',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));
      tester.enterText(find.byType(TextFormField).at(0), 'zhiwei@gmail.com');
      await Future.delayed(const Duration(seconds: 2));
      tester.enterText(find.byType(TextFormField).at(1), '123123');
      await Future.delayed(const Duration(seconds: 2));
      tester.tap(find.byType(ElevatedButton));
      await Future.delayed(const Duration(seconds: 5));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));
      expect(Home(), findsWidgets);
    });
  });
}
