import 'package:flutter_test/flutter_test.dart';

import 'package:crunches_cafe/main.dart';

void main() {
  testWidgets('App launches and shows the splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const CrunchesCafeApp());

    expect(find.text('FAST FOOD · FAISALABAD'), findsOneWidget);

    // Flush the splash screen's navigation timer so it doesn't leak past the test.
    await tester.pump(const Duration(milliseconds: 1500));
  });
}
