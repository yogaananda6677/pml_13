import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pml_13/main.dart';

void main() {
  testWidgets('Smoke test for PML 13 initial UI', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Verify AppBar title
    expect(find.text('PML 13'), findsOneWidget);

    // Verify the 3 center buttons
    expect(find.text('Tiktok'), findsOneWidget);
    expect(find.text('Youtube'), findsOneWidget);
    expect(find.text('Send Message'), findsOneWidget);

    // Verify Bottom Navigation Items
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Lokasi'), findsOneWidget);
    expect(find.text('Shop'), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);

    // Verify Bottom Navigation Icons
    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.byIcon(Icons.location_on), findsOneWidget);
    expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);
  });
}
