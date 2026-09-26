// import 'dart:io';

// import 'package:image_picker/image_picker.dart';
// import 'package:material_ui/material_ui.dart';
// import 'package:permission_handler/permission_handler.dart';

// class ImagePickerService {
//   static final ImagePickerService _instance = ImagePickerService._internal();
//   factory ImagePickerService() => _instance;
//   ImagePickerService._internal();

//   final ImagePicker _picker = ImagePicker();

//   /// Pick image from camera
//   Future<File?> pickImageFromCamera({
//     double? maxWidth,
//     double? maxHeight,
//     int? imageQuality,
//   }) async {
//     try {
//       // Check camera permission
//       final cameraStatus = await Permission.camera.status;
//       if (!cameraStatus.isGranted) {
//         final result = await Permission.camera.request();
//         if (!result.isGranted) {
//           throw Exception('Camera permission denied');
//         }
//       }

//       final XFile? image = await _picker.pickImage(
//         source: ImageSource.camera,
//         maxWidth: maxWidth,
//         maxHeight: maxHeight,
//         imageQuality: imageQuality ?? 80,
//       );

//       if (image != null) {
//         return File(image.path);
//       }
//       return null;
//     } catch (e) {
//       throw Exception('Failed to pick image from camera: $e');
//     }
//   }

//   /// Pick image from gallery
//   Future<File?> pickImageFromGallery({
//     double? maxWidth,
//     double? maxHeight,
//     int? imageQuality,
//   }) async {
//     try {
//       // Check storage permission
//       final storageStatus = await Permission.storage.status;
//       if (!storageStatus.isGranted) {
//         final result = await Permission.storage.request();
//         if (!result.isGranted) {
//           throw Exception('Storage permission denied');
//         }
//       }

//       final XFile? image = await _picker.pickImage(
//         source: ImageSource.gallery,
//         maxWidth: maxWidth,
//         maxHeight: maxHeight,
//         imageQuality: imageQuality ?? 80,
//       );

//       if (image != null) {
//         return File(image.path);
//       }
//       return null;
//     } catch (e) {
//       throw Exception('Failed to pick image from gallery: $e');
//     }
//   }

//   /// Pick multiple images from gallery
//   // Future<List<File>> pickMultipleImagesFromGallery({
//   //   double? maxWidth,
//   //   double? maxHeight,
//   //   int? imageQuality,
//   //   int maxImages = 10,
//   // }) async {
//   //   try {
//   //     // Check storage permission
//   //     final storageStatus = await Permission.storage.status;
//   //     if (!storageStatus.isGranted) {
//   //       final result = await Permission.storage.request();
//   //       if (!result.isGranted) {
//   //         throw Exception('Storage permission denied');
//   //       }
//   //     }

//   //     final List<XFile> images = await _picker.pickMultiImage(
//   //       maxWidth: maxWidth,
//   //       maxHeight: maxHeight,
//   //       imageQuality: imageQuality ?? 80,
//   //     );

//   //     if (images.isNotEmpty) {
//   //       // Limit the number of images
//   //       final limitedImages = images.take(maxImages).toList();
//   //       return limitedImages.map((image) => File(image.path)).toList();
//   //     }
//   //     return [];
//   //   } catch (e) {
//   //     throw Exception('Failed to pick multiple images: $e');
//   //   }
//   // }

//   Future<List<File>> pickMultipleImagesFromGallery({
//     double? maxWidth,
//     double? maxHeight,
//     int? imageQuality,
//     int maxImages = 10,
//   }) async {
//     try {
//       // Check correct permission depending on Android version
//       final photosPermission = await Permission.photos.status;
//       final storagePermission = await Permission.storage.status;

//       if (!photosPermission.isGranted && !storagePermission.isGranted) {
//         final result = await Permission.photos.request();
//         if (!result.isGranted) {
//           // fallback for older Android versions
//           final storageResult = await Permission.storage.request();
//           if (!storageResult.isGranted) {
//             throw Exception('Storage permission denied');
//           }
//         }
//       }

//       final List<XFile> images = await _picker.pickMultiImage(
//         maxWidth: maxWidth,
//         maxHeight: maxHeight,
//         imageQuality: imageQuality ?? 80,
//       );

//       if (images.isNotEmpty) {
//         // Limit the number of images
//         final limitedImages = images.take(maxImages).toList();
//         return limitedImages.map((image) => File(image.path)).toList();
//       }
//       return [];
//     } catch (e) {
//       throw Exception('Failed to pick multiple images: $e');
//     }
//   }

//   /// Show image picker dialog
//   Future<File?> showImagePickerDialog({
//     required BuildContext context,
//     double? maxWidth,
//     double? maxHeight,
//     int? imageQuality,
//   }) async {
//     return showDialog<File?>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Select Image'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.camera_alt),
//                 title: const Text('Camera'),
//                 onTap: () async {
//                   Navigator.of(context).pop();
//                   try {
//                     final file = await pickImageFromCamera(
//                       maxWidth: maxWidth,
//                       maxHeight: maxHeight,
//                       imageQuality: imageQuality,
//                     );
//                     Navigator.of(context).pop(file);
//                   } catch (e) {
//                     Navigator.of(context).pop();
//                     _showErrorSnackBar(context, e.toString());
//                   }
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.photo_library),
//                 title: const Text('Gallery'),
//                 onTap: () async {
//                   Navigator.of(context).pop();
//                   try {
//                     final file = await pickImageFromGallery(
//                       maxWidth: maxWidth,
//                       maxHeight: maxHeight,
//                       imageQuality: imageQuality,
//                     );
//                     Navigator.of(context).pop(file);
//                   } catch (e) {
//                     Navigator.of(context).pop();
//                     _showErrorSnackBar(context, e.toString());
//                   }
//                 },
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text('Cancel'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   /// Show bottom sheet for image picker
//   Future<File?> showImagePickerBottomSheet({
//     required BuildContext context,
//     double? maxWidth,
//     double? maxHeight,
//     int? imageQuality,
//   }) async {
//     return showModalBottomSheet<File?>(
//       context: context,
//       builder: (BuildContext context) {
//         return Container(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text(
//                 'Select Image Source',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   _buildImageSourceOption(
//                     context: context,
//                     icon: Icons.camera_alt,
//                     label: 'Camera',
//                     onTap: () async {
//                       Navigator.of(context).pop();
//                       try {
//                         final file = await pickImageFromCamera(
//                           maxWidth: maxWidth,
//                           maxHeight: maxHeight,
//                           imageQuality: imageQuality,
//                         );
//                         Navigator.of(context).pop(file);
//                       } catch (e) {
//                         Navigator.of(context).pop();
//                         _showErrorSnackBar(context, e.toString());
//                       }
//                     },
//                   ),
//                   _buildImageSourceOption(
//                     context: context,
//                     icon: Icons.photo_library,
//                     label: 'Gallery',
//                     onTap: () async {
//                       Navigator.of(context).pop();
//                       try {
//                         final file = await pickImageFromGallery(
//                           maxWidth: maxWidth,
//                           maxHeight: maxHeight,
//                           imageQuality: imageQuality,
//                         );
//                         Navigator.of(context).pop(file);
//                       } catch (e) {
//                         Navigator.of(context).pop();
//                         _showErrorSnackBar(context, e.toString());
//                       }
//                     },
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildImageSourceOption({
//     required BuildContext context,
//     required IconData icon,
//     required String label,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             width: 80,
//             height: 80,
//             decoration: BoxDecoration(
//               color: Theme.of(context).primaryColor.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Icon(icon, size: 40, color: Theme.of(context).primaryColor),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             label,
//             style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showErrorSnackBar(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red,
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }

//   /// Get image file size in MB
//   double getImageFileSize(File file) {
//     final bytes = file.lengthSync();
//     return bytes / (1024 * 1024); // Convert to MB
//   }

//   /// Check if image file size is within limit
//   bool isImageSizeValid(File file, double maxSizeMB) {
//     final fileSize = getImageFileSize(file);
//     return fileSize <= maxSizeMB;
//   }

//   /// Validate image file
//   bool isValidImageFile(File file) {
//     final validExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp'];
//     final fileName = file.path.toLowerCase();
//     return validExtensions.any(fileName.endsWith);
//   }
// }
