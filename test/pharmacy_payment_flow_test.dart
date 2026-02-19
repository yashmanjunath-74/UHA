import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_health_alliance/features/pharmacy/dashboard/pharmacy_order_queue.dart';
import 'package:unified_health_alliance/features/pharmacy/fulfillment/pharmacy_order_fulfillment.dart';
import 'package:unified_health_alliance/features/common/payment/booking_payment_confirm.dart';
import 'package:unified_health_alliance/features/pharmacy/finance/pharmacy_earnings.dart';

void main() {
  // Helper to pump widgets with Riverpod
  Widget createWidgetUnderTest(Widget child) {
    return ProviderScope(
      child: MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(size: Size(400, 800)),
          child: child,
        ),
        routes: {
          '/pharmacy/fulfillment': (context) =>
              const PharmacyOrderFulfillment(),
        },
      ),
    );
  }

  group('Pharmacy and Payment Flow Tests', () {
    testWidgets('1. Pharmacy Order Queue renders and filters work', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createWidgetUnderTest(const PharmacyOrderQueue()),
      );

      expect(find.text('Prescription Queue'), findsOneWidget);
      expect(find.text('New'), findsOneWidget);

      await tester.tap(find.text('New'));
      await tester.pumpAndSettle();
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('2. Pharmacy Fulfillment Flow completes correctly', (
      WidgetTester tester,
    ) async {
      // Directly pump the fulfillment widget — no route navigation needed
      await tester.pumpWidget(
        createWidgetUnderTest(const PharmacyOrderFulfillment()),
      );
      await tester.pumpAndSettle();

      // Verify we are on fulfillment screen
      expect(find.text('Fulfillment Checklist'), findsOneWidget);

      // Verify "Mark as Ready" is initially disabled
      expect(
        tester
            .widget<ElevatedButton>(
              find.widgetWithText(ElevatedButton, 'Mark as Ready'),
            )
            .onPressed,
        isNull,
        reason: 'Button should be disabled until all steps complete',
      );

      // Complete Steps
      await tester.tap(find.text('Verify Prescription'));
      await tester.pump();
      await tester.tap(find.text('Check Expiry & Stock'));
      await tester.pump();
      await tester.tap(find.text('Pack & Label'));
      await tester.pump();

      // Verify button is now enabled
      expect(
        tester
            .widget<ElevatedButton>(
              find.widgetWithText(ElevatedButton, 'Mark as Ready'),
            )
            .onPressed,
        isNotNull,
        reason: 'Button should be enabled after all steps complete',
      );

      // Verify all checkboxes checked
      expect(
        tester
            .widget<CheckboxListTile>(
              find.widgetWithText(CheckboxListTile, 'Verify Prescription'),
            )
            .value,
        isTrue,
      );
    });

    testWidgets('3. Booking Payment Confirm processes payment', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createWidgetUnderTest(const BookingPaymentConfirm()),
      );
      await tester.pumpAndSettle(); // Settle local icons

      // Verify Total
      expect(find.text('₹800.00'), findsOneWidget);

      // Select Payment
      final upiFinder = find.text('UPI');
      await tester.scrollUntilVisible(upiFinder, 100);
      await tester.tap(upiFinder);
      await tester.pump();

      // Pay
      final payButton = find.widgetWithText(
        ElevatedButton,
        'Confirm & Pay ₹800',
      );
      await tester.scrollUntilVisible(payButton, 100);
      await tester.tap(payButton);

      // Wait for dialog animation
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Verify Success
      expect(find.text('Payment Successful!'), findsOneWidget);
    });

    testWidgets('4. Pharmacy Earnings renders charts and KPIs', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest(const PharmacyEarnings()));

      expect(find.text('Total Earnings'), findsOneWidget);
      expect(find.text('Revenue Trends'), findsOneWidget);
    });
  });
}
