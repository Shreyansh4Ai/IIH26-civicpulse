import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/main.dart';

void main() {
  testWidgets('App renders login selection screen', (WidgetTester tester) async {
    await tester.pumpWidget(const CivicPulseApp());

    // Verify the login selection screen renders with the portal title
    expect(find.text('Select Your Portal.'), findsOneWidget);
    expect(find.text('Citizen Portal'), findsOneWidget);
    expect(find.text('Officer Portal'), findsOneWidget);
  });
}
