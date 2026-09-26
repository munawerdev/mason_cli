import 'dart:io';

import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final progress = context.logger.progress('🚀 Setting up Flutter TDD project');

  // Display detected versions
  final flutterVersion = context.vars['flutter_version'] ?? 'Unknown';
  final dartVersion = context.vars['dart_version'] ?? 'Unknown';
  final javaVersion = context.vars['java_version'] ?? 'Unknown';

  context.logger.info(
      '📋 Flutter: $flutterVersion | Dart: $dartVersion | Java: $javaVersion');

  // Check if pubspec.yaml exists
  final pubspec = File('pubspec.yaml');
  if (!pubspec.existsSync()) {
    context.logger.err(
        '❌ pubspec.yaml not found. Please run this brick in a Flutter project directory.');
    return;
  }

  final lines = pubspec.readAsLinesSync();

  // Runs an external command, returning whether it succeeded.
  Future<bool> _runCommand(
    String exe,
    List<String> args, {
    String? onError,
  }) async {
    final result = await Process.run(exe, args, runInShell: true);
    if (result.exitCode != 0 && onError != null) {
      context.logger.warn('$onError: ${result.stderr}');
    }
    return result.exitCode == 0;
  }

  // Adds a batch of missing packages (prod or dev).
  Future<void> _addPackages(
    List<String> packages, {
    bool dev = false,
  }) async {
    if (packages.isEmpty) return;
    final args = ['pub', 'add', if (dev) '--dev', ...packages];
    await _runCommand(
      'flutter',
      args,
      onError: '⚠️ Failed to add ${dev ? 'dev ' : ''}packages',
    );
  }

  // Function to check if a package is already declared in pubspec.yaml
  bool isPackageInPubspec(String package) {
    return lines.any((line) => line.trim().startsWith('$package:'));
  }

  final dependencies = [
    'flutter_bloc',
    'get_it',
    'flutter_screenutil',
    'dio',
    'talker_dio_logger',
    'flutter_secure_storage',
    'fpdart',
    'shimmer',
    'cached_network_image',
    // 'flutter_dotenv',
    // 'logger',
    // 'image_picker',
    // 'permission_handler',
    // 'package_info_plus',
    // 'in_app_update',
    // 'in_app_review',
    // 'url_launcher',
    'material_ui',
    'cupertino_ui'
  ];

  // final devDependencies = [
  //   'device_preview',
  // ];

  final missingDeps =
      dependencies.where((p) => !isPackageInPubspec(p)).toList();
  // final missingDevDeps =
  //     devDependencies.where((p) => !isPackageInPubspec(p)).toList();

  context.logger.info('🔧 Adding dependencies...');

  await _addPackages(missingDeps);
  // await _addPackages(missingDevDeps, dev: true);

  // Run flutter pub get once after all dependencies are added
  if (!await _runCommand('flutter', ['pub', 'get'])) {
    progress.fail('❌ Failed to install dependencies');
    return;
  }

  // Run build_runner only if the project uses it
  if (isPackageInPubspec('build_runner')) {
    await _runCommand(
      'dart',
      ['run', 'build_runner', 'build', '--delete-conflicting-outputs'],
      onError: '⚠️ build_runner failed (optional)',
    );
  }

  // Create a default .env file if it doesn't exist
  final envFile = File('.env');
  if (!envFile.existsSync()) {
    final envContent = '''# Environment Variables
# Copy this file to .env and fill in your actual values

# Base URL for your API
BASE_URL=https://example.com
''';
    envFile.writeAsStringSync(envContent);
  }

  // ---------------------------------------------------------------------------
  // ANDROID PERMISSIONS
  // ---------------------------------------------------------------------------
  // Set up Android INTERNET permission (only one enabled for now).
  // Other permissions (storage, camera, etc.) are commented out below –
  // enable them when you actually add image_picker / permission_handler.
  final androidManifestPath = 'android/app/src/main/AndroidManifest.xml';
  final androidManifest = File(androidManifestPath);

  if (androidManifest.existsSync()) {
    final manifestContent = androidManifest.readAsStringSync();

    // Check if permissions already exist
    // final hasStoragePermission =
    //     manifestContent.contains('android.permission.READ_EXTERNAL_STORAGE');
    // final hasWritePermission =
    //     manifestContent.contains('android.permission.WRITE_EXTERNAL_STORAGE');
    final hasInternetPermission =
        manifestContent.contains('android.permission.INTERNET');

    // if (!hasStoragePermission ||
    //     !hasWritePermission ||
    //     !hasInternetPermission) {
    if (!hasInternetPermission) {
      // Find the manifest tag and add permissions after it
      final lines = manifestContent.split('\n');
      final newLines = <String>[];
      bool manifestFound = false;

      for (final line in lines) {
        newLines.add(line);

        // Add permissions after the manifest tag
        if (line.trim().startsWith('<manifest') && !manifestFound) {
          manifestFound = true;

          // if (!hasStoragePermission) {
          //   newLines.add(
          //       '    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />');
          // }

          // if (!hasWritePermission) {
          //   newLines.add(
          //       '    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />');
          // }

          if (!hasInternetPermission) {
            newLines.add(
                '    <uses-permission android:name="android.permission.INTERNET" />');
          }
        }
      }

      androidManifest.writeAsStringSync(newLines.join('\n'));
    }
  }

  // ---------------------------------------------------------------------------
  // iOS PERMISSIONS  (commented out – enable when needed)
  // ---------------------------------------------------------------------------
  // Set up iOS permissions for photo library access
  //
  // final iosInfoPlistPath = 'ios/Runner/Info.plist';
  // final iosInfoPlist = File(iosInfoPlistPath);
  //
  // if (iosInfoPlist.existsSync()) {
  //   final plistContent = iosInfoPlist.readAsStringSync();
  //
  //   // Check if permissions already exist
  //   final hasPhotoLibraryUsageDescription =
  //       plistContent.contains('NSPhotoLibraryUsageDescription');
  //
  //   if (!hasPhotoLibraryUsageDescription) {
  //     // Find the dict tag and add permissions before the closing dict
  //     final lines = plistContent.split('\n');
  //     final newLines = <String>[];
  //     bool dictFound = false;
  //     int dictLevel = 0;
  //
  //     for (final line in lines) {
  //       if (line.trim().startsWith('<dict>')) {
  //         dictLevel++;
  //         if (dictLevel == 1) dictFound = true;
  //       } else if (line.trim().startsWith('</dict>')) {
  //         dictLevel--;
  //
  //         // Add permissions before the main dict closes
  //         if (dictLevel == 0 && dictFound) {
  //           if (!hasPhotoLibraryUsageDescription) {
  //             newLines.add('	<key>NSPhotoLibraryUsageDescription</key>');
  //             newLines.add(
  //                 '	<string>This app needs photo library access to select images</string>');
  //           }
  //         }
  //       }
  //       newLines.add(line);
  //     }
  //
  //     iosInfoPlist.writeAsStringSync(newLines.join('\n'));
  //   }
  // }

  // Ensure .env is included in pubspec.yaml assets
  final pubspecLines = pubspec.readAsLinesSync();
  bool hasFlutterSection = false;
  bool hasAssetsSection = false;
  bool hasEnvAsset = false;
  int flutterIndex = -1;
  int assetsIndex = -1;

  for (int i = 0; i < pubspecLines.length; i++) {
    final line = pubspecLines[i];
    if (line.trim().startsWith('flutter:')) {
      hasFlutterSection = true;
      flutterIndex = i;
    }
    if (line.trim().startsWith('assets:')) {
      hasAssetsSection = true;
      assetsIndex = i;
    }
    if (line.trim() == '- .env') {
      hasEnvAsset = true;
    }
  }

  if (!hasEnvAsset) {
    List<String> newLines = List.from(pubspecLines);
    if (hasFlutterSection) {
      if (hasAssetsSection) {
        // Insert after the last existing asset entry so order is preserved.
        int insertIndex = assetsIndex + 1;
        while (insertIndex < newLines.length &&
            (newLines[insertIndex].trim().startsWith('- ') ||
                newLines[insertIndex].trim().isEmpty)) {
          insertIndex++;
        }
        newLines.insert(insertIndex, '    - .env');
      } else {
        // Insert assets section under flutter
        newLines.insert(flutterIndex + 1, '  assets:\n    - .env');
      }
    } else {
      // No flutter section, add at end
      newLines.add('flutter:');
      newLines.add('  assets:');
      newLines.add('    - .env');
    }
    pubspec.writeAsStringSync(newLines.join('\n'));
  }

  // Display completion
  context.logger.info('🎉 Project setup complete!');
  // context.logger.info('🚀 Run: flutter run');

  progress.complete();
}
