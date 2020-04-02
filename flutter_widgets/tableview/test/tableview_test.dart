import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tableview/tableview.dart';

void main() {
//  test('adds one to input values', () {
//
//  });
  testWidgets('table', (WidgetTester tester) async {
    await tester.pumpWidget(TableView(
      sectionNumber: 3,
      numberRowOfSection: (BuildContext context, int index) {
        return 1;
      },
      rowView: (BuildContext context, int section, int row) {
        return Text('aaa');
      },
    ));
  });
}
