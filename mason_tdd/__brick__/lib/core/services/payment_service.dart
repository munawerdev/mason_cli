// import 'package:material_ui/material_ui.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';

// class PaymentService {
//   Future<PaymentMethod> createPaymentMethod({
//     required CardFormEditController cardFormEditController,
//   }) async {
//     try {
//       // Check if the card form is complete
//       if (!cardFormEditController.details.complete) {
//         throw Exception('Card details are not complete');
//       }

//       // Create payment method using the card form details
//       final paymentMethod = await Stripe.instance.createPaymentMethod(
//         params: PaymentMethodParams.card(
//           paymentMethodData: PaymentMethodData(
//             billingDetails: const BillingDetails(),
//           ),
//         ),
//       );

//       return paymentMethod;
//     } catch (e) {
//       throw Exception('Failed to create payment method: $e');
//     }
//   }

//   // Alternative method for manual card details (not recommended for production)
//   Future<PaymentMethod> createPaymentMethodWithCardDetails({
//     required String cardNumber,
//     required String expMonth,
//     required String expYear,
//     required String cvc,
//   }) async {
//     try {
//       // This approach requires backend integration
//       // The card details should be sent to your backend first
//       // Then the backend creates the payment method with Stripe
//       throw UnimplementedError(
//           'Manual card input is not supported by Stripe Flutter SDK. '
//           'Use CardFormField for secure card input.');
//     } catch (e) {
//       throw Exception('Failed to create payment method: $e');
//     }
//   }

//   Future<void> confirmPayment({
//     required String clientSecret,
//     required PaymentMethod paymentMethod,
//   }) async {
//     try {
//       // Confirm the payment with the payment method
//       await Stripe.instance.confirmPayment(
//         paymentIntentClientSecret: clientSecret,
//         data: PaymentMethodParams.card(
//           paymentMethodData: PaymentMethodData(
//             billingDetails: const BillingDetails(),
//           ),
//         ),
//       );
//     } catch (e) {
//       throw Exception('Failed to confirm payment: $e');
//     }
//   }

//   Future<void> handlePaymentSheet({
//     required String paymentIntentClientSecret,
//     required String customerEphemeralKeySecret,
//     required String customerId,
//   }) async {
//     try {
//       // Initialize payment sheet
//       await Stripe.instance.initPaymentSheet(
//         paymentSheetParameters: SetupPaymentSheetParameters(
//           paymentIntentClientSecret: paymentIntentClientSecret,
//           merchantDisplayName: 'cotchciti',
//           customerId: customerId,
//           customerEphemeralKeySecret: customerEphemeralKeySecret,
//           style: ThemeMode.dark,
//         ),
//       );

//       // Present payment sheet
//       await Stripe.instance.presentPaymentSheet();
//     } catch (e) {
//       throw Exception('Failed to handle payment sheet: $e');
//     }
//   }
// }
