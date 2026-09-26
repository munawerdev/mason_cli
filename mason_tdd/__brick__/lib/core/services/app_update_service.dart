// import 'dart:io';

// import 'package:in_app_update/in_app_update.dart';
// import 'package:material_ui/material_ui.dart';
// import 'package:url_launcher/url_launcher.dart';

// import 'app_version_service.dart';

// class AppUpdateService {
//   static final AppUpdateService _instance = AppUpdateService._internal();
//   factory AppUpdateService() => _instance;
//   AppUpdateService._internal();

//   /// Set your App Store id here for iOS update redirects, e.g. "1234567890".
//   static const String appStoreId = '';

//   /// Checks the Play Store for an available update (Android only).
//   /// Returns null on iOS or if the check fails.
//   Future<AppUpdateInfo?> checkForUpdate() async {
//     if (!Platform.isAndroid) return null;
//     try {
//       return await InAppUpdate.checkForUpdate();
//     } catch (e) {
//       return null;
//     }
//   }

//   /// Performs an immediate (blocking) in-app update on Android.
//   /// On iOS, opens the App Store page instead.
//   Future<void> performImmediateUpdate() async {
//     if (Platform.isAndroid) {
//       final info = await checkForUpdate();
//       if (info?.updateAvailability == UpdateAvailability.updateAvailable &&
//           (info?.immediateUpdateAllowed ?? false)) {
//         await InAppUpdate.performImmediateUpdate();
//       }
//     } else if (Platform.isIOS) {
//       await openStorePage();
//     }
//   }

//   /// Starts a flexible (background) update on Android, then completes it.
//   Future<void> performFlexibleUpdate() async {
//     if (!Platform.isAndroid) return;
//     final info = await checkForUpdate();
//     if (info?.updateAvailability == UpdateAvailability.updateAvailable &&
//         (info?.flexibleUpdateAllowed ?? false)) {
//       final result = await InAppUpdate.startFlexibleUpdate();
//       if (result == AppUpdateResult.success) {
//         await InAppUpdate.completeFlexibleUpdate();
//       }
//     }
//   }

//   /// Opens the app's store listing (Play Store / App Store).
//   Future<void> openStorePage() async {
//     final packageName = AppVersionService().packageName;
//     final Uri uri;
//     if (Platform.isAndroid) {
//       uri = Uri.parse(
//         'https://play.google.com/store/apps/details?id=$packageName',
//       );
//     } else if (Platform.isIOS) {
//       uri = Uri.parse('https://apps.apple.com/app/id$appStoreId');
//     } else {
//       return;
//     }
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     }
//   }

//   /// Shows a simple update dialog. Pass [force] to make it non-dismissible
//   /// (e.g. when the API says the current version is below the minimum).
//   Future<void> showUpdateDialog(
//     BuildContext context, {
//     bool force = false,
//     String title = 'Update Available',
//     String message =
//         'A new version of the app is available. Please update '
//         'to continue enjoying the latest features.',
//   }) {
//     return showDialog(
//       context: context,
//       barrierDismissible: !force,
//       builder: (context) => PopScope(
//         canPop: !force,
//         child: AlertDialog(
//           title: Text(title),
//           content: Text(message),
//           actions: [
//             if (!force)
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(),
//                 child: const Text('Later'),
//               ),
//             ElevatedButton(
//               onPressed: openStorePage,
//               child: const Text('Update Now'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
