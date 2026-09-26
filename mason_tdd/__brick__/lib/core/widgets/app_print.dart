// import 'package:logger/logger.dart';

// class MyFilter extends LogFilter {
//   @override
//   bool shouldLog(LogEvent event) {
//     return true;
//   }
// }

// class AppPrint {
//   static final Logger _logger = Logger(
//     printer: PrettyPrinter(
//       methodCount: 0,
//       errorMethodCount: 8,
//       lineLength: 120,
//       colors: true,
//       printEmojis: true,
//       printTime: false,
//     ),
//   );

//   /// Print error message in red
//   static void error(String message) {
//     _logger.e(message);
//   }

//   /// Print success message in green
//   static void success(String message) {
//     _logger.i('✅ $message');
//   }

//   /// Print warning message in yellow
//   static void warning(String message) {
//     _logger.w(message);
//   }

//   /// Print info message in blue
//   static void info(String message) {
//     _logger.i(message);
//   }

//   /// Print debug message in cyan
//   static void debug(String message) {
//     _logger.d(message);
//   }

//   /// Print custom message with specified color
//   static void custom(
//     String message, {
//     String? color,
//     String? bgColor,
//     bool bold = false,
//     bool italic = false,
//     bool underline = false,
//   }) {
//     // For custom styling, we'll use info level with custom formatting
//     String styledMessage = message;
//     if (bold) styledMessage = '**$styledMessage**';
//     if (italic) styledMessage = '*$styledMessage*';
//     if (underline) styledMessage = '__${styledMessage}__';

//     _logger.i(styledMessage);
//   }

//   /// Print JSON with pretty formatting
//   static void json(dynamic jsonData) {
//     try {
//       _logger.i('JSON Data:');
//       _logger.i(jsonData);
//     } catch (e) {
//       _logger.e('Failed to print JSON: $e');
//     }
//   }

//   /// Get the logger instance for advanced usage
//   static Logger get logger => _logger;
// }
