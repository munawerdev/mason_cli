import 'dart:io';

import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final progress = context.logger.progress('🧱 Setting up feature folder');

  // // Display detected versions
  // final flutterVersion = context.vars['flutter_version'] ?? 'Unknown';
  // final dartVersion = context.vars['dart_version'] ?? 'Unknown';
  // final javaVersion = context.vars['java_version'] ?? 'Unknown';

  // context.logger.info(
  //     '📋 Flutter: $flutterVersion | Dart: $dartVersion | Java: $javaVersion');

  final originalName = (context.vars['name'] as String? ?? "").trim();
  final name = originalName.pascalCase;
  final isPost = context.vars['isPost'] as bool? ?? false;
  final isGet = context.vars['isGet'] as bool? ?? false;

  context.logger.info('🎯 Generating: $name');

  void appendAtEndOfProvidersList(String content) {
    File file = File('lib/injection_container.dart');
    if (!file.existsSync()) {
      context.logger.warn(
          '⚠️  injection_container.dart not found. Skipping dependency injection setup.');
      return;
    }

    String fileContent = file.readAsStringSync();

    int runAppIndex = fileContent.indexOf('Future<void> init() async {');

    if (runAppIndex != -1) {
      int endProvidersIndex = fileContent.indexOf('}', runAppIndex);

      if (endProvidersIndex != -1) {
        String start = fileContent.substring(0, endProvidersIndex);
        String end = fileContent.substring(endProvidersIndex);

        String updatedContent = '$start$content\n$end';

        file.writeAsStringSync(updatedContent);
      } else {
        context.logger.warn('⚠️  Could not find end of init() function');
      }
    } else {
      context.logger.warn(
          '⚠️  Could not find init() function in injection_container.dart');
    }
  }

  void addImportAtTop(String importStatement, String whereToImport) {
    File file = File(whereToImport);
    if (!file.existsSync()) {
      context.logger
          .warn('⚠️  $whereToImport not found. Skipping import setup.');
      return;
    }

    String fileContent = file.readAsStringSync();

    int importBlockIndex = fileContent.indexOf('import ');

    if (importBlockIndex != -1) {
      String updatedContent = '$importStatement\n$fileContent';

      file.writeAsStringSync(updatedContent);
    } else {
      context.logger.warn('⚠️  Could not find import block in $whereToImport');
    }
  }

  String importStatement;
  importStatement = '''
/*
************************ ${name} ************************
*/
import 'features/${originalName.snakeCase}/${originalName.snakeCase}_cubit.dart';
import 'features/${originalName.snakeCase}/${originalName.snakeCase}_navigator.dart';
import 'features/${originalName.snakeCase}/${originalName.snakeCase}_initial_params.dart';
''';
  addImportAtTop(importStatement, 'lib/injection_container.dart');

  String providerStatement;
  providerStatement = '''
/*
************************ ${name} ************************
*/
  getIt.registerSingleton<${name}Navigator>(${name}Navigator(getIt()));
  getIt.registerFactoryParam<${name}Cubit, ${name}InitialParams, dynamic>(
      (params, _) => ${name}Cubit(params, getIt()
      ${isGet ? ', getIt()' : ''}
      ${isPost ? ', getIt(), getIt()' : ''}
      )
      ${isGet ? '..${originalName.camelCase}()' : ''}
      );
''';
  appendAtEndOfProvidersList(providerStatement);

  void moveFileToDirectory(String sourcePath, String destinationDirectory) {
    Directory sourceDir = Directory(sourcePath);

    if (sourceDir.existsSync()) {
      Directory destinationDir = Directory(destinationDirectory);
      if (!destinationDir.existsSync()) {
        destinationDir.createSync(recursive: true);
      }

      String sourceName = sourceDir.path.split(Platform.pathSeparator).last;
      String cleanedSourceName = sourceName;

      String destinationPath = '${destinationDir.path}/$cleanedSourceName';

      try {
        sourceDir.renameSync(destinationPath);
      } catch (e) {
        context.logger.warn('⚠️  Error moving $sourceName: $e');
      }
    } else {
      context.logger.warn('⚠️  Source folder $sourcePath does not exist');
    }
  }

  void moveFileToFile(String sourcePath, String destinationDirectory) {
    File sourceFile = File(sourcePath);

    if (sourceFile.existsSync()) {
      Directory destinationDir = Directory(destinationDirectory);
      if (!destinationDir.existsSync()) {
        destinationDir.createSync(recursive: true);
      }

      String sourceName = sourceFile.path.split(Platform.pathSeparator).last;
      String destinationPath = '${destinationDir.path}/$sourceName';

      try {
        sourceFile.renameSync(destinationPath);
      } catch (e) {
        context.logger.warn('⚠️  Error moving $sourceName: $e');
      }
    } else {
      context.logger.warn('⚠️  Source file $sourcePath does not exist');
    }
  }

  // Move feature files to their proper locations

  String sourcePath = originalName.snakeCase;
  String destinationDirectory = 'lib/features';
  moveFileToDirectory(sourcePath, destinationDirectory);

  // String sourcePath4 = '${originalName.snakeCase}_entitie';
  // String destinationDirector4 = 'lib/domain/entities';
  // moveFileToDirectory(sourcePath4, destinationDirector4);

  // String sourcePath2 = '${originalName.snakeCase}_failure';
  // String destinationDirector2 = 'lib/domain/failures';
  // moveFileToDirectory(sourcePath2, destinationDirector2);

  // String sourcePath3 = '${originalName.snakeCase}_base_api_service';
  // String destinationDirector3 = 'lib/domain/repositories';
  // moveFileToDirectory(sourcePath3, destinationDirector3);

  // String sourcePath6 = '${originalName.snakeCase}_usecase';
  // String destinationDirector6 = 'lib/domain/usecases';
  // moveFileToDirectory(sourcePath6, destinationDirector6);

  // String sourcePath5 = '${originalName.snakeCase}_repositorie';
  // String destinationDirector5 = 'lib/data/repositories';
  // moveFileToDirectory(sourcePath5, destinationDirector5);

  // String sourcePath7 = '${originalName.snakeCase}_datasource';
  // String destinationDirector7 = 'lib/data/datasources';
  // moveFileToDirectory(sourcePath7, destinationDirector7);

  String sourcePath8 = '${originalName.snakeCase}_model.dart';
  String destinationDirector8 = 'lib/data/models';
  moveFileToFile(sourcePath8, destinationDirector8);

  // Move test files
  // context.logger.info('🧪 Organizing test files...');

  // String testSource = "${originalName.snakeCase}_test";
  // String testDestinationDirectory = 'test/features';
  // moveFileToDirectory(testSource, testDestinationDirectory);

  // String testSource1 = '${originalName.snakeCase}_entitie_test';
  // String testDestinationDirectory4 = 'test/domain/entities';
  // moveFileToDirectory(testSource1, testDestinationDirectory4);

  // String testSource2 = '${originalName.snakeCase}_failure_test';
  // String testDestinationDirectory2 = 'test/domain/failures';
  // moveFileToDirectory(testSource2, testDestinationDirectory2);

  // String testSource3 = '${originalName.snakeCase}_base_api_service_test';
  // String testDestinationDirectory3 = 'test/domain/repositories';
  // moveFileToDirectory(testSource3, testDestinationDirectory3);

  // String testSource6 = '${originalName.snakeCase}_usecase_test';
  // String testDestinationDirectory6 = 'test/domain/usecases';
  // moveFileToDirectory(testSource6, testDestinationDirectory6);

  // String testSource5 = '${originalName.snakeCase}_repositorie_test';
  // String testDestinationDirectory5 = 'test/data/repositories';
  // moveFileToDirectory(testSource5, testDestinationDirectory5);

  // String testSource7 = '${originalName.snakeCase}_datasource_test';
  // String testDestinationDirectory7 = 'test/data/datasources';
  // moveFileToDirectory(testSource7, testDestinationDirectory7);

  // String testSource8 = '${originalName.snakeCase}_model_test';
  // String testDestinationDirectory8 = 'test/data/models';
  // moveFileToDirectory(testSource8, testDestinationDirectory8);

  void appUrl(String content) {
    File file = File('lib/core/utils/app_url.dart');
    if (!file.existsSync()) {
      context.logger.warn('⚠️  app_url.dart not found. Skipping URL setup.');
      return;
    }

    String fileContent = file.readAsStringSync();

    int runAppIndex = fileContent.indexOf('abstract class AppUrl {');

    if (runAppIndex != -1) {
      int endProvidersIndex = fileContent.indexOf('}', runAppIndex);

      if (endProvidersIndex != -1) {
        String start = fileContent.substring(0, endProvidersIndex);
        String end = fileContent.substring(endProvidersIndex);

        String updatedContent = '$start$content\n$end';

        file.writeAsStringSync(updatedContent);
      } else {
        context.logger.warn('⚠️  Could not find end of AppUrl class');
      }
    } else {
      context.logger.warn('⚠️  Could not find AppUrl class in app_url.dart');
    }
  }

  // Add API URLs if needed
  if (isGet || isPost) {
    String urlContent = '''
  // ${originalName.snakeCase}
  static String get ${originalName.camelCase} => '_baseUrl/${originalName.snakeCase}';
''';
    appUrl(urlContent);
  }

  // ---------------------------------------------------------------------------
  // ROUTE REGISTRATION (GoRouter)
  // ---------------------------------------------------------------------------
  // The generated `<name>_navigator.dart` navigates with
  // `navigator.go(AppRoutes.<name>, extra: initialParams)`, so the route has to
  // exist in `app_routes.dart` and a matching `GoRoute` in `app_router.dart`.

  /// Inserts [importStatement] into the import block of [filePath], keeping the
  /// project imports (the ones starting with `/`) sorted alphabetically.
  void addImportToFile(String importStatement, String filePath) {
    File file = File(filePath);
    if (!file.existsSync()) {
      context.logger.warn('⚠️  $filePath not found. Skipping import setup.');
      return;
    }

    final lines = file.readAsLinesSync();
    if (lines.any((line) => line.trim() == importStatement)) return;

    final importPattern = RegExp('^import\\s+[\'"]([^\'"]+)[\'"];');
    int? insertIndex;
    int? lastProjectImportIndex;
    int? lastImportIndex;

    for (int i = 0; i < lines.length; i++) {
      final match = importPattern.firstMatch(lines[i].trim());
      if (match == null) continue;
      lastImportIndex = i;

      // Only reorder within the project imports group so that `dart:` and
      // `package:` imports stay where they are.
      if (!(match.group(1) ?? '').startsWith('/')) continue;
      lastProjectImportIndex = i;

      if (insertIndex == null &&
          lines[i].trim().compareTo(importStatement) > 0) {
        insertIndex = i;
      }
    }

    final anchor = lastProjectImportIndex ?? lastImportIndex;
    if (anchor == null) {
      context.logger.warn('⚠️  Could not find import block in $filePath');
      return;
    }

    lines.insert(insertIndex ?? anchor + 1, importStatement);
    file.writeAsStringSync(lines.join('\n'));
  }

  /// Adds `static const String <name> = '/<name>';` to `AppRoutes`.
  void addRouteToAppRoutes() {
    const filePath = 'lib/config/navigation/app_routes.dart';
    File file = File(filePath);
    if (!file.existsSync()) {
      context.logger
          .warn('⚠️  $filePath not found. Skipping AppRoutes registration.');
      return;
    }

    final fileContent = file.readAsStringSync();
    final routeName = originalName.camelCase;

    if (fileContent.contains('static const String $routeName =')) return;

    final closingBraceIndex = fileContent.lastIndexOf('}');
    if (closingBraceIndex == -1) {
      context.logger.warn('⚠️  Could not find AppRoutes class in $filePath');
      return;
    }

    final start = fileContent.substring(0, closingBraceIndex);
    final end = fileContent.substring(closingBraceIndex);
    final entry =
        "  static const String $routeName = '/${originalName.snakeCase}';\n";

    file.writeAsStringSync('$start$entry$end');
  }

  /// Adds the `GoRoute` for the generated page to `AppRouter`.
  void addRouteToAppRouter() {
    const filePath = 'lib/config/navigation/app_router.dart';
    File file = File(filePath);
    if (!file.existsSync()) {
      context.logger
          .warn('⚠️  $filePath not found. Skipping GoRouter registration.');
      return;
    }

    final routeName = originalName.camelCase;
    final folder = originalName.snakeCase;

    if (file.readAsStringSync().contains('AppRoutes.$routeName')) return;

    addImportToFile(
        "import '/features/$folder/${folder}_initial_params.dart';", filePath);
    addImportToFile(
        "import '/features/$folder/${folder}_page.dart';", filePath);

    final fileContent = file.readAsStringSync();

    // Locate the `routes: [...]` list and find its matching closing bracket.
    final routesIndex = fileContent.indexOf('routes:');
    final listStart =
        routesIndex == -1 ? -1 : fileContent.indexOf('[', routesIndex);

    int? listEnd;
    if (listStart != -1) {
      int depth = 0;
      bool inString = false;
      String quote = '';
      for (int i = listStart; i < fileContent.length; i++) {
        final char = fileContent[i];
        if (inString) {
          if (char == r'\') {
            i++;
            continue;
          }
          if (char == quote) inString = false;
          continue;
        }
        if (char == "'" || char == '"') {
          inString = true;
          quote = char;
          continue;
        }
        if (char == '[') {
          depth++;
        } else if (char == ']') {
          depth--;
          if (depth == 0) {
            listEnd = i;
            break;
          }
        }
      }
    }

    if (listEnd == null) {
      context.logger
          .warn('⚠️  Could not find routes list in $filePath. Skipping.');
      return;
    }

    final lineStart = fileContent.lastIndexOf('\n', listEnd) + 1;
    final routeEntry = '''      GoRoute(
        path: AppRoutes.$routeName,
        builder: (context, state) => ${name}Page(
          cubit: getIt(param1: state.extra as ${name}InitialParams),
        ),
      ),
''';

    final updatedContent = '${fileContent.substring(0, lineStart)}'
        '$routeEntry'
        '${fileContent.substring(lineStart)}';

    file.writeAsStringSync(updatedContent);
  }

  addRouteToAppRoutes();
  addRouteToAppRouter();

  // Display completion message
  context.logger.info('🎉 Feature "$name" generated successfully!');

  progress.complete();
}
