import 'package:material_ui/material_ui.dart';

// ==================== BUILDCONTEXT EXTENSIONS ====================

extension BuildContextExtension on BuildContext {
  // Theme & Colors
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  // Screen & Layout
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  double get statusBarHeight => MediaQuery.of(this).padding.top;
  double get bottomPadding => MediaQuery.of(this).padding.bottom;
  EdgeInsets get safeAreaPadding => MediaQuery.of(this).padding;
  bool get isLandscape =>
      MediaQuery.of(this).orientation == Orientation.landscape;

  // Keyboard & Input
  bool get isKeyboardVisible => MediaQuery.of(this).viewInsets.bottom > 0;
  void hideKeyboard() => FocusScope.of(this).unfocus();
}

// // ==================== LOGGER SETUP ====================

// final Logger _appLogger = Logger(
//   printer: PrettyPrinter(
//     methodCount: 0,
//     errorMethodCount: 8,
//     lineLength: 120,
//     colors: true,
//     printEmojis: true,
//     printTime: false,
//   ),
// );

// // ==================== LOGGING EXTENSIONS ====================

// extension LogStringExtension on String {
//   /// Print this string as an error message
//   /// Example: "Something went wrong".printError();
//   void printError() => _appLogger.e(this);

//   /// Print this string as a success message
//   /// Example: "Task completed".printSuccess();
//   void printSuccess() => _appLogger.i('✅ $this');

//   /// Print this string as a warning message
//   /// Example: "Be careful".printWarning();
//   void printWarning() => _appLogger.w(this);

//   /// Print this string as an info message
//   /// Example: "User logged in".printInfo();
//   void printInfo() => _appLogger.i(this);

//   /// Print this string as a debug message
//   /// Example: "Debug value: $value".printDebug();
//   void printDebug() => _appLogger.d(this);

//   /// Print this string with custom styling
//   /// Example: "Important".printCustom(bold: true);
//   void printCustom({
//     String? color,
//     String? bgColor,
//     bool bold = false,
//     bool italic = false,
//     bool underline = false,
//   }) {
//     String styledMessage = this;
//     if (bold) styledMessage = '**$styledMessage**';
//     if (italic) styledMessage = '*$styledMessage*';
//     if (underline) styledMessage = '__${styledMessage}__';
//     _appLogger.i(styledMessage);
//   }
// }

// extension LogObjectExtension on Object {
//   /// Print this object as JSON with pretty formatting
//   /// Example: user.printJson();
//   void printJson() {
//     try {
//       _appLogger.i('JSON Data:');
//       _appLogger.i(this);
//     } catch (e) {
//       _appLogger.e('Failed to print JSON: $e');
//     }
//   }
// }
