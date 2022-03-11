// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:bt_football_team/data_manager.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {});

  test('Extract date range to query', () async {
    final dateRange = DataManager().getDateRange(30);
    expect(dateRange, {"dateFrom": "2022-02-09", "dateTo": "2022-03-11"});
  });
}
