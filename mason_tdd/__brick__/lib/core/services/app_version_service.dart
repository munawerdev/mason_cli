// import 'package:package_info_plus/package_info_plus.dart';

// class AppVersionService {
//   static final AppVersionService _instance = AppVersionService._internal();
//   factory AppVersionService() => _instance;
//   AppVersionService._internal();

//   PackageInfo? _packageInfo;

//   /// Call once at app startup (e.g. in main or splash) before reading values.
//   Future<void> init() async {
//     _packageInfo ??= await PackageInfo.fromPlatform();
//   }

//   /// App name, e.g. "My App"
//   String get appName => _packageInfo?.appName ?? '';

//   /// Version string, e.g. "1.2.3"
//   String get version => _packageInfo?.version ?? '';

//   /// Build number, e.g. "21"
//   String get buildNumber => _packageInfo?.buildNumber ?? '';

//   /// Package / bundle identifier, e.g. "com.example.app"
//   String get packageName => _packageInfo?.packageName ?? '';

//   /// Full display string, e.g. "1.2.3+21"
//   String get fullVersion =>
//       buildNumber.isEmpty ? version : '$version+$buildNumber';

//   /// Compares the current version against [minVersion] (e.g. from your API).
//   /// Returns true if the current version is older and an update is required.
//   bool isUpdateRequired(String minVersion) {
//     return _compareVersions(version, minVersion) < 0;
//   }

//   int _compareVersions(String a, String b) {
//     final partsA = a.split('.').map((e) => int.tryParse(e) ?? 0).toList();
//     final partsB = b.split('.').map((e) => int.tryParse(e) ?? 0).toList();
//     final length = partsA.length > partsB.length ? partsA.length : partsB.length;
//     for (var i = 0; i < length; i++) {
//       final numA = i < partsA.length ? partsA[i] : 0;
//       final numB = i < partsB.length ? partsB[i] : 0;
//       if (numA != numB) return numA.compareTo(numB);
//     }
//     return 0;
//   }
// }
