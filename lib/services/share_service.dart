import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'package:dream_boat_mobile/widgets/dream_share_card.dart';
import 'package:dream_boat_mobile/services/review_service.dart';

/// Service for creating and sharing dream interpretation cards.
/// 
/// This service handles:
/// - Rendering the DreamShareCard widget to an image using Screenshot package
/// - Saving the image to a temporary file
/// - Opening the native share sheet
class ShareService {
  static final ScreenshotController _screenshotController = ScreenshotController();
  
  /// Shares the dream interpretation as a visual card.
  /// 
  /// Creates a night-themed card with the interpretation text,
  /// renders it to an image, and opens the native share sheet.
  /// 
  /// Only the interpretation is shared - no personal data.
  static Future<void> shareInterpretation(
    BuildContext context,
    String interpretation,
    String watermark,
    String header,
  ) async {
    try {
      debugPrint('ShareService: Starting share process...');
      
      // Create the share card widget
      final card = DreamShareCard(
        interpretation: interpretation,
        watermark: watermark,
        header: header,
      );
      
      debugPrint('ShareService: Capturing widget to image...');
      
      // Use Screenshot package to capture the widget
      final Uint8List? imageBytes = await _screenshotController.captureFromWidget(
        card,
        delay: const Duration(milliseconds: 100),
        pixelRatio: 2.0, // High quality
        context: context,
      );
      
      if (imageBytes == null || imageBytes.isEmpty) {
        debugPrint('ShareService: Failed to capture widget');
        return;
      }
      
      debugPrint('ShareService: Image captured, size: ${imageBytes.length} bytes');
      
      // Save to temp file
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/dream_share_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(filePath);
      await file.writeAsBytes(imageBytes);
      
      debugPrint('ShareService: Image saved to: $filePath');
      
      final box = context.findRenderObject() as RenderBox?;
      
      // Share using native share sheet
      final result = await Share.shareXFiles(
        [XFile(filePath)],
        subject: 'Dream Interpretation',
        sharePositionOrigin: box != null ? box.localToGlobal(Offset.zero) & box.size : null,
      );
      
      // Trigger review flow after successful share (user is happy/engaged)
      if (context.mounted) {
        ReviewService.triggerReviewFlow(context);
      }
      
      debugPrint('ShareService: Share result: ${result.status}');
      
      // Clean up temp file after a delay
      Future.delayed(const Duration(minutes: 5), () {
        if (file.existsSync()) {
          file.deleteSync();
          debugPrint('ShareService: Temp file cleaned up');
        }
      });
      
    } catch (e, stackTrace) {
      debugPrint('ShareService: Error sharing interpretation: $e');
      debugPrint('ShareService: Stack trace: $stackTrace');
    }
  }
}
