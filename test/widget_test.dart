import 'package:flutter_test/flutter_test.dart';

import 'package:findit_campus/main.dart';

void main() {
  testWidgets('L\'accueil affiche le titre FindIt Campus', (WidgetTester tester) async {
    await tester.pumpWidget(const FindItCampusApp());
    expect(find.text('FindIt Campus'), findsOneWidget);
  });
}
