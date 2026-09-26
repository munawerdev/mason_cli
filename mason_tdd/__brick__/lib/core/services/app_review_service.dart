// import 'dart:io';

// import 'package:in_app_review/in_app_review.dart';

// import 'app_update_service.dart';

// class AppReviewService {
//   static final AppReviewService _instance = AppReviewService._internal();
//   factory AppReviewService() => _instance;
//   AppReviewService._internal();

//   final InAppReview _inAppReview = InAppReview.instance;

//   /// Shows the native in-app review prompt if the platform allows it.
//   /// Note: the OS rate-limits this — it may silently not appear, so call it
//   /// at a meaningful moment (e.g. after a completed order), not on startup.
//   Future<void> requestReview() async {
//     try {
//       if (await _inAppReview.isAvailable()) {
//         await _inAppReview.requestReview();
//       } else {
//         await openStoreListing();
//       }
//     } catch (e) {
//       // Review prompt is best-effort; never crash the app for it.
//     }
//   }

//   /// Opens the store page directly (e.g. from a "Rate us" button in settings).
//   Future<void> openStoreListing() async {
//     try {
//       await _inAppReview.openStoreListing(
//         appStoreId: Platform.isIOS ? AppUpdateService.appStoreId : null,
//       );
//     } catch (e) {
//       // Ignore — fall back silently.
//     }
//   }
// }
