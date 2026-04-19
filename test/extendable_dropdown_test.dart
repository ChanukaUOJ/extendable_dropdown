import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:extendable_dropdown/extendable_dropdown.dart';

void main() {
  group('ExtendableDropdown Widget Tests', () {
    final List<String> testItems = ['Apple', 'Banana', 'Cherry'];

    testWidgets('Initial state shows one dropdown with hint', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ExtendableDropdown<String>(
            list: testItems,
            onSendListChanged: (_) {},
          ),
        ),
      ));

      expect(find.text('Select an item'), findsOneWidget);
      expect(find.text('Add New Dropdown'), findsOneWidget);
    });

    testWidgets('Selecting an item triggers callback and updates UI', (WidgetTester tester) async {
      List<String> selectedResult = [];
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ExtendableDropdown<String>(
            list: testItems,
            onSendListChanged: (list) => selectedResult = list,
          ),
        ),
      ));

      // Open dropdown
      await tester.tap(find.text('Select an item'));
      await tester.pumpAndSettle();

      // Select 'Banana'
      await tester.tap(find.text('Banana').last);
      await tester.pumpAndSettle();

      expect(selectedResult, equals(['Banana']));
      expect(find.text('Banana'), findsOneWidget);
    });

    testWidgets('Adding a new slot works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ExtendableDropdown<String>(
            list: testItems,
            onSendListChanged: (_) {},
          ),
        ),
      ));

      // Try to add a slot without selecting first (should show snackbar, but we test UI doesn't change)
      await tester.tap(find.text('Add New Dropdown'));
      await tester.pumpAndSettle();
      expect(find.text('Select an item'), findsOneWidget);

      // Select an item first
      await tester.tap(find.text('Select an item'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Apple').last);
      await tester.pumpAndSettle();

      // Now add a slot
      await tester.tap(find.text('Add New Dropdown'));
      await tester.pumpAndSettle();

      // Should now have 'Apple' (selected) and 'Select an item' (new slot)
      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('Select an item'), findsOneWidget);
    });

    testWidgets('Dismissing a slot removes it and returns item to available pool', (WidgetTester tester) async {
      List<String> selectedResult = [];
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ExtendableDropdown<String>(
            list: testItems,
            onSendListChanged: (list) => selectedResult = list,
          ),
        ),
      ));

      // Select 'Cherry'
      await tester.tap(find.text('Select an item'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cherry').last);
      await tester.pumpAndSettle();

      expect(selectedResult, equals(['Cherry']));

      // Add a second slot
      await tester.tap(find.text('Add New Dropdown'));
      await tester.pumpAndSettle();

      // Select 'Banana' in the second slot
      await tester.tap(find.text('Select an item'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Banana').last);
      await tester.pumpAndSettle();

      expect(selectedResult, containsAll(['Cherry', 'Banana']));

      // Dismiss the first slot (Cherry)
      // Note: Real dismissal requires dragging, but we can simulate the logic or use a helper
      // For widget tests, we usually use tester.drag
      await tester.drag(find.text('Cherry'), const Offset(-500, 0));
      await tester.pumpAndSettle();

      expect(selectedResult, equals(['Banana']));
      
      // Verify Cherry is back in available items by checking if it appears in the dropdown of the current slot
      await tester.tap(find.text('Banana')); // Open the first slot (which is now Banana)
      await tester.pumpAndSettle();
      expect(find.text('Cherry'), findsWidgets); // Should appear in the dropdown list
    });

    testWidgets('Custom addButton is rendered correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ExtendableDropdown<String>(
            list: testItems,
            onSendListChanged: (_) {},
            addButton: const Text('CUSTOM_ADD_BUTTON'),
          ),
        ),
      ));

      expect(find.text('CUSTOM_ADD_BUTTON'), findsOneWidget);
      expect(find.text('Add New Dropdown'), findsNothing);
    });

    testWidgets('Custom onMessage callback is triggered', (WidgetTester tester) async {
      String receivedMessage = '';
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ExtendableDropdown<String>(
            list: testItems,
            onSendListChanged: (_) {},
            onMessage: (context, message) => receivedMessage = message,
          ),
        ),
      ));

      // Try to add a slot without selecting first (should trigger onMessage)
      await tester.tap(find.text('Add New Dropdown'));
      await tester.pumpAndSettle();

      expect(receivedMessage, equals('Fill the existing slots first!'));
    });
  });
}
