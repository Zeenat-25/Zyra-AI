import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zyra/app.dart';

void main() {
  group('Zyra App', () {
    testWidgets('App renders splash screen', (tester) async {
      await tester.pumpWidget(const ZyraApp());
      await tester.pump();

      expect(find.text('Zyra'), findsOneWidget);
    });
  });
}
