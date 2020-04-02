import 'package:flutter_test/flutter_test.dart';

import 'package:round_checkbox/round_checkbox.dart';

void main() {
  testWidgets('check', (WidgetTester tester) async {
    await tester.pumpWidget(RoundCheckBox(value: true));
  });
}
