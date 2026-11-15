import 'package:flutter_test/flutter_test.dart';

import 'package:kavo/main.dart';

void main() {
  testWidgets('App launches and shows the splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const KavoApp());

    expect(find.text('COFFEE BRINGS ENERGY'), findsOneWidget);

    // Flush the splash screen's navigation timer so it doesn't leak past the test.
    await tester.pump(const Duration(milliseconds: 1500));

    // google_fonts finishes loading asynchronously and schedules a relayout
    // frame; let it land before the tree is torn down.
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 100)));
    await tester.pump();
  });
}
