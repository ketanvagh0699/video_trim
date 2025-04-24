import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_video_thumbnail_plus/flutter_video_thumbnail_plus.dart';

/// kTransparentImage image for placeholder
const List<int> transparentImageData = [
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
  0x42,
  0x60,
  0x82
];

final Uint8List kTransparentImage = Uint8List.fromList(transparentImageData);

/// Formats a [Duration] object to a human-readable string.
///
/// Example:
/// ```dart
/// final duration = Duration(hours: 1, minutes: 30, seconds: 15);
/// print(_formatDuration(duration)); // Output: 01:30:15
/// ```
String formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final hours = twoDigits(duration.inHours);
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));
  return '$hours:$minutes:$seconds';
}

// Maps quality (1–100) to FFmpeg scale (-q:v 1–31, lower is better quality)
int mapQualityToFFmpegScale(int quality) {
  if (quality < 1) return 1; // Best quality
  if (quality > 100) return 31; // Worst quality
  return ((101 - quality) / 3.25)
      .toInt()
      .clamp(1, 31); // Scale 1 (best) to 31 (worst)
}

/// Generates a stream of thumbnails for a given video.
///
/// This function generates a specified number of thumbnails for a video at
/// different timestamps and yields them as a stream of lists of byte arrays.
/// The thumbnails are generated using FFmpeg and stored temporarily on the
/// device.
///
/// Parameters:
/// - `videoPath` (required): The path to the video file.
/// - `videoDuration` (required): The duration of the video in milliseconds.
/// - `numberOfThumbnails` (required): The number of thumbnails to generate.
/// - `quality` (required): The quality of the thumbnails (percentage).
/// - `onThumbnailLoadingComplete` (required): A callback function that is
///   called when all thumbnails have been generated.
///
/// Returns:
/// A stream of lists of byte arrays, where each list contains the generated
/// thumbnails up to that point.
///
/// Example usage:
/// ```dart
/// final thumbnailStream = generateThumbnail(
///   videoPath: 'path/to/video.mp4',
///   videoDuration: 60000, // 1 minute
///   numberOfThumbnails: 10,
///   quality: 50,
///   onThumbnailLoadingComplete: () {
///     print('Thumbnails generated successfully!');
///   },
/// );
///
/// await for (final thumbnails in thumbnailStream) {
///   // Process the thumbnails
/// }
/// ```
///
/// Throws:
/// An error if the thumbnails could not be generated.
Stream<List<Uint8List?>> generateThumbnail({
  required String videoPath,
  required int videoDuration, // in milliseconds
  required int numberOfThumbnails,
  required int quality, // 0 to 100
  required VoidCallback onThumbnailLoadingComplete,
}) async* {
  final double eachPart = videoDuration / numberOfThumbnails;

  final List<Uint8List?> thumbnailBytes = [];
  Uint8List? lastBytes;

  // log('Generating thumbnails for video: $videoPath');
  // log('Total thumbnails to generate: $numberOfThumbnails');
  // log('Quality: $quality%');
  // log('Generating thumbnails...');
  // log('---------------------------------');

  try {
    for (int i = 1; i <= numberOfThumbnails; i++) {
      // log('Generating thumbnail $i / $numberOfThumbnails');

      Uint8List? bytes;

      final timestamp = (eachPart * i).toInt(); // milliseconds

      // Generate thumbnail using flutter_video_thumbnail_plus
      bytes = await FlutterVideoThumbnailPlus.thumbnailData(
        video: videoPath,
        timeMs: timestamp,
        imageFormat: ImageFormat.jpeg,
        quality: quality,
      );

      if (bytes != null) {
        // log('Timestamp: ${_formatDuration(Duration(milliseconds: timestamp))} | Size: ${(bytes.length / 1000).toStringAsFixed(2)} kB');
        // log('---------------------------------');
        lastBytes = bytes;
      } else {
        // log('Thumbnail generation failed at index $i, reusing last valid frame.');
        bytes = lastBytes;
      }

      thumbnailBytes.add(bytes);

      if (thumbnailBytes.length == numberOfThumbnails) {
        onThumbnailLoadingComplete();
      }

      yield List<Uint8List?>.from(thumbnailBytes);
    }

    // log('Thumbnails generated successfully!');
  } catch (e) {
    log('ERROR: Couldn\'t generate thumbnails: $e');
  }
}
