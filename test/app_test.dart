import 'package:codementor_ai/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('shows the home dashboard', (tester) async {
    await tester.pumpWidget(const CodeMentorApp());
    await tester.pumpAndSettle();

    expect(find.text('CodeMentor AI'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
  });

  testWidgets('profile sheet actions are reachable', (tester) async {
    await tester.pumpWidget(const CodeMentorApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.person_rounded));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.save_rounded), findsOneWidget);
    expect(find.byIcon(Icons.restart_alt_rounded), findsWidgets);

    await tester.tap(find.byIcon(Icons.save_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsOneWidget);
  });
}
